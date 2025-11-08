package com.service.backend.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.DataTransform.request.learning.UpdateProgressRequest;
import com.service.backend.DTO.DataTransform.response.dictionary.DictionaryPersonalDTO;
import com.service.backend.services.DictionaryPersonalService;

@RestController
@RequestMapping("/lesson")
public class LearningController {

    @Autowired
    private DictionaryPersonalService dictionaryPersonalService;

    @GetMapping("/daily")
    public ResponseEntity<ApiResponse<List<DictionaryPersonalDTO>>> getDailyLesson(@AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();
        List<DictionaryPersonalDTO> lesson = dictionaryPersonalService.getDailyLesson(userId);
        return ResponseEntity.ok(ApiResponse.<List<DictionaryPersonalDTO>>builder()
                .success(true)
                .message("Daily lesson fetched successfully.")
                .data(lesson)
                .build());
    }

    @PostMapping("/progress")
    public ResponseEntity<ApiResponse<Void>> updateProgress(
            @AuthenticationPrincipal Jwt jwt,
            @RequestBody UpdateProgressRequest request
    ) {
        String userId = jwt.getSubject();
        dictionaryPersonalService.updateLearningProgress(userId, request);
        return ResponseEntity.ok(ApiResponse.<Void>builder()
                .success(true)
                .message("Learning progress updated.")
                .build());
    }
}