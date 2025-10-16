package com.service.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.service.backend.models.VocabularyDetails;

@Repository
public interface VocabularyDetailsRepository extends JpaRepository<VocabularyDetails, Long> {
    // Truy vấn trực tiếp theo dictionary id để tránh load toàn bộ và filter thủ
    // công
    List<VocabularyDetails> findByDictionary_Id(Long dictionaryId);
}
