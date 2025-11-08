package com.service.backend.services;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.util.StopWatch;
import java.util.HashMap;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.DataTransform.request.dictionary.DictionaryPersonalRequest;
import com.service.backend.DTO.DataTransform.request.learning.UpdateProgressRequest;
import com.service.backend.DTO.DataTransform.request.learning.WordProgressDTO;
import com.service.backend.DTO.DataTransform.response.dictionary.DictionaryPersonalDTO;
import com.service.backend.DTO.DataTransform.response.dictionary.VocabularyDetailDTO;
import com.service.backend.DTO._mapper.VocabularyDetailsMapper;
import com.service.backend.models.Dictionary;
import com.service.backend.models.DictionaryPersonal;
import com.service.backend.models.User;
import com.service.backend.models.VocabularyDetails;
import com.service.backend.repository.DictionaryPersonalRepository;
import com.service.backend.repository.DictionaryRepository;
import com.service.backend.repository.VocabularyDetailsRepository;

import lombok.RequiredArgsConstructor;
import lombok.experimental.NonFinal;

@Service
@RequiredArgsConstructor
public class DictionaryPersonalService {
    private final DictionaryPersonalRepository dictionaryPersonalRepository;
    private final UserService userService;
    private final DictionaryService dictionaryService;
    private final DictionaryRepository dictionaryRepository;
    private final VocabularyDetailsRepository vocabularyDetailsRepository;
    private final VocabularyDetailsMapper vocabularyDetailsMapper;

    @NonFinal
    private static final int DAILY_LESSON_SIZE = 25;

    @Transactional(readOnly = true)
    public List<DictionaryPersonal> getAllDictionaryPersonals() {
        return dictionaryPersonalRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<DictionaryPersonal> getDictionaryPersonalsByUserId(String userId) {
        return dictionaryPersonalRepository.findByUserID(userId);
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
    public void deleteDictionaryPersonal(Long id) {
        dictionaryPersonalRepository.deleteById(id);
    }

    @Transactional(readOnly = true)
    public DictionaryPersonal getDictionaryPersonalById(Long id) {
        return dictionaryPersonalRepository.findById(id).orElse(null);
    }

    @Transactional(readOnly = true)
    public List<DictionaryPersonalDTO> getDailyLesson(String userId) {
        StopWatch watch = new StopWatch("getDailyLesson");
        LocalDateTime now = LocalDateTime.now();
        List<DictionaryPersonal> reviewWords = dictionaryPersonalRepository.findWordsForReview(
            userId,
            now,
            Pageable.unpaged()
        );
        int newWordsNeeded = DAILY_LESSON_SIZE - reviewWords.size();
        List<DictionaryPersonal> finalLessonList = new ArrayList<>(reviewWords);
        
        if (newWordsNeeded > 0) {
            Pageable limitNewWords = PageRequest.of(0, newWordsNeeded);
            List<Dictionary> newDictionaries = dictionaryRepository.findNewWordsForUser(userId, limitNewWords);
        
            User currentUser = userService.getUserById(userId);
            if (currentUser == null) {
                throw new RuntimeException("User not found: " + userId);
            }
            List<DictionaryPersonal> newPersonalWords = newDictionaries.stream().map(dict -> {
                return DictionaryPersonal.builder()
                        .user(currentUser)
                        .dictionary(dict)
                        .lookupCount(0)
                        .practiceCount(0)
                        .correctAnswerCount(0)
                        .incorrectAnswerCount(0)
                        .intervalInDays(1)
                        .lastReviewDate(now)
                        .nextReviewDate(now)
                        .build();
            }).collect(Collectors.toList());
        
            dictionaryPersonalRepository.saveAll(newPersonalWords);
            finalLessonList.addAll(newPersonalWords);
        }
        
        for (DictionaryPersonal dp : finalLessonList) {
            dp.setLookupCount(dp.getLookupCount() + 1);
        }
        dictionaryPersonalRepository.saveAll(finalLessonList);
        
        watch.start("extractIds");
        List<Long> dictionaryIds = new ArrayList<>();
        for (DictionaryPersonal dp : finalLessonList) {
            dictionaryIds.add(dp.getDictionary().getId());
        }
        watch.stop();
        System.out.println(dictionaryIds);

        watch.start("queryDetails");
        List<VocabularyDetails> allDetails = vocabularyDetailsRepository.findDetailsByVocabularyIdInNative(dictionaryIds);
        watch.stop();
        watch.start("grouping");
        Map<Long, List<VocabularyDetails>> detailsByDictId = new HashMap<>();
        for (VocabularyDetails vd : allDetails) {
            Long dictId = vd.getDictionary().getId();
            detailsByDictId.computeIfAbsent(dictId, k -> new ArrayList<>()).add(vd);
        }
        watch.stop();

        watch.start("mappingDTOs");
        List<DictionaryPersonalDTO> result = new ArrayList<>();
        int limit = Math.min(finalLessonList.size(), DAILY_LESSON_SIZE);
        for (int i = 0; i < limit; i++) {
            DictionaryPersonal data = finalLessonList.get(i);
            Long dictId = data.getDictionary().getId();
            List<VocabularyDetails> detailsForThis = detailsByDictId.getOrDefault(dictId, Collections.emptyList());
            
            List<VocabularyDetailDTO> detailsDTOs = new ArrayList<>();
            for (VocabularyDetails vd : detailsForThis) {
                detailsDTOs.add(vocabularyDetailsMapper.toVocabularyDetailDTO(vd));
            }
            
            result.add(new DictionaryPersonalDTO(data, detailsDTOs));
        }
        watch.stop();
        System.out.println("Performance: " + watch.prettyPrint());

        return result;
    }

    @Transactional
    public List<DictionaryPersonalDTO> getVocabularyToDay(String userId) {
        return getDailyLesson(userId);
    }

    @Transactional
    public void updateLearningProgress(String userId, UpdateProgressRequest request) {
        LocalDateTime now = LocalDateTime.now();
        List<DictionaryPersonal> wordsToUpdate = new ArrayList<>();

        for (WordProgressDTO progress : request.getProgressList()) {
            Optional<DictionaryPersonal> optWord = dictionaryPersonalRepository.findById((long) progress.getDictionaryPersonalId());
            
            if (optWord.isEmpty()) {
                System.err.println("Warning: DictionaryPersonal not found: " + progress.getDictionaryPersonalId());
                continue;
            }

            DictionaryPersonal word = optWord.get();

            if (!word.getUser().getID().equals(userId)) {
                System.err.println("Warning: User mismatch for progress update.");
                continue;
            }

            word.setPracticeCount(word.getPracticeCount() + 1);
            word.setLastReviewDate(now);

            int currentInterval = word.getIntervalInDays();
            if (currentInterval <= 0) currentInterval = 1;

            if (progress.isWasCorrect()) {
                word.setCorrectAnswerCount(word.getCorrectAnswerCount() + 1);
                int newInterval = (int) Math.round(currentInterval * 2); 
                word.setIntervalInDays(newInterval);
                word.setNextReviewDate(now.plusDays(newInterval));
            } else {
                word.setIncorrectAnswerCount(word.getIncorrectAnswerCount() + 1);
                word.setIntervalInDays(1);
                word.setNextReviewDate(now.plusDays(1));
            }
            
            wordsToUpdate.add(word);
        }
        dictionaryPersonalRepository.saveAll(wordsToUpdate);
    }
}