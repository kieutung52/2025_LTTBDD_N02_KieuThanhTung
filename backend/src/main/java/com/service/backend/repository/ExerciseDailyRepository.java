package com.service.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.service.backend.models.ExerciseDaily;

@Repository
public interface ExerciseDailyRepository extends JpaRepository<ExerciseDaily, Integer> {
    
}
