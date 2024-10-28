package com.med3dexplorer.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class FileResponse {
    private String message;
    private String path;
}
