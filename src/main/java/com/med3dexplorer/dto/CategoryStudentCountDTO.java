package com.med3dexplorer.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
// This used for Bar Chart
public class CategoryStudentCountDTO {
    private String category;
    private Long students;
}
