package com.terraViva.dto;

import com.terraViva.models.Category;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class RegisterUserDTO {
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private String role;
    private Category category;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}