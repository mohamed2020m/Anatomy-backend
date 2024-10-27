package com.med3dexplorer.dto;

import com.med3dexplorer.models.Role;
import lombok.Data;
import lombok.experimental.Accessors;

@Data
@Accessors(chain = true)
public class LoginResponseDTO {
    private String accessToken;
    private long expiresIn;
    private String refreshToken;
    private Role role;
}


