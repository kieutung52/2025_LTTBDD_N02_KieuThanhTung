package com.service.backend.services;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.service.backend.DTO.DataTransform.request.exercise.GradingRequestDTO;
import com.service.backend.DTO.DataTransform.response.exercise.ExerciseDailyResponseDTO;
import com.service.backend.DTO.DataTransform.response.exercise.GradingResponseDTO;
import com.service.backend.models.Dictionary;
import com.service.backend.models.ExerciseDaily;
import com.service.backend.models.ExerciseDetails;
import com.service.backend.models.VocabularyDetails;
import com.service.backend.repository.DictionaryRepository;
import com.service.backend.repository.ExerciseDailyRepository;
import com.service.backend.repository.ExerciseDetailsRepository;
import com.service.backend.repository.VocabularyDetailsRepository;

import lombok.Getter;
import lombok.Setter;

@Service
public class ExerciseGenerationService {

    @Autowired
    private GeminiService geminiService;

    @Autowired
    private ExerciseDailyService exerciseDailyService;

    @Autowired
    private DictionaryRepository dictionaryRepository;

    @Autowired
    private VocabularyDetailsRepository vocabularyDetailsRepository;

    @Autowired
    private ExerciseDetailsRepository exerciseDetailsRepository;

    @Autowired
    private ExerciseDailyRepository exerciseDailyRepository;

    @Autowired
    private ObjectMapper objectMapper;

    private final String exercisePromptTemplate;

    private final String gradeExercisePromptTemplate;

    @Getter
    @Setter
    public static class ExerciseQuiz {
        private String title;
        private String type;
        private String level;
        private String document;
        private List<Question> questions;
        @Getter
        @Setter
        public static class Question {
            private String id;
            private String questionType;
            private String questionText;
            private List<String> options;
            private String correctAnswer;
        }
    }

