package com.service.backend.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.DataTransform.request.exercise.ExerciseDailyRequest;
import com.service.backend.DTO.enumdata.ExerciseType;
import com.service.backend.models.ExerciseDaily;
import com.service.backend.repository.ExerciseDailyRepository;


@Service
public class ExerciseDailyService {
    @Autowired
    private ExerciseDailyRepository exerciseDailyRepository;

    @Autowired
    private UserService userService;

    @Transactional(readOnly = true)
    public List<ExerciseDaily> getAllExerciseDailys() {
        return exerciseDailyRepository.findAll();
    }

    @Transactional(readOnly = true)
    public ExerciseDaily getExerciseDailyById(int id) {
        return exerciseDailyRepository.findById(id).orElse(null);
    }

    // Create or Update
    @Transactional
    public ExerciseDaily saveExerciseDaily(ExerciseDailyRequest exerciseDaily) {
        return exerciseDailyRepository.save(ExerciseDaily.builder()
                .user(userService.getUserById(exerciseDaily.getUserID()))
                .date(LocalDateTime.now())
                .totalQuestions(exerciseDaily.getTotalQuestions())
                .correctAnswers(exerciseDaily.getCorrectAnswers())
                .analytics(exerciseDaily.getAnalytics())
                .exerciseType(ExerciseType.valueOf(exerciseDaily.getExerciseType()))
                .build());
    }

    @Transactional
    public boolean deleteExerciseDaily(int id) {
        try {
            exerciseDailyRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
