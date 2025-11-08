package com.service.backend.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.service.backend.models.DictionaryPersonal;

@Repository
public interface DictionaryPersonalRepository extends JpaRepository<DictionaryPersonal, Long> {
    List<DictionaryPersonal> findByUserID(String userId);

    @Query("SELECT dp FROM dictionary_personal dp " +
           "JOIN FETCH dp.dictionary d " +
           "JOIN FETCH dp.user u " +       
           "WHERE dp.user.ID = :userId AND dp.nextReviewDate <= :now " +
           "ORDER BY dp.nextReviewDate ASC")
    List<DictionaryPersonal> findWordsForReview(String userId, LocalDateTime now, Pageable pageable);
}
