package com.service.backend.controllers;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.datapattern.NewWord;
import com.service.backend.DTO.datapattern.WordToLookUp;
import com.service.backend.services.seeding_data.SeedingService;

@RestController
@RequestMapping("/seeding")
@PreAuthorize("hasRole('ADMIN')")
public class SeedingController {

    @Autowired
    private SeedingService seedingService;

    @PostMapping("/add-word")
    public ResponseEntity<ApiResponse<String>> addWord(@RequestBody NewWord newWord) {
        boolean added = WordToLookUp.addWord(newWord.getNewWord());
        if (added) {
            return ResponseEntity.ok(ApiResponse.<String>builder()
                    .success(true)
                    .message("Word '" + newWord.getNewWord() + "' added. Current queue: " + WordToLookUp.getWords().size() + "/40")
                    .data(String.join(", ", WordToLookUp.getWords()))
                    .build());
        } else {
            return ResponseEntity.badRequest().body(ApiResponse.<String>builder()
                    .success(false)
                    .message("Word not added. Queue might be full (40/40) or word already exists.")
                    .data(String.join(", ", WordToLookUp.getWords()))
                    .build());
        }
    }

    @PostMapping("/run")
    public ResponseEntity<ApiResponse<Void>> runSeeding() {
        try {
            seedingService.lookupWordsAndSaveToFile();
            return ResponseEntity.ok(ApiResponse.<Void>builder()
                    .success(true)
                    .message("Seeding process started successfully.")
                    .build());
        } catch (IOException e) {
            return ResponseEntity.status(500).body(ApiResponse.<Void>builder()
                    .success(false)
                    .message("Seeding failed: " + e.getMessage())
                    .build());
        }
    }
}
