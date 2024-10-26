package com.med3dexplorer.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RegisterUserDTO {
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private String role;
    private LocalDateTime createdAt;
}