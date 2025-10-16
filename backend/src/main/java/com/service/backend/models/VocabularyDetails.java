package com.service.backend.models;

import com.service.backend.DTO.enumdata.VocabularyType;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Entity
@AllArgsConstructor
@Builder
@Table(name = "vocabulary_details")
public class VocabularyDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @ManyToOne
    @JoinColumn(
        name = "vocabulary_id", 
        nullable = false, 
        foreignKey = @ForeignKey(
                        name = "fk_vocab_details_dictionary", 
                        foreignKeyDefinition = "FOREIGN KEY (vocabulary_id) REFERENCES dictionary(id) ON UPDATE CASCADE ON DELETE CASCADE"
                     )
    )
    private Dictionary dictionary;

    @Enumerated(EnumType.STRING)
    @Column(name = "vocab_type", nullable = false)
    private VocabularyType vocabType;

    @Lob
    @Column(name = "meaning", nullable = false)
    private String meaning;

    @Lob
    @Column(name = "explanation")
    private String explanation;

    @Lob
    @Column(name = "example_sentence")
    private String exampleSentence;

    public VocabularyDetails() {
        this.dictionary = null;
        this.vocabType = VocabularyType.NOUN;
        this.meaning = "";
        this.explanation = "";
        this.exampleSentence = "";
    }

    public VocabularyDetails(Dictionary dictionary, VocabularyType vocabType, String meaning, String explanation,
            String exampleSentence) {
        this.dictionary = dictionary;
        this.vocabType = vocabType;
        this.meaning = meaning;
        this.explanation = explanation;
        this.exampleSentence = exampleSentence;
    }
}