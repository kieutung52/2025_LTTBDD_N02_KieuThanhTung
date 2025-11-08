package com.service.backend.models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ForeignKey;
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
@Entity(name = "exercise_details")
public class ExerciseDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ex_detail_id", updatable = false, nullable = false)
    private Long ID;

    @ManyToOne
    @JoinColumn(name = "ex_daily_id", 
                nullable = false,
                foreignKey = @ForeignKey(
                    name = "fk_exercise_details_ex_daily",
                    foreignKeyDefinition = "FOREIGN KEY (ex_daily_id) REFERENCES exercise_daily(id) ON UPDATE CASCADE ON DELETE CASCADE"
                )
    )
    private ExerciseDaily exDaily;

    @Column(name = "question", nullable = false, columnDefinition = "TEXT")
    private String question;

    @Column(name = "question_type", nullable = false)
    private String questionType;
    
    @Builder.Default
    @Column(name = "options", columnDefinition = "TEXT")
    private String options = "[]";

    @Column(name = "true_answer", nullable = true, columnDefinition = "TEXT")
    private String trueAnswer;

    @Column(name = "user_answer", nullable = true, columnDefinition = "TEXT")
    private String userAnswer;

    @Column(name = "is_correct", nullable = true)
    private boolean isCorrect;

    @Column(name = "ai_explain", columnDefinition = "TEXT")
    private String aiExplain;
}