package com.terraViva.repositories;

import com.terraViva.models.Administrator;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdministratorRepository extends JpaRepository<Administrator,Long> {
    Optional<Administrator> findByEmail(String email);
}
