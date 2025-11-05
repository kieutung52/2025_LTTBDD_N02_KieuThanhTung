package com.service.backend.controllers;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.DataTransform.request.exercise.GenerateExerciseRequestDTO;
import com.service.backend.DTO.DataTransform.request.exercise.GradingRequestDTO;
import com.service.backend.DTO.DataTransform.response.exercise.ExerciseDailyResponseDTO;
import com.service.backend.DTO.DataTransform.response.exercise.GradingResponseDTO;
import com.service.backend.models.ExerciseDaily;
import com.service.backend.services.ExerciseDailyService;
import com.service.backend.services.ExerciseGenerationService;

@RestController
@RequestMapping("/exercise")
@PreAuthorize("hasRole('USER')")
public class ExerciseController {

    @Autowired
    private ExerciseGenerationService exerciseGenerationService;

    @Autowired
    private ExerciseDailyService exerciseDailyService;

    @PostMapping("/generate")
    public ResponseEntity<ApiResponse<Object>> generateExercise(
        @RequestBody GenerateExerciseRequestDTO request,
        @AuthenticationPrincipal Jwt jwt
        ) {
        try {
            String userId = jwt.getSubject();
            Object exerciseJson = exerciseGenerationService.generateExerciseFromWordIds(request.getDictionaryIds(), userId);
            return ResponseEntity.ok(ApiResponse.<Object>builder()
                    .success(true)
                    .message("Exercise generated successfully.")
                    .data(exerciseJson) 
                    .build());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<Object>builder()
                    .success(false)
                    .message(e.getMessage())
                    .build());
        }
    }

    @PostMapping("/grade")
    public ResponseEntity<ApiResponse<GradingResponseDTO>> gradeExercise(
            @RequestBody GradingRequestDTO request,
            @AuthenticationPrincipal Jwt jwt) {
        try {
            GradingResponseDTO gradingResult = exerciseGenerationService.gradeExercise(request);
            return ResponseEntity.ok(ApiResponse.<GradingResponseDTO>builder()
                    .success(true)
                    .message("Exercise graded successfully")
                    .data(gradingResult)
                    .build());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<GradingResponseDTO>builder()
                    .success(false)
                    .message("Grading failed: " + e.getMessage())
                    .build());
        }
    }

    @GetMapping("/results")
    public ResponseEntity<ApiResponse<List<ExerciseDailyResponseDTO>>> getResults(
        @AuthenticationPrincipal Jwt jwt,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
    try {
        String userId = jwt.getSubject();
        List<ExerciseDaily> results = exerciseDailyService.getResultsByDate(userId, date);

        List<ExerciseDailyResponseDTO> dtos = results.stream()
            .map(ExerciseDailyResponseDTO::new)
            .collect(Collectors.toList());

        return ResponseEntity.ok(ApiResponse.<List<ExerciseDailyResponseDTO>>builder()
                .success(true)
                .data(dtos)
                .build());
    } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<List<ExerciseDailyResponseDTO>>builder()
                    .success(false)
                    .message(e.getMessage())
                    .build());
        }
    }
}
