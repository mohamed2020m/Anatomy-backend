package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.LoginUserDTO;
import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.models.User;

public interface AuthenticationService {
    User signup(RegisterUserDTO input);

    User authenticate(LoginUserDTO input);
}
