package com.service.backend.DTO._mapper;

import org.mapstruct.Mapper;

import com.service.backend.DTO.DataTransform.response.auth.RegisterResponse;
import com.service.backend.DTO.DataTransform.response.user.UserResponse;
import com.service.backend.models.User;

import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface UserMapper {
    @Mapping(target = "currentDate", ignore = true)
    UserResponse toUserResponse(User user);

    @Mapping(target = "registered", ignore = true)
    RegisterResponse toRegisterResponse(User user);
}
