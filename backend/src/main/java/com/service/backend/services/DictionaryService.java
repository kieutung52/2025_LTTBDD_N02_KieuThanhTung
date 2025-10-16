package com.service.backend.services;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.structurejson.VocabularyData;
import com.service.backend.cache.DictionaryLoader;
import com.service.backend.models.Dictionary;
import com.service.backend.repository.DictionaryRepository;

@Service
public class DictionaryService {
    private final DictionaryRepository dictionaryRepository;
    private final DictionaryLoader dictionaryLoader;

    public DictionaryService(DictionaryRepository dictionaryRepository, DictionaryLoader dictionaryLoader) {
        this.dictionaryRepository = dictionaryRepository;
        this.dictionaryLoader = dictionaryLoader;
    }

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
        return dictionaryRepository.findAll().stream()
                .filter(entry -> entry.getVocabulary().equalsIgnoreCase(word))
                .findFirst()
                .orElse(null);
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
                return false; // Word not found
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
                if (dictionaryLoader.findWordId(word.getVocabulary()) == null) {
                    Dictionary newEntry = new Dictionary(word.getVocabulary().toLowerCase(), word.getLevel(), 
                        word.getTranscriptionUk(), word.getTranscriptionUs(), 
                        word.getTranscriptionUk(), word.getTranscriptionUs());
                        // You may want to set properties for newEntry here
                    newEntry = dictionaryRepository.save(newEntry);
                    dictionaryLoader.addWordToCache(newEntry.getVocabulary(), newEntry.getId());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
