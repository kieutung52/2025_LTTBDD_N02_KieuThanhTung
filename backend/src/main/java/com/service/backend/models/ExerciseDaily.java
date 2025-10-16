package com.service.backend.models;

import java.time.LocalDateTime;

import com.service.backend.DTO.enumdata.ExerciseType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity(name = "exercise_daily")
public class ExerciseDaily {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false)
    private int ID;

    @ManyToOne
    @JoinColumn(
        name = "user_id", 
        nullable = false, 
        foreignKey = @jakarta.persistence.ForeignKey(
                        name = "fk_exercise_daily_user", 
                        foreignKeyDefinition = "FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE"
                     )
    )
    private User user;

    @Column(name = "total_questions", nullable = false)
    private int totalQuestions;

    @Column(name = "correct_answers", nullable = false)
    private int correctAnswers;

    @Enumerated(EnumType.STRING)
    @Column(name = "exercise_type", nullable = false)
    private ExerciseType exerciseType;

    @Column(name = "date", nullable = false)
    private LocalDateTime date;    

    @Column(name = "analytics", columnDefinition = "TEXT")
    private String analytics;
}
