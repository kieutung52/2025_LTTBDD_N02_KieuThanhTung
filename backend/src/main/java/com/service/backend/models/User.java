package com.service.backend.models;

import java.util.Date;
import java.util.Set;

import com.service.backend.DTO.enumdata.RoleAccount;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity(name = "users")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(name = "id", updatable = false, nullable = false, unique = true)
    private String ID;
    
    @Column(name = "fullname", unique = false, nullable = false, length = 50)
    private String fullName;

    @Column(name = "email", unique = true, nullable = false, length = 100)
    private String email;
    
    @Column(name = "password", nullable = false, length = 255)
    private String password;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false, length = 20)
    private RoleAccount role;

    @Builder.Default
    @Column(name = "streak", nullable = false)
    private int streak = 0;

    @Column(name = "last_streak_active_date")
    @Temporal(TemporalType.DATE)
    private Date lastStreakActiveDate;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<DictionaryPersonal> personalDictionaries;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<ExerciseDaily> exerciseDailies;
}
