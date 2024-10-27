package com.med3dexplorer.dto;

import com.med3dexplorer.models.Category;
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
    private Category category;
    private String role;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

