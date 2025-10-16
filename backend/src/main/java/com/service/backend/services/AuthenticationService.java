package com.service.backend.services;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.JWSHeader;
import com.nimbusds.jose.JWSObject;
import com.nimbusds.jose.Payload;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jwt.JWTClaimsSet;
import com.service.backend.DTO.DataTransform.request.auth.AuthenticationRequest;
import com.service.backend.DTO.DataTransform.request.auth.RegisterRequest;
import com.service.backend.DTO.DataTransform.response.auth.AuthenticationResponse;
import com.service.backend.DTO.DataTransform.response.auth.RegisterResponse;
import com.service.backend.DTO.enumdata.RoleAccount;
import com.service.backend.models.User;
import com.service.backend.repository.UserRepository;

import org.springframework.transaction.annotation.Transactional;

@Service
public class AuthenticationService {
    @Autowired
    private UserRepository userRepository;

    @Value("${jwt.signer-key}")
    private String signerKey;

    @Transactional(readOnly = true)
    public AuthenticationResponse Authentication(AuthenticationRequest request) {
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        User u = userRepository.findUserByEmail(request.getEmail());
        if (u == null) {
            throw new RuntimeException("User not found");
        }
        if (!passwordEncoder.matches(request.getPassword(), u.getPassword())) {
            throw new RuntimeException("Password is incorrect");
        }

        String token = GenerateJwtToken(u);

        return AuthenticationResponse.builder()
                .token(token)
                .authenticated(true)
                .build();
    }

    @Transactional
    public RegisterResponse RegisterNewAccount(RegisterRequest request) {
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(10);
        User u = userRepository.findUserByEmail(request.getEmail());
        if (u != null) {
            throw new RuntimeException("Email already exists");
        }
        User newUser = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .role(RoleAccount.USER)
                .build();
        userRepository.save(newUser);

        return RegisterResponse.builder()
                .registered(true)
                .email(newUser.getEmail())
                .fullName(newUser.getFullName())
                .role(newUser.getRole())
                .build();
    }

    private String GenerateJwtToken(User user) {
        JWSHeader jwsHeader = new JWSHeader(JWSAlgorithm.HS256);

        JWTClaimsSet jwtClaimsSet = new JWTClaimsSet.Builder()
                .subject(user.getID())
                .issuer("http://kieutung-nos.com")
                .issueTime(new Date())
                .expirationTime(new Date (
                                            Instant.now()
                                                .plus(1, ChronoUnit.HOURS)
                                                .toEpochMilli()
                                        )
                                )
                .claim("role", user.getRole().name())
                .claim("email", user.getEmail())
                .build();
        Payload payload = new Payload(jwtClaimsSet.toJSONObject());

        JWSObject jwsObject = new JWSObject(jwsHeader, payload);

        try {
            jwsObject.sign(new MACSigner(signerKey.getBytes()));
            return jwsObject.serialize();
        } catch (Exception e) {
            throw new RuntimeException("Error while signing the token");
        }
    }
}
