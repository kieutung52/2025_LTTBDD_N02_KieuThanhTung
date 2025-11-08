package com.service.backend.controllers;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.service.backend.DTO.DataTransform.ApiResponse;
import com.service.backend.DTO.DataTransform.response.user.UserResponse;
import com.service.backend.DTO._mapper.UserMapper;
import com.service.backend.models.User;
import com.service.backend.services.UserService;


@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private UserMapper userMapper;

    @GetMapping("/me")
    @PreAuthorize("hasRole('USER') or hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<UserResponse>> getMyProfile(@AuthenticationPrincipal Jwt jwt) {
        try {
            String userId = jwt.getSubject();
            User user = userService.getUserById(userId);
            if (user == null) {
                return ResponseEntity.status(404).body(ApiResponse.<UserResponse>builder()
                        .success(false).message("User not found.").build());
            }

            Date lastActiveDate = user.getLastStreakActiveDate();
            LocalDate today = LocalDate.now();
            boolean streakWasReset = false;

            if (lastActiveDate == null) {
                if (user.getStreak() != 0) {
                    user.setStreak(0);
                    streakWasReset = true;
                }
            } else {
                LocalDate lastActiveLocalDate = convertToLocalDate(lastActiveDate);
                LocalDate yesterday = today.minusDays(1);

                if (!lastActiveLocalDate.isEqual(today) && !lastActiveLocalDate.isEqual(yesterday)) {
                    user.setStreak(0);
                    streakWasReset = true;
                }
            }

            if (streakWasReset) {
                userService.saveUser(user);
            }

            UserResponse userResponse = userMapper.toUserResponse(user);
            userResponse.setCurrentDate(convertToDate(today));

            return ResponseEntity.ok(ApiResponse.<UserResponse>builder()
                    .success(true).data(userResponse).build());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<UserResponse>builder()
                    .success(false).message(e.getMessage()).build());
        }
    }

    private LocalDate convertToLocalDate(Date dateToConvert) {
        if (dateToConvert == null) {
            return null;
        }
        
        if (dateToConvert instanceof java.sql.Date) {
            return ((java.sql.Date) dateToConvert).toLocalDate();
        } else {
            return dateToConvert.toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
        }
    }

    private Date convertToDate(LocalDate dateToConvert) {
        if (dateToConvert == null) {
            return null;
        }
        return java.sql.Date.valueOf(dateToConvert);
    }

    @PutMapping("/profile")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<UserResponse>> updateProfile(@AuthenticationPrincipal Jwt jwt, @RequestBody Map<String, String> updateData) {
        try {
            String userId = jwt.getSubject();
            User user = userService.getUserById(userId);
            if (user == null) {
                return ResponseEntity.status(404).body(ApiResponse.<UserResponse>builder()
                        .success(false).message("User not found.").build());
            }
            
            if (updateData.containsKey("fullName")) {
                user.setFullName(updateData.get("fullName"));
                userService.saveUser(user);
            }
            
            UserResponse userResponse = userMapper.toUserResponse(user);
            return ResponseEntity.ok(ApiResponse.<UserResponse>builder()
                    .success(true).data(userResponse).build());
        } catch (Exception e) {
            return ResponseEntity.status(500).body(ApiResponse.<UserResponse>builder()
                    .success(false).message(e.getMessage()).build());
        }
    } 
    
    @PostMapping("/update-streak")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<ApiResponse<String>> updateStreakUser(@AuthenticationPrincipal Jwt jwt) {
        String userID = jwt.getSubject();

        return ResponseEntity.ok().body(ApiResponse.<String>builder()
            .data("Streak cua ban hien tai la " + userService.updateStreak(userID) + " .Hãy cố gắng giữ lửa vào ngày mai nhé")
            .build());
    }
}