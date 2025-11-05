package com.service.backend.DTO.DataTransform.response.dictionary;

import java.time.LocalDateTime;

import com.service.backend.models.DictionaryPersonal;

import lombok.Data;

@Data
public class DictionaryPersonalDTO {
    private Long ID;
    private DictionaryDTO dictionary;
    private int lookupCount;
    private int practiceCount;
    private int correctAnswerCount;
    private int incorrectAnswerCount;
    private LocalDateTime lastReviewDate;
    private LocalDateTime nextReviewDate;

    public DictionaryPersonalDTO(DictionaryPersonal entity) {
        this.ID = entity.getID();
        this.dictionary = new DictionaryDTO(entity.getDictionary());
        this.lookupCount = entity.getLookupCount();
        this.practiceCount = entity.getPracticeCount();
        this.correctAnswerCount = entity.getCorrectAnswerCount();
        this.incorrectAnswerCount = entity.getIncorrectAnswerCount();
        this.lastReviewDate = entity.getLastReviewDate();
        this.nextReviewDate = entity.getNextReviewDate();
    }
}
