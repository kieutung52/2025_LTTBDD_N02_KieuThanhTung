package com.service.backend.DTO.datapattern;

import java.util.ArrayList;
import java.util.List;

public class WordToLookUp {
    private static List<String> words = new ArrayList<>();

    public static List<String> getWords() {
        return words;
    }

    public static boolean addWord(String newWord) {
        if (!words.contains(newWord)  && words.size() < 40) {
            words.add(newWord);
            return true;
        }
        return false;
    }

    public static void clearWords() {
        words.clear();
    }
}
