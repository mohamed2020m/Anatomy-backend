package com.terraViva.controllers;

import com.terraViva.dto.*;
import com.terraViva.models.Role;
import com.terraViva.models.User;
import com.terraViva.services.implementations.JwtServiceImpl;
import com.terraViva.services.implementations.AuthenticationServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.logging.Logger;

@RequestMapping("/api/v1/auth")
@RestController
public class AuthenticationController {
    private static final Logger logger = Logger.getLogger(AuthenticationController.class.getName());

    private final JwtServiceImpl jwtService;
    private final AuthenticationServiceImpl authenticationService;
    private final UserDetailsService userDetailsService;


    public AuthenticationController(JwtServiceImpl jwtService, AuthenticationServiceImpl authenticationService, UserDetailsService userDetailsService) {
        this.jwtService = jwtService;
        this.authenticationService = authenticationService;
        this.userDetailsService = userDetailsService;
    }

    @PostMapping("/signup")
    public ResponseEntity<?> register(@RequestBody RegisterUserDTO registerUserDto) {
        try {
            User registeredUser = authenticationService.signup(registerUserDto);
            return ResponseEntity.ok(registeredUser);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("error", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> authenticate(@RequestBody LoginUserDTO loginUserDto) {
        try {
            User authenticatedUser = authenticationService.authenticate(loginUserDto);

            String accessToken = jwtService.generateToken(authenticatedUser);
            String refreshToken = jwtService.generateRefreshToken(authenticatedUser);

            List<String> roles = jwtService.extractRoles(accessToken);
            String role = roles.isEmpty() ? null : roles.get(0);

            LoginResponseDTO loginResponseDTO = new LoginResponseDTO()
                    .setUser_id(authenticatedUser.getId())
                    .setAccessToken(accessToken)
                    .setExpiresIn(jwtService.getExpirationTime())
                    .setRole(Role.valueOf(role))
                    .setRefreshToken(refreshToken);

            return ResponseEntity.ok(loginResponseDTO);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("error", e.getMessage()));
        }
    }

//    @PostMapping("/login")
//    public ResponseEntity<LoginResponseDTO> authenticate(@RequestBody LoginUserDTO loginUserDto) {
//        User authenticatedUser = authenticationService.authenticate(loginUserDto);
//
//        String accessToken = jwtService.generateToken(authenticatedUser);
//        String refreshToken = jwtService.generateRefreshToken(authenticatedUser);
//
//        List<String> roles = jwtService.extractRoles(accessToken);
//        String role = roles.isEmpty() ? null : roles.get(0);
//
//        LoginResponseDTO loginResponseDTO = new LoginResponseDTO()
//                .setAccessToken(accessToken)
//                .setExpiresIn(jwtService.getExpirationTime())
//                .setRole(Role.valueOf(role))
//                .setRefreshToken(refreshToken);
//
//        return ResponseEntity.ok(loginResponseDTO);
//    }


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
    public ResponseEntity<?> refreshAccessToken(@RequestBody TokenRefreshRequestDTO request) {
        logger.info("Called refresh token endpoint");
        String refreshToken = request.getRefreshToken();
        try{
            String username = jwtService.extractUsername(refreshToken);

            // Load UserDetails using the userDetailsService
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            if (jwtService.isTokenValid(refreshToken, userDetails)) {
                String newAccessToken = jwtService.generateToken(userDetails);

                List<String> roles = jwtService.extractRoles(newAccessToken);
                String role = roles.isEmpty() ? null : roles.get(0);

                return ResponseEntity.ok(new LoginResponseDTO()
                        .setAccessToken(newAccessToken)
                        .setExpiresIn(jwtService.getExpirationTime())
                        .setRole(Role.valueOf(role))
                        .setRefreshToken(refreshToken));
            } else {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ResponseMessage("Error", "Invalid refresh token"));
            }
        }catch (Exception error){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(new ResponseMessage("Error", error.getMessage()));
        }

    }
}