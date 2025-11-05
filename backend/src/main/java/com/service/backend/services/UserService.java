package com.service.backend.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.service.backend.DTO.DataTransform.response.BooleanResponse;
import com.service.backend.models.User;
import com.service.backend.repository.UserRepository;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Transactional(readOnly = true)
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    @Transactional(readOnly = true)
    public User getUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }

    @Transactional(readOnly = true)
    public User getUserById(String id) {
        return userRepository.findById(id).orElse(null);
    }

    @Transactional
    public User saveUser(User user) {
        return userRepository.save(user);
    }

    @Transactional
    public BooleanResponse deleteUser(String id) {
        userRepository.deleteById(id);

        return BooleanResponse.builder()
                .result(true)
                .message("User "+ id + " deleted successfully")
                .build();
    }

    @Transactional
    public void updateStreak(User user) {
        saveUser(user); 
    }
}