package com.service.backend.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.util.Set;

import com.service.backend.DTO.enumdata.VocabularyLevel;

@Data
@Entity
@AllArgsConstructor
@Builder
@Table(name = "dictionary")
public class Dictionary {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(unique = true, nullable = false, length = 100)
    private String vocabulary;

    @Enumerated(EnumType.STRING)
    @Column(name = "level", nullable = false)
    private VocabularyLevel level;

    @Column(name = "transcription_uk", length = 100)
    private String transcriptionUk;

    @Column(name = "transcription_us", length = 100)
    private String transcriptionUs;

    @Column(name = "audio_url_uk", length = 255)
    private String audioUrlUk;

    @Column(name = "audio_url_us", length = 255)
    private String audioUrlUs;

    @OneToMany(mappedBy = "dictionary", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<VocabularyDetails> details;

    @OneToMany(mappedBy = "dictionary", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<DictionaryPersonal> personalDictionaries;

    public Dictionary() {
        this.vocabulary = "";
        this.level = VocabularyLevel.A1;
        this.transcriptionUk = "";
        this.transcriptionUs = "";
        this.audioUrlUk = "";
        this.audioUrlUs = "";
    }

    public Dictionary(String vocabulary, VocabularyLevel level, String transcriptionUk, String transcriptionUs, String audioUrlUk, String audioUrlUs) {
        this.vocabulary = vocabulary;
        this.level = level;
        this.transcriptionUk = transcriptionUk;
        this.transcriptionUs = transcriptionUs;
        this.audioUrlUk = audioUrlUk;
        this.audioUrlUs = audioUrlUs;
    }
}