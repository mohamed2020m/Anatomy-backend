package com.med3dexplorer.dto;
import com.med3dexplorer.models.Note;
import com.med3dexplorer.models.Professor;
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
    private List<Note> notes;
    private Professor professor;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

}
