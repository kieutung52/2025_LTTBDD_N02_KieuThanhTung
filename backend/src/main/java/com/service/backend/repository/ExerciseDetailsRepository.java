package com.service.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.service.backend.models.ExerciseDetails;

@Repository
public interface ExerciseDetailsRepository extends JpaRepository<ExerciseDetails, Long> {
    public List<ExerciseDetails> findByExDailyID(Long id);
}