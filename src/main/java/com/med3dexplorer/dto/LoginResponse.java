package com.med3dexplorer.dto;

import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class LoginResponse {
    private String accessToken;
    private long expiresIn;
    private String refreshToken;
}