package com.terraViva.dto;
import com.terraViva.models.Note;
import com.terraViva.models.Professor;
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
public class ThreeDObjectDTO {

    private Long id;
    private String name;
    private String description;
    private String descriptionAudio;
    private String image;
    private String object;
    private List<Note> notes;
    private Professor professor;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
