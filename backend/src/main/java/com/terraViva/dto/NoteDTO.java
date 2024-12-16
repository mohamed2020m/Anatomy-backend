package com.terraViva.dto;

import com.terraViva.models.Student;
import com.terraViva.models.ThreeDObject;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NoteDTO {
    private Long id;
    private String content;
    private Student student;
    private ThreeDObject threeDObject;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
