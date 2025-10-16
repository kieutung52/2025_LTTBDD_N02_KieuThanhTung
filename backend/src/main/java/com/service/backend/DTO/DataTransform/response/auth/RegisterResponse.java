package com.service.backend.DTO.DataTransform.response.auth;

import com.service.backend.DTO.enumdata.RoleAccount;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class RegisterResponse {
    private boolean registered;
    private String email;
    private String fullName;
    private RoleAccount role;
}
