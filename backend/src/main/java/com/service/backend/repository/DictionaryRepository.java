package com.service.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.service.backend.models.Dictionary;

@Repository
public interface DictionaryRepository extends JpaRepository<Dictionary, Long> {
    public Dictionary findByVocabulary(String vocabulary);
}
