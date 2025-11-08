package com.service.backend.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.service.backend.models.ExerciseDaily;

@Repository
public interface ExerciseDailyRepository extends JpaRepository<ExerciseDaily, Long> {
    @Query("SELECT ed FROM exercise_daily ed WHERE ed.user.ID = :userId AND FUNCTION('DATE', ed.date) = :date")
    List<ExerciseDaily> findByUserIdAndDate(String userId, LocalDate date);
}
