package com.terraViva.dto;

import com.terraViva.models.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProfessorDTO {
    private Long id;
    private String email;
    private String firstName;
    private String lastName;
    private String password;
    private String role;
    private Category category;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

