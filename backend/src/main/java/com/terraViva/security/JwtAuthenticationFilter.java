package com.terraViva.security;

import com.terraViva.services.implementations.JwtServiceImpl;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.HandlerExceptionResolver;

import java.io.IOException;
import java.util.logging.Logger;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private static final Logger logger = Logger.getLogger(JwtAuthenticationFilter.class.getName());

    private final HandlerExceptionResolver handlerExceptionResolver;

    private final JwtServiceImpl jwtService;
    private final UserDetailsService userDetailsService;


    public JwtAuthenticationFilter(
            JwtServiceImpl jwtService,
            UserDetailsService userDetailsService,
            HandlerExceptionResolver handlerExceptionResolver
    ) {
        this.jwtService = jwtService;
        this.userDetailsService = userDetailsService;
        this.handlerExceptionResolver = handlerExceptionResolver;
    }

    @Override
    protected void doFilterInternal(
            @NonNull HttpServletRequest request,
            @NonNull HttpServletResponse response,
            @NonNull FilterChain filterChain
    ) throws ServletException, IOException {
        final String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        try {
            final String jwt = authHeader.substring(7);
            final String userEmail = jwtService.extractUsername(jwt);

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

            if (userEmail != null && authentication == null) {
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
                logger.info("User details: " + userDetails);

                // Validate the token here
                if (!jwtService.isTokenValid(jwt, userDetails)) {
                    logger.warning("Token is invalid or expired");
                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid or expired token");
                    return;
                }

                logger.info("Token is valid");
                logger.info("User authorities: " + userDetails.getAuthorities());
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails,
                        null,
                        userDetails.getAuthorities()
                );

                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }

            filterChain.doFilter(request, response);
        } catch (Exception exception) {
            logger.severe("Authentication error: " + exception.getMessage());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED,  exception.getMessage());
        }
    }


//    @Override
//    protected void doFilterInternal(
//            @NonNull HttpServletRequest request,
//            @NonNull HttpServletResponse response,
//            @NonNull FilterChain filterChain
//    ) throws ServletException, IOException {
//        final String authHeader = request.getHeader("Authorization");
//
//        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
//            filterChain.doFilter(request, response);
//            return;
//        }
//
//        try {
//            final String jwt = authHeader.substring(7);
//            final String userEmail = jwtService.extractUsername(jwt);
//
//            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//
//            if (userEmail != null && authentication == null) {
//                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
//                logger.info("User details: " + userDetails);
//
//                if (jwtService.isTokenValid(jwt, userDetails)) {
//                    logger.info("Token is valid");
//                    logger.info("User authorities: " + userDetails.getAuthorities());
//                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
//                            userDetails,
//                            null,
//                            userDetails.getAuthorities()
//                    );
//
//                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
//                    SecurityContextHolder.getContext().setAuthentication(authToken);
//                }else{
//                    logger.warning("Token is invalid or expired");
//                    response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Invalid or expired token");
//                    return;
//                }
//            }
//
//            filterChain.doFilter(request, response);
//        } catch (Exception exception) {
//            logger.severe("Authentication error: " + exception.getMessage());
//            handlerExceptionResolver.resolveException(request, response, null, exception);
//        }
//    }
}