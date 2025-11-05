package com.service.backend.services.seeding_data;

import com.service.backend.DTO.datapattern.WordToLookUp;
import com.service.backend.DTO.structurejson.VocabularyData;
import com.service.backend.services.DictionaryService;
import com.service.backend.services.GeminiService;
import com.service.backend.services.VocabularyDetailsService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@Service
public class SeedingService {

    private final VocabularyDetailsService vocabularyDetailsService;
    private List<VocabularyData> data = new ArrayList<>();
    private boolean isProcessing = false;
    private final GeminiService geminiService;
    private final DictionaryService dictionaryService;
    private final ObjectMapper objectMapper;
    private final String promptTemplate;

    public SeedingService(GeminiService geminiService,
                          ObjectMapper objectMapper,
                          DictionaryService dictionaryService,
                          @Value("classpath:data/prompts/prompt_TraCuuTuVung.txt") Resource promptResource, 
                          VocabularyDetailsService vocabularyDetailsService) throws IOException {
        this.geminiService = geminiService;
        this.dictionaryService = dictionaryService;
        this.objectMapper = objectMapper;
        this.promptTemplate = new String(promptResource.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
        this.vocabularyDetailsService = vocabularyDetailsService;
    }

    public void lookupWordsAndSaveToFile() throws IOException {
        if (isProcessing) {
            System.out.println("A lookup process is already running. Please wait until it finishes.");
            return;
        }
        isProcessing = true;
        String completePrompt = buildCompletePrompt();
        System.out.println("Complete Prompt:\n" + completePrompt);
        if (completePrompt == null) {
            System.out.println("No words to look up. Skipping.");
            return;
        }

        // Call Gemini API
        System.out.println("Sending prompt to Gemini...");
        String jsonResponse = geminiService.getGeminiResponse(completePrompt);

        // Handle Gemini response
        String cleanedJson = cleanGeminiResponse(jsonResponse);

        // Parse and save directly to DB (removed file save)
        data = objectMapper.readValue(cleanedJson, new TypeReference<List<VocabularyData>>() {});
        SaveToDatabase();
        data.clear();
        
        // Clear the words after processing
        WordToLookUp.clearWords();
        isProcessing = false;
    }

    private String buildCompletePrompt() {
        List<String> words = WordToLookUp.getWords();
        if (words == null || words.isEmpty()) {
            return null;
        }
        
        String wordsString = String.join(", ", words);
        return this.promptTemplate.replace("${data-vocabulary}", wordsString);
    }
    
    // Handle Gemini response
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

    private void SaveToDatabase() {
        dictionaryService.addWordsFromLookupToDictionary(data);
        vocabularyDetailsService.saveVocabularyDetails(data);
    }

    public void Reset() {
        isProcessing = false;
    }
}