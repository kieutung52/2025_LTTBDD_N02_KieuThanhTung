package com.service.backend.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.DataTransform.request.dictionary.DictionaryPersonalRequest;
import com.service.backend.models.DictionaryPersonal;
import com.service.backend.repository.DictionaryPersonalRepository;

@Service
public class DictionaryPersonalService {
    @Autowired
    private DictionaryPersonalRepository dictionaryPersonalRepository;

    @Autowired
    private UserService userService;
    @Autowired
    private DictionaryService dictionaryService;

    @Transactional(readOnly = true)
    public List<DictionaryPersonal> getAllDictionaryPersonals() {
        return dictionaryPersonalRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<DictionaryPersonal> getDictionaryPersonalsByUserId(int userId) {
        return dictionaryPersonalRepository.findByUserId(userId);
    }

    // Create or Update
    @Transactional
    public DictionaryPersonal saveDictionaryPersonal(DictionaryPersonalRequest dictionaryPersonal) {
        return dictionaryPersonalRepository.save(DictionaryPersonal.builder()
            .user(userService.getUserById(dictionaryPersonal.getUserId()))
            .dictionary(dictionaryService.findById(dictionaryPersonal.getDictionaryId()))
            .lookupCount(0)
            .practiceCount(0)
            .correctAnswerCount(0)
            .incorrectAnswerCount(0)
            .intervalInDays(0)
            .lastReviewDate(LocalDateTime.now())
            .nextReviewDate(LocalDateTime.now().plusDays(1))
            .build());
    }

    @Transactional
    public void deleteDictionaryPersonal(int id) {
        dictionaryPersonalRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public DictionaryPersonal getDictionaryPersonalById(int id) {
        return dictionaryPersonalRepository.findById(id).orElse(null);
    }

    @Transactional
    public List<DictionaryPersonal> getVocabularyToDay(String userId) {
        LocalDateTime now = LocalDateTime.now();
        return dictionaryPersonalRepository.findAll().stream()
                .filter(entry -> entry.getUser().getID().equals(userId))
                .filter(entry -> !entry.getNextReviewDate().isAfter(now))
                .limit(25)
                .toList();
    }
}
