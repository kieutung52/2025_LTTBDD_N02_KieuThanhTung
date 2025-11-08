package com.service.backend.services;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.service.backend.DTO.structurejson.VocabularyData;
import com.service.backend.DTO.structurejson.VocabularyDetailData;
import com.service.backend.models.Dictionary;
import com.service.backend.models.VocabularyDetails;
import com.service.backend.repository.VocabularyDetailsRepository;

@Service
public class VocabularyDetailsService {
    private final VocabularyDetailsRepository vocabularyDetailsRepository;
    private final DictionaryService dictionaryService;

    public VocabularyDetailsService(VocabularyDetailsRepository vocabularyDetailsRepository,
            DictionaryService dictionaryService) {
        this.vocabularyDetailsRepository = vocabularyDetailsRepository;
        this.dictionaryService = dictionaryService;
    }

    @Transactional
    public boolean newVocabularyDetails(VocabularyDetails newDetails) {
        if (newDetails == null || newDetails.getDictionary() == null) {
            return false;
        }
        try {
            vocabularyDetailsRepository.save(newDetails);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional
    public boolean deleteById(Long id) {
        if (id == null) {
            return false;
        }
        try {
            if (!vocabularyDetailsRepository.existsById(id)) {
                return false;
            }
            vocabularyDetailsRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional
    public boolean updateVocabularyDetails(VocabularyDetails updatedDetails) {
        if (updatedDetails == null || updatedDetails.getId() == null) {
            return false;
        }
        try {
            if (vocabularyDetailsRepository.existsById(updatedDetails.getId())) {
                vocabularyDetailsRepository.save(updatedDetails);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Transactional(readOnly = true)
    public List<VocabularyDetails> findAllVocabularyDetails(Long dictionaryID) {
        if (dictionaryID == null) {
            return List.of();
        }
        return vocabularyDetailsRepository.findByDictionary_Id(dictionaryID);
    }

    @Transactional
    public void saveVocabularyDetails(List<VocabularyData> detailsList) {
        if (detailsList == null || detailsList.isEmpty()) {
            return;
        }
        List<VocabularyDetails> toSave = new ArrayList<>();
        for (VocabularyData voca : detailsList) {
            List<VocabularyDetailData> detailDatas = voca.getDetails();
            if (detailDatas == null || detailDatas.isEmpty()) {
                continue;
            }
            Dictionary dictionary = dictionaryService.findByWord(voca.getVocabulary());
            if (dictionary == null) {
                continue;
            }
            List<VocabularyDetails> saved = findAllVocabularyDetails(dictionary.getId());
            if (saved != null && !saved.isEmpty()) continue;
            for (VocabularyDetailData detail : detailDatas) {
                VocabularyDetails newEntity = new VocabularyDetails(dictionary, 
                                                                    detail.getType(), 
                                                                    detail.getMeaning(),
                                                                    detail.getExplanation(), 
                                                                    detail.getExample());
                toSave.add(newEntity);
            }
        }
        vocabularyDetailsRepository.saveAll(toSave);
    }
}