    public ExerciseGenerationService(
            @Value("classpath:data/prompts/prompt_GenerateExercise.txt") Resource promptResource,
            @Value("classpath:data/prompts/prompt_GradeExercise.txt") Resource promptgradeExercise
    ) throws IOException {
        this.gradeExercisePromptTemplate = new String(promptgradeExercise.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        this.exercisePromptTemplate = new String(promptResource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    }

    @Transactional
    public ExerciseDailyResponseDTO generateExerciseFromWordIds(List<Long> dictionaryIds, String userId) {
        List<Dictionary> dicts = dictionaryRepository.findAllById(dictionaryIds);

        List<VocabularyDetails> allDetails = vocabularyDetailsRepository.findByDictionary_IdIn(dictionaryIds);

        Map<Long, String> meaningMap = allDetails.stream()
            .collect(Collectors.groupingBy(
                detail -> detail.getDictionary().getId(),
                Collectors.mapping(VocabularyDetails::getMeaning, Collectors.joining(", ")) // Lấy nghĩa
            ));

        List<String> wordListWithMeaning = dicts.stream()
            .map(dict -> {
                String meaning = meaningMap.getOrDefault(dict.getId(), "N/A");
                return String.format("%s (nghĩa: %s)", dict.getVocabulary(), meaning);
            })
            .collect(Collectors.toList());

        if (wordListWithMeaning.isEmpty()) {
            throw new RuntimeException("No valid words found to generate exercise.");
        }
        
        String wordListString = String.join(", ", wordListWithMeaning);

        String prompt = exercisePromptTemplate.replace("${word_list_with_meaning}", wordListString)
                .replace("Tạo chính xác 5 câu hỏi. Ưu tiên 3 câu \"MULTIPLE_CHOICE\"", "Tạo chính xác 5 câu hỏi \"MULTIPLE_CHOICE\" only.")
                .replace("2 câu \"OPEN_ENDED\"", "");

        System.out.println(prompt);
        String jsonResponse = geminiService.getGeminiResponse(prompt);
        String cleanedJson = cleanGeminiResponse(jsonResponse);

        try {
            ExerciseQuiz quiz = objectMapper.readValue(cleanedJson, ExerciseQuiz.class);
            return exerciseDailyService.saveExerciseDaily(quiz, userId);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to parse exercise JSON from Gemini: " + e.getMessage());
        }
    }
    
    public GradingResponseDTO gradeExercise(GradingRequestDTO gradingRequest) {
        try {
            // Lấy thông tin bài tập từ database
            ExerciseDaily exerciseDaily = exerciseDailyService.getExerciseDailyById(gradingRequest.getExerciseDailyId());
            if (exerciseDaily == null) {
                throw new RuntimeException("Exercise not found with id: " + gradingRequest.getExerciseDailyId());
            }
            
            List<ExerciseDetails> exerciseDetails = exerciseDetailsRepository.findByExDailyID(gradingRequest.getExerciseDailyId());
            
            // Chuẩn bị dữ liệu cho prompt với type safety
            Map<String, Object> exerciseData = new HashMap<>();
            exerciseData.put("exercise", exerciseDetails.stream().map(ed -> {
                Map<String, Object> questionMap = new HashMap<>();
                questionMap.put("questionId", ed.getID());
                questionMap.put("question", ed.getQuestion());
                questionMap.put("correctAnswer", ed.getTrueAnswer());
                questionMap.put("questionType", ed.getQuestionType());
                
                // Sửa lỗi type safety với TypeReference
                if (ed.getOptions() != null && !ed.getOptions().isEmpty()) {
                    try {
                        List<String> options = objectMapper.readValue(
                            ed.getOptions(), 
                            new TypeReference<List<String>>() {}
                        );
                        questionMap.put("options", options);
                    } catch (Exception e) {
                        questionMap.put("options", new ArrayList<String>());
                    }
                } else {
                    questionMap.put("options", new ArrayList<String>());
                }
                return questionMap;
            }).collect(Collectors.toList()));

            Map<String, String> studentAnswers = gradingRequest.getAnswers().stream()
                .collect(Collectors.toMap(
                    answer -> answer.getQuestionId().toString(),
                    GradingRequestDTO.QuestionAnswerDTO::getUserAnswer
                ));

            String exerciseJson = objectMapper.writeValueAsString(exerciseData);
            String answersJson = objectMapper.writeValueAsString(studentAnswers);

            String prompt = gradeExercisePromptTemplate
                .replace("${exercise_data}", exerciseJson)
                .replace("${student_answers}", answersJson);

            // Gọi Gemini API
            String jsonResponse = geminiService.getGeminiResponse(prompt);
            String cleanedJson = cleanGeminiResponse(jsonResponse);

            // Parse kết quả từ Gemini
            GradingResponseDTO gradingResult = objectMapper.readValue(cleanedJson, GradingResponseDTO.class);
            
            // Cập nhật kết quả vào database
            updateExerciseResults(exerciseDaily, gradingResult);
            
            return gradingResult;
            
        } catch (Exception e) {
            throw new RuntimeException("Failed to grade exercise: " + e.getMessage());
        }
    }

    private void updateExerciseResults(ExerciseDaily exerciseDaily, GradingResponseDTO gradingResult) {
        // Cập nhật tổng điểm cho exercise daily - SỬ DỤNG biến exerciseDaily
        exerciseDaily.setCorrectAnswers(gradingResult.getCorrectAnswers());
        exerciseDailyRepository.save(exerciseDaily);

        // Cập nhật từng câu hỏi
        for (GradingResponseDTO.QuestionResultDTO result : gradingResult.getResults()) {
            ExerciseDetails detail = exerciseDetailsRepository.findById(result.getQuestionId()).orElse(null);
            if (detail != null) {
                detail.setUserAnswer(result.getUserAnswer());
                detail.setCorrect(result.isCorrect());
                detail.setAiExplain(result.getExplanation());
                exerciseDetailsRepository.save(detail);
            }
        }
    }

    private String cleanGeminiResponse(String response) {
        response = response.trim();
        if (response.startsWith("```json")) {
            response = response.substring(7);
        }
        if (response.endsWith("```")) {
            response = response.substring(0, response.length() - 3);
        }
        return response.trim();
    }
}