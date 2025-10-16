package com.service.backend.models;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity(name = "dictionary_personal")
public class DictionaryPersonal {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false)
    private int ID;
    
    @ManyToOne
    @JoinColumn(
        name = "user_id", 
        nullable = false, 
        foreignKey = @jakarta.persistence.ForeignKey(
                        name = "fk_dict_personal_user", 
                        foreignKeyDefinition = "FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE"
                     )
    )
    private User user;

    @ManyToOne
    @JoinColumn(
        name = "dictionary_id", 
        nullable = false, 
        foreignKey = @jakarta.persistence.ForeignKey(
                        name = "fk_dict_personal_dictionary", 
                        foreignKeyDefinition = "FOREIGN KEY (dictionary_id) REFERENCES dictionary(id) ON UPDATE CASCADE ON DELETE CASCADE"
                     )
    )
    private Dictionary dictionary;

    @Column(name = "lookup_count", nullable = false)
    private int lookupCount;

    @Column(name = "practice_count", nullable = false)
    private int practiceCount;

    @Column(name = "correct_answer_count", nullable = false)
    private int correctAnswerCount;

    @Column(name = "incorrect_answer_count", nullable = false)
    private int incorrectAnswerCount;

    @Column(name = "last_review_date")
    private LocalDateTime lastReviewDate;

    @Column(name = "next_review_date")
    private LocalDateTime nextReviewDate;

    @Column(name = "interval_in_days", nullable = false)
    private int intervalInDays;
}
