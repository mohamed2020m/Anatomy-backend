package com.med3dexplorer.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class StudentDTO {
    private Long id;
    private String email;
    private String firstName;
    private String lastName;
    private String password;
    private String role;
    private List<CategoryDTO> categories;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}

