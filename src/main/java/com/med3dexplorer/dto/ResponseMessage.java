package com.med3dexplorer.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@AllArgsConstructor
@Data
public class ResponseMessage {
    private String status;
    private String message;
}
