package com.service.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.service.backend.models.VocabularyDetails;

@Repository
public interface VocabularyDetailsRepository extends JpaRepository<VocabularyDetails, Long> {
    List<VocabularyDetails> findByDictionary_Id(Long dictionaryId);

    List<VocabularyDetails> findByDictionary_IdIn(List<Long> dictionaryIds);
}
