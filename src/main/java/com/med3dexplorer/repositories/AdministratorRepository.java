package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Administrator;
import com.med3dexplorer.models.Professor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdministratorRepository extends JpaRepository<Administrator,Long> {
    Optional<Administrator> findByEmail(String email);
}
