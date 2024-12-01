package com.terraViva.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FavouriteDTO {

    private Long id;
    private Long studentId;
    private Long threeDObjectId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
