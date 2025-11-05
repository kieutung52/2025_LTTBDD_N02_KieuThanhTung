package com.service.backend.cache;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Component;

import com.service.backend.models.Dictionary;
import com.service.backend.repository.DictionaryRepository;

import jakarta.annotation.PostConstruct;

@Component
public class DictionaryLoader {
    @Autowired
    private DictionaryRepository dictionaryRepository;

    @Autowired
    private RedisTemplate<String, Long> redisTemplate;

    @PostConstruct
    public void loadDictionary() {
        List<Dictionary> allVocabulary = dictionaryRepository.findAll();
        Map<String, Long> wordMap = allVocabulary.stream()
            .collect(Collectors.toMap(
                d -> d.getVocabulary().toLowerCase(), 
                Dictionary::getId
            ));

        redisTemplate.opsForValue().multiSet(wordMap);
    }

    public Long findWordId(String vocabulary) {
        return redisTemplate.opsForValue().get(vocabulary);
    }

    public void addWordToCache(String vocabulary, Long id) {
        redisTemplate.opsForValue().set(vocabulary, id);
    }
}
