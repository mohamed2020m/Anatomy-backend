package com.terraViva.services.interfaces;

import com.terraViva.dto.LoginUserDTO;
import com.terraViva.dto.RegisterUserDTO;
import com.terraViva.models.User;

public interface AuthenticationService {
    User signup(RegisterUserDTO input);

    User authenticate(LoginUserDTO input);
}
