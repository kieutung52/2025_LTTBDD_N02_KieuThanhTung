package com.service.backend.DTO.DataTransform.response.user;

import com.service.backend.DTO.enumdata.RoleAccount;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserResponse {
    private String ID;
    private String email;
    private String fullName;
    private RoleAccount role;
}
