package com.service.backend.controllers;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.DataTransform.response.dictionary.SearchWordResponseDTO;
import com.service.backend.DTO.DataTransform.response.dictionary.VocabularyDetailDTO;
import com.service.backend.models.Dictionary;
import com.service.backend.models.VocabularyDetails;
import com.service.backend.services.DictionaryService;

@RestController
@RequestMapping("/dictionary")
public class DictionaryController {

    @Autowired
    private DictionaryService dictionaryService;

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<SearchWordResponseDTO>> searchWord(@RequestParam String word) {
        try {
            Dictionary dict = dictionaryService.findByWordOptimized(word);

            if (dict == null) {
                return ResponseEntity.ok(ApiResponse.<SearchWordResponseDTO>builder()
                        .success(false).message("Word not found.").build());
            }
            
            List<VocabularyDetails> detailsEntities = dictionaryService.findAllVocabularyDetails(dict.getId());

            List<VocabularyDetailDTO> detailsDTOs = detailsEntities.stream()
                    .map(VocabularyDetailDTO::new)
                    .collect(Collectors.toList());

            SearchWordResponseDTO responseDTO = SearchWordResponseDTO.builder()
                    .vocabulary(dict.getVocabulary())
                    .level(dict.getLevel())
                    .transcriptionUk(dict.getTranscriptionUk())
                    .transcriptionUs(dict.getTranscriptionUs())
                    .details(detailsDTOs)
                    .build();
            
            return ResponseEntity.ok(ApiResponse.<SearchWordResponseDTO>builder()
                    .success(true).data(responseDTO).build());

        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<SearchWordResponseDTO>builder()
                    .success(false).message(e.getMessage()).build());
        }
    }
}