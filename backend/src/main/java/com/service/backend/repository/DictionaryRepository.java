package com.service.backend.repository;

import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.service.backend.models.Dictionary;

@Repository
public interface DictionaryRepository extends JpaRepository<Dictionary, Long> {
    public Dictionary findByVocabulary(String vocabulary);

    @Query("SELECT d FROM Dictionary d WHERE d.level = 'A1' AND d.id NOT IN " +
           "(SELECT dp.dictionary.id FROM dictionary_personal dp WHERE dp.user.ID = :userId)")
    List<Dictionary> findNewWordsForUser(String userId, Pageable pageable);
}
