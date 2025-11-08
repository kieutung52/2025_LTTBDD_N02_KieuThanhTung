package com.service.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.service.backend.models.VocabularyDetails;

@Repository
public interface VocabularyDetailsRepository extends JpaRepository<VocabularyDetails, Long> {
    List<VocabularyDetails> findByDictionary_Id(Long dictionaryId);

    List<VocabularyDetails> findByDictionary_IdIn(List<Long> dictionaryIds);

    @Query("SELECT vd FROM VocabularyDetails vd JOIN FETCH vd.dictionary d WHERE d.id IN :dictionaryIds")
    List<VocabularyDetails> findByDictionaryIdIn(@Param("dictionaryIds") List<Long> dictionaryIds);

    @Query(value = "SELECT * FROM vocabulary_details WHERE vocabulary_id IN :vocabularyIds", nativeQuery = true)
    List<VocabularyDetails> findDetailsByVocabularyIdInNative(@Param("vocabularyIds") List<Long> vocabularyIds);
}
