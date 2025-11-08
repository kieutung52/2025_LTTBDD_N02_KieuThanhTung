package com.service.backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.service.backend.models.User;

public interface UserRepository extends JpaRepository<User, String> {
    User findUserByEmail(String email);
}
