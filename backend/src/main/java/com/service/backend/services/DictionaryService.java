package com.service.backend.services;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.DataTransform.response.dictionary.VocabularyForGenerateExercise;
import com.service.backend.DTO.structurejson.VocabularyData;
import com.service.backend.cache.DictionaryLoader;
import com.service.backend.models.Dictionary;
import com.service.backend.models.VocabularyDetails;
import com.service.backend.repository.DictionaryRepository;
import com.service.backend.repository.VocabularyDetailsRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DictionaryService {
    private final DictionaryRepository dictionaryRepository;
    private final VocabularyDetailsRepository vocabularyDetailsRepository;
    private final DictionaryLoader dictionaryLoader;

    @Transactional
    public boolean newVocabulary(Dictionary newWord) {
        try {
            newWord.setVocabulary(newWord.getVocabulary().toLowerCase());
            dictionaryRepository.save(newWord);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public Dictionary findByWord(String word) {
        return dictionaryRepository.findByVocabulary(word.toLowerCase());
    }

    public Dictionary findByWordOptimized(String word) {
        Long wordId = dictionaryLoader.findWordId(word.toLowerCase());
        if (wordId == null) {
            return null; 
        }
        return dictionaryRepository.findById(wordId).orElse(null);
    }

    public Dictionary findById(Long id) {
        return dictionaryRepository.findById(id).orElse(null);
    }

    @Transactional
    public boolean deleteById(Long id) {
        try {
            dictionaryRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional
    public boolean updateVocabulary(Dictionary updatedWord) {
        try {
            if (dictionaryRepository.existsById(updatedWord.getId())) {
                dictionaryRepository.save(updatedWord);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Dictionary> getAllVocabularies() {
        return dictionaryRepository.findAll();
    }

    @Transactional
    public void addWordsFromLookupToDictionary(List<VocabularyData> wordsToAdd) {
        try {
            for (VocabularyData word : wordsToAdd) {
                if (dictionaryLoader.findWordId(word.getVocabulary().toLowerCase()) == null) {
                    Dictionary newEntry = new Dictionary(word.getVocabulary().toLowerCase(), word.getLevel(), 
                        word.getTranscriptionUk(), word.getTranscriptionUs(), 
                        null, null);
                    
                    newEntry = dictionaryRepository.save(newEntry);
                    dictionaryLoader.addWordToCache(newEntry.getVocabulary(), newEntry.getId());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Transactional(readOnly = true)
    public List<VocabularyDetails> findAllVocabularyDetails(Long dictionaryID) {
        return vocabularyDetailsRepository.findByDictionary_Id(dictionaryID);
    }

    @Transactional(readOnly = true)
    public List<VocabularyForGenerateExercise> findAllVocabularyWithDetails(List<Long> dictionaryIds) {
        if (dictionaryIds == null || dictionaryIds.isEmpty()) {
            return new ArrayList<>();
        }
        
        List<Dictionary> dictionaries = dictionaryRepository.findByIdIn(dictionaryIds);
        
        List<VocabularyDetails> allDetails = vocabularyDetailsRepository.findByDictionary_IdIn(dictionaryIds);
        
        Map<Long, List<VocabularyDetails>> detailsByDictionaryId = allDetails.stream()
                .collect(Collectors.groupingBy(vd -> vd.getDictionary().getId()));
        
        return dictionaries.stream()
                .map(dict -> {
                    String voca = dict.getVocabulary();
                    List<VocabularyDetails> details = detailsByDictionaryId.getOrDefault(dict.getId(), new ArrayList<>());
                    
                    // Lấy tất cả meanings
                    List<String> meanings = details.stream()
                            .map(VocabularyDetails::getMeaning)
                            .collect(Collectors.toList());
                    
                    String mean = String.join(", ", meanings);
                    
                    return VocabularyForGenerateExercise.builder()
                            .vocabulary(voca)
                            .meaning(mean)
                            .build();
                }).collect(Collectors.toList());
    }
}
