package com.service.backend.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.service.backend.DTO.enumdata.VocabularyType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.ForeignKey;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Index;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.Lob;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@Entity
@AllArgsConstructor
@Builder
@Table(name = "vocabulary_details", indexes = {@Index(name = "idx_dict_id", columnList = "vocabulary_id")})
public class VocabularyDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @JsonIgnore
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