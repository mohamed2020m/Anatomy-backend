package com.med3dexplorer.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
//import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfiguration {
    private final AuthenticationProvider authenticationProvider;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfiguration(
            JwtAuthenticationFilter jwtAuthenticationFilter,
            AuthenticationProvider authenticationProvider
    ) {
        this.authenticationProvider = authenticationProvider;
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> {
                CorsConfigurationSource source = request -> {
                    CorsConfiguration config = new CorsConfiguration();
                    config.setAllowedOrigins(Arrays.asList("*"));
                    config.setAllowedMethods(Arrays.asList("*"));
                    config.setAllowedHeaders(Arrays.asList("*"));

                    return config;
                };
                cors.configurationSource(source);
            })
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(auth -> auth
                    .requestMatchers(
                            "/api/v1/auth/**",
                            "/api/v1/files/download/**",
                            "/swagger-ui/**",
                            "/v3/api-docs/**"
//                            "/api/v1/administrators/**",
//                            "/api/v1/categories/**",
//                            "/api/v1/threeDObjects/**",
//                            "/api/v1/professors/**",
//                            "/api/v1/students/**",
//                            "/api/v1/notes/**",
//                            "/api/v1/me/**"
                    ).permitAll()
                    .requestMatchers("/api/v1/administrators/**").hasRole("ADMIN")
                    .requestMatchers("/api/v1/categories/**").hasAnyRole("ADMIN", "PROF")
                    .requestMatchers("/api/v1/threeDObjects/**").hasAnyRole("PROF")
                    .requestMatchers("/api/v1/professors/**").hasAnyRole("ADMIN", "PROF")
                    .requestMatchers("/api/v1/students/**").hasAnyRole("ADMIN", "PROF", "STUD")
                    .requestMatchers("/api/v1/notes/**", "/api/v1/favourites/**").hasAnyRole("ADMIN","STUD")
                    .requestMatchers("/api/v1/me").hasAnyRole("ADMIN", "PROF", "STUD")
                    .anyRequest()
                    .authenticated()
            )
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authenticationProvider(authenticationProvider)
            .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}