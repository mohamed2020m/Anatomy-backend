package com.med3dexplorer.controllers;

import com.med3dexplorer.dto.LoginResponse;
import com.med3dexplorer.dto.LoginUserDTO;
import com.med3dexplorer.dto.RegisterUserDTO;
import com.med3dexplorer.dto.TokenRefreshRequestDTO;
import com.med3dexplorer.models.User;
import com.med3dexplorer.services.implementations.JwtServiceImpl;
import com.med3dexplorer.services.implementations.AuthenticationServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api/v1/auth")
@RestController
public class AuthenticationController {
    private final JwtServiceImpl jwtService;
    private final AuthenticationServiceImpl authenticationService;
    private final UserDetailsService userDetailsService;


    public AuthenticationController(JwtServiceImpl jwtService, AuthenticationServiceImpl authenticationService, UserDetailsService userDetailsService) {
        this.jwtService = jwtService;
        this.authenticationService = authenticationService;
        this.userDetailsService = userDetailsService;
    }

    @PostMapping("/signup")
    public ResponseEntity<User> register(@RequestBody RegisterUserDTO registerUserDto) {
        User registeredUser = authenticationService.signup(registerUserDto);

        return ResponseEntity.ok(registeredUser);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> authenticate(@RequestBody LoginUserDTO loginUserDto) {
        User authenticatedUser = authenticationService.authenticate(loginUserDto);

        String accessToken = jwtService.generateToken(authenticatedUser);
        String refreshToken = jwtService.generateRefreshToken(authenticatedUser);

        LoginResponse loginResponse = new LoginResponse()
                .setAccessToken(accessToken)
                .setExpiresIn(jwtService.getExpirationTime())
                .setRefreshToken(refreshToken);

        return ResponseEntity.ok(loginResponse);
    }


//    @PostMapping("/login")
//    public ResponseEntity<LoginResponse> authenticate(@RequestBody LoginUserDto loginUserDto) {
//        User authenticatedUser = authenticationService.authenticate(loginUserDto);
//
//        String jwtToken = jwtService.generateToken(authenticatedUser);
//
//        LoginResponse loginResponse = new LoginResponse().setToken(jwtToken).setExpiresIn(jwtService.getExpirationTime());
//
//        return ResponseEntity.ok(loginResponse);
//    }


    @PostMapping("/refresh-token")
    public ResponseEntity<LoginResponse> refreshAccessToken(@RequestBody TokenRefreshRequestDTO request) {
        String refreshToken = request.getRefreshToken();
        String username = jwtService.extractUsername(refreshToken);

        // Load UserDetails using the userDetailsService
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);

        if (jwtService.isTokenValid(refreshToken, userDetails)) {
            String newAccessToken = jwtService.generateToken(userDetails);

            return ResponseEntity.ok(new LoginResponse()
                    .setAccessToken(newAccessToken)
                    .setExpiresIn(jwtService.getExpirationTime())
                    .setRefreshToken(refreshToken));
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
    }
}