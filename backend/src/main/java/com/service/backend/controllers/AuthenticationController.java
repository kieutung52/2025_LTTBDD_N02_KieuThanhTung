package com.service.backend.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.DataTransform.request.auth.AuthenticationRequest;
import com.service.backend.DTO.DataTransform.request.auth.RegisterRequest;
import com.service.backend.DTO.DataTransform.response.auth.AuthenticationResponse;
import com.service.backend.DTO.DataTransform.response.auth.RegisterResponse;
import com.service.backend.services.AuthenticationService;

@RestController
public class AuthenticationController {

    @Autowired
    private AuthenticationService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<RegisterResponse>> register(@RequestBody RegisterRequest request) {
        try {
            System.out.println(request.getPassword());
            RegisterResponse response = authService.RegisterNewAccount(request);
            return ResponseEntity.ok(ApiResponse.<RegisterResponse>builder()
                    .success(true).message("Registration successful.").data(response).build());
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.<RegisterResponse>builder()
                    .success(false).message(e.getMessage()).build());
        }
    }

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<AuthenticationResponse>> login(@RequestBody AuthenticationRequest request) {
        try {
            AuthenticationResponse response = authService.Authentication(request);
            return ResponseEntity.ok(ApiResponse.<AuthenticationResponse>builder()
                    .success(true).message("Login successful.").data(response).build());
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(ApiResponse.<AuthenticationResponse>builder()
                    .success(false).message(e.getMessage()).build());
        }
    }
}
