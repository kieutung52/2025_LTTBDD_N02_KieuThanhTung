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
import com.service.backend.DTO.DataTransform.response.dictionary.VocabularyForGenerateExercise;
import com.service.backend.DTO.DataTransform.response.exercise.ExerciseDailyResponseDTO;
import com.service.backend.DTO.DataTransform.response.exercise.GradingResponseDTO;
import com.service.backend.models.ExerciseDaily;
import com.service.backend.models.ExerciseDetails;
import com.service.backend.repository.ExerciseDailyRepository;
import com.service.backend.repository.ExerciseDetailsRepository;

import lombok.Getter;
import lombok.Setter;

@Service
public class ExerciseGenerationService {

    @Autowired
    private GeminiService geminiService;

    @Autowired
    private ExerciseDailyService exerciseDailyService;

    @Autowired
    private DictionaryService dictionaryService;

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
        // Validate input
        if (dictionaryIds == null || dictionaryIds.isEmpty()) {
            throw new RuntimeException("Dictionary IDs cannot be null or empty");
        }
        
        List<VocabularyForGenerateExercise> dicts = dictionaryService.findAllVocabularyWithDetails(dictionaryIds);

        if (dicts.isEmpty()) {
            throw new RuntimeException("No valid words found to generate exercise.");
        }
        
        List<String> wordListWithMeaning = dicts.stream()
            .map(dict -> String.format("%s (nghĩa: %s)", dict.getVocabulary(), dict.getMeaning()))
            .collect(Collectors.toList());
        
        String wordListString = String.join(", ", wordListWithMeaning);

        String prompt = exercisePromptTemplate
            .replace("${word_list_with_meaning}", wordListString)
            .replace("Ưu tiên 3 câu \"MULTIPLE_CHOICE\" (chọn nghĩa đúng) và 2 câu \"OPEN_ENDED\" (viết lại câu hoặc điền vào chỗ trống).", 
                    "Tạo chính xác 5 câu hỏi \"MULTIPLE_CHOICE\" (chọn nghĩa đúng).")
            .replace("3.  **LOẠI CÂU HỎI:** Tạo chính xác 5 câu hỏi. Ưu tiên 3 câu \"MULTIPLE_CHOICE\" (chọn nghĩa đúng) và 2 câu \"OPEN_ENDED\" (viết lại câu hoặc điền vào chỗ trống).",
                    "3.  **LOẠI CÂU HỎI:** Tạo chính xác 5 câu hỏi \"MULTIPLE_CHOICE\" (chọn nghĩa đúng).");

        System.out.println("=== PROMPT SENT TO AI ===");
        System.out.println(prompt);
        System.out.println("=== END PROMPT ===");

        String jsonResponse = geminiService.getGeminiResponse(prompt);
        System.out.println("=== RAW RESPONSE FROM AI ===");
        System.out.println(jsonResponse);
        System.out.println("=== END RAW RESPONSE ===");
        
        String cleanedJson = cleanGeminiResponse(jsonResponse);

        try {
            ExerciseQuiz quiz = objectMapper.readValue(cleanedJson, ExerciseQuiz.class);
            return exerciseDailyService.saveExerciseDaily(quiz, userId);
        } catch (JsonProcessingException e) {
            System.err.println("JSON Parse Error: " + e.getMessage());
            System.err.println("Cleaned JSON that failed to parse: " + cleanedJson);
            throw new RuntimeException("Failed to parse exercise JSON from Gemini: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Unexpected error during exercise generation: " + e.getMessage());
        }
    }
    
    public GradingResponseDTO gradeExercise(GradingRequestDTO gradingRequest) {
        try {
            ExerciseDaily exerciseDaily = exerciseDailyService.getExerciseDailyById(gradingRequest.getExerciseDailyId());
            if (exerciseDaily == null) {
                throw new RuntimeException("Exercise not found with id: " + gradingRequest.getExerciseDailyId());
            }
            
            List<ExerciseDetails> exerciseDetails = exerciseDetailsRepository.findByExDailyID(gradingRequest.getExerciseDailyId());
            
            Map<Long, String> correctAnswerMap = exerciseDetails.stream()
                .collect(Collectors.toMap(ExerciseDetails::getID, ExerciseDetails::getTrueAnswer));
            
            Map<String, Object> exerciseData = new HashMap<>();
            exerciseData.put("exercise", exerciseDetails.stream().map(ed -> {
                Map<String, Object> questionMap = new HashMap<>();
                questionMap.put("questionId", ed.getID());
                questionMap.put("question", ed.getQuestion());
                questionMap.put("correctAnswer", ed.getTrueAnswer());
                questionMap.put("questionType", ed.getQuestionType());
                
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

            System.out.println("=== GRADING PROMPT ===");
            System.out.println(prompt);
            System.out.println("=== END GRADING PROMPT ===");

            String jsonResponse = geminiService.getGeminiResponse(prompt);
            String cleanedJson = cleanGeminiResponse(jsonResponse);

            System.out.println("=== GRADING RESPONSE ===");
            System.out.println(cleanedJson);
            System.out.println("=== END GRADING RESPONSE ===");

            GradingResponseDTO gradingResult = objectMapper.readValue(cleanedJson, GradingResponseDTO.class);
            gradingResult.setExerciseDailyId(exerciseDaily.getID());
            recalculateCorrectAnswers(gradingResult, correctAnswerMap, studentAnswers);
            
            updateExerciseResults(exerciseDaily, gradingResult);
            
            return gradingResult;
            
        } catch (Exception e) {
            throw new RuntimeException("Failed to grade exercise: " + e.getMessage());
        }
    }

    private void recalculateCorrectAnswers(GradingResponseDTO gradingResult, 
                                        Map<Long, String> correctAnswerMap,
                                        Map<String, String> studentAnswers) {
        int correctCount = 0;
        
        for (GradingResponseDTO.QuestionResultDTO result : gradingResult.getResults()) {
            Long questionId = result.getQuestionId();
            String userAnswer = studentAnswers.get(questionId.toString());
            String correctAnswer = correctAnswerMap.get(questionId);
            
            boolean isActuallyCorrect = userAnswer != null && 
                                    correctAnswer != null && 
                                    userAnswer.trim().equalsIgnoreCase(correctAnswer.trim());
            
            result.setCorrect(isActuallyCorrect);
            
            if (isActuallyCorrect) {
                correctCount++;
            }
            
            if (isActuallyCorrect && result.getExplanation().contains("chưa chính xác")) {
                result.setExplanation(result.getExplanation().replace("chưa chính xác", "hoàn toàn chính xác"));
            }
        }
        
        gradingResult.setCorrectAnswers(correctCount);
        gradingResult.setTotalQuestions(gradingResult.getResults().size());
        gradingResult.setScore((double) correctCount / gradingResult.getTotalQuestions() * 100);
    }

    private void updateExerciseResults(ExerciseDaily exerciseDaily, GradingResponseDTO gradingResult) {
        exerciseDaily.setCorrectAnswers(gradingResult.getCorrectAnswers());
        exerciseDailyRepository.save(exerciseDaily);

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