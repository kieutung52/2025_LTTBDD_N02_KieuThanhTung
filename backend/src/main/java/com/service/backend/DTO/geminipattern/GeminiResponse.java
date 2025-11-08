package com.service.backend.DTO.geminipattern;

import java.util.List;


public class GeminiResponse {
    private List<Candidate> candidates;

    // Constructors, Getters, Setters
    public static class Candidate {
        private Content content;

        public Content getContent() {
            return content;
        }

        // Constructors, Getters, Setters
    }

    public static class Content {
        private List<Part> parts;

        public List<Part> getParts() {
            return parts;
        }

        // Constructors, Getters, Setters
    }

    public static class Part {
        private String text;

        public String getText() {
            return text;
        }

        // Constructors, Getters, Setters
    }

    public List<Candidate> getCandidates() {
        return candidates;
    }
}