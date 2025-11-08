package com.service.backend.services;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.service.backend.DTO.DataTransform.response.exercise.ExerciseDailyResponseDTO;
import com.service.backend.DTO.enumdata.ExerciseType;
import com.service.backend.models.ExerciseDaily;
import com.service.backend.models.ExerciseDetails;
import com.service.backend.models.User;
import com.service.backend.repository.ExerciseDailyRepository;
import com.service.backend.repository.ExerciseDetailsRepository;
import com.service.backend.services.ExerciseGenerationService.ExerciseQuiz;

@Service
public class ExerciseDailyService {
    @Autowired
    private ExerciseDailyRepository exerciseDailyRepository;

    @Autowired
    private ExerciseDetailsRepository exerciseDetailsRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private ObjectMapper objectMapper;

    @Transactional(readOnly = true)
    public List<ExerciseDaily> getAllExerciseDailys() {
        return exerciseDailyRepository.findAll();
    }

    @Transactional(readOnly = true)
    public ExerciseDaily getExerciseDailyById(Long id) {
        return exerciseDailyRepository.findById(id).orElse(null);
    }

    @Transactional
    public ExerciseDailyResponseDTO saveExerciseDaily(ExerciseQuiz exerciseRequest, String userId) {
        User user = userService.getUserById(userId);
        if (user == null) {
            throw new RuntimeException("User not found: " + userId);
        }

        ExerciseDaily entity = ExerciseDaily.builder()
                .user(user)
                .date(LocalDateTime.now())
                .totalQuestions(exerciseRequest.getQuestions().size())
                .exerciseType(ExerciseType.valueOf(exerciseRequest.getType()))
                .build();
        
        ExerciseDaily savedSummary = exerciseDailyRepository.save(entity);
        
        List<ExerciseDetails> detailEntities = exerciseRequest.getQuestions().stream().map(dr -> {
            ExerciseDetails detail = ExerciseDetails.builder()
                .exDaily(savedSummary)
                .question(dr.getQuestionText())
                .trueAnswer(dr.getCorrectAnswer())
                .questionType(dr.getQuestionType())
                .build();
            
            if (dr.getOptions() != null && !dr.getOptions().isEmpty()) {
                try {
                    String optionsJson = objectMapper.writeValueAsString(dr.getOptions());
                    detail.setOptions(optionsJson);
                } catch (JsonProcessingException e) {
                    detail.setOptions("[]");
                }
            } else {
                detail.setOptions("[]");
            }
            
            return detail;
        }).collect(Collectors.toList());
        
        List<ExerciseDetails> savedDetails = exerciseDetailsRepository.saveAll(detailEntities);
        ExerciseDailyResponseDTO response = new ExerciseDailyResponseDTO(savedSummary, savedDetails);

        // update streak
        updateUserStreak(user, savedSummary.getDate().toLocalDate());

        return response;
    }

    private void updateUserStreak(User user, LocalDate exerciseDate) {
        boolean streakWasReset = false;

        if (user.getLastStreakActiveDate() != null) {
            LocalDate lastDate = convertToLocalDate(user.getLastStreakActiveDate());
            
            if (lastDate.equals(exerciseDate.minusDays(1))) {
                user.setStreak(user.getStreak() + 1);
            } else if (!lastDate.isEqual(exerciseDate)) {
                user.setStreak(1);
                streakWasReset = true;
            }
        } else {
            user.setStreak(1);
        }
        
        if (!streakWasReset || user.getLastStreakActiveDate() == null) {
            user.setLastStreakActiveDate(convertToDate(exerciseDate));
            userService.saveUser(user);
        }
    }

    private LocalDate convertToLocalDate(Date dateToConvert) {
        if (dateToConvert == null) {
            return null;
        }
        
        if (dateToConvert instanceof java.sql.Date) {
            return ((java.sql.Date) dateToConvert).toLocalDate();
        } else {
            return dateToConvert.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
        }
    }

    private Date convertToDate(LocalDate dateToConvert) {
        if (dateToConvert == null) {
            return null;
        }
        return java.sql.Date.valueOf(dateToConvert);
    }

    @Transactional
    public boolean deleteExerciseDaily(Long id) {
        try {
            exerciseDailyRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional(readOnly = true)
    public List<ExerciseDaily> getResultsByDate(String userId, LocalDate date) {
        return exerciseDailyRepository.findByUserIdAndDate(userId, date);
    }

    @Transactional(readOnly = true)
    public List<ExerciseDetails> getExerciseDetailsByExId(Long exId) {
        return exerciseDetailsRepository.findByExDailyID(exId);
    }
}
