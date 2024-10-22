package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Professor;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProfessorRepository extends JpaRepository<Professor, Long> {
}
