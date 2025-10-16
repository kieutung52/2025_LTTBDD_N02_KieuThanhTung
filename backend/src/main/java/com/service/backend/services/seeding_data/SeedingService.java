package com.service.backend.services.seeding_data;

import com.service.backend.DTO.datapattern.WordToLookUp;
import com.service.backend.DTO.structurejson.VocabularyData;
import com.service.backend.services.DictionaryService;
import com.service.backend.services.GeminiService;
import com.service.backend.services.VocabularyDetailsService;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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
    private final Path resultFilePath = Paths.get("src/main/resources/templates/data/json/jsonresult/json_result.json");

    public SeedingService(GeminiService geminiService,
                          ObjectMapper objectMapper,
                          DictionaryService dictionaryService,
                          @Value("classpath:templates/data/prompts/prompt_TraCuuTuVung.txt") Resource promptResource, VocabularyDetailsService vocabularyDetailsService) throws IOException {
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

        // Override the existing file with new content
        saveResponseToFile(cleanedJson);
        
        // Clear the words after processing
        // """" Need Editing logic """""
        WordToLookUp.clearWords();

        data = readDataFromResult();
        SaveToDatabase();
        data.clear();
        isProcessing = false;
    }

    private String buildCompletePrompt() {
        List<String> words = WordToLookUp.getWords();
        if (words == null || words.isEmpty()) {
            return null;
        }
        
        String wordsString = String.join(", ", words);
        // 
        return this.promptTemplate.replace("${data-vocabulary}", wordsString);
    }
    
    // Handel Gemini response
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

    // Save Gemini response to file
    private void saveResponseToFile(String jsonResponse) throws IOException {
        if (Files.notExists(resultFilePath.getParent())) {
            Files.createDirectories(resultFilePath.getParent());
        }

        Files.writeString(resultFilePath, jsonResponse, StandardCharsets.UTF_8);
        System.out.println("Successfully saved Gemini response to: " + resultFilePath.toAbsolutePath());
    }

    private List<VocabularyData> readDataFromResult() {
        try {
            // 1. Đọc nội dung file JSON thành chuỗi
            String jsonContent = Files.readString(resultFilePath, StandardCharsets.UTF_8);

            // 2. Parse chuỗi JSON thành một List<VocabularyData>
            List<VocabularyData> vocabularyDataList = objectMapper.readValue(jsonContent,
                    new TypeReference<List<VocabularyData>>() {
                    });

            // 3. Lọc bỏ mục không hợp lệ (null hoặc không có trường vocabulary)
            List<VocabularyData> cleaned = new ArrayList<>();
            for (VocabularyData v : vocabularyDataList) {
                if (v != null && v.getVocabulary() != null && !v.getVocabulary().isBlank()) {
                    cleaned.add(v);
                } else {
                    System.err.println("Warning: Skipping null or invalid vocabulary entry.");
                }
            }
            System.out.println("Successfully read and parsed " + cleaned.size() + " words from JSON result.");
            return cleaned;

        } catch (IOException e) {
            System.err.println("Error reading or parsing json_result.json file: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private void SaveToDatabase() {
        dictionaryService.addWordsFromLookupToDictionary(data);
        vocabularyDetailsService.saveVocabularyDetails(data);
    }

    public void Reset() {
        // data = readDataFromResult();
        // SaveToDatabase();
        // data.clear();
        isProcessing = false;
    }
}
