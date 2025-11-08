package com.service.backend.DTO.DataTransform.response.dictionary;
import java.time.LocalDate;
import java.util.List;

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
    private LocalDate lastReviewDate;
    private LocalDate nextReviewDate;

    public DictionaryPersonalDTO(DictionaryPersonal entity, List<VocabularyDetailDTO> details) {
        this.ID = entity.getID();
        this.dictionary = new DictionaryDTO(entity.getDictionary(), details);
        this.lookupCount = entity.getLookupCount();
        this.practiceCount = entity.getPracticeCount();
        this.correctAnswerCount = entity.getCorrectAnswerCount();
        this.incorrectAnswerCount = entity.getIncorrectAnswerCount();
        this.lastReviewDate = entity.getLastReviewDate().toLocalDate();
        this.nextReviewDate = entity.getNextReviewDate().toLocalDate();
    }
}
