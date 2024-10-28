package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Professor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProfessorRepository extends JpaRepository<Professor,Long> {
    Optional<Professor> findByEmail(String email);

    @Query("SELECT c.name, COUNT(p) " +
            "FROM Professor p JOIN p.category c " +
            "GROUP BY c.name " +
            "ORDER BY COUNT(p) DESC")
    List<Object[]> countProfessorsByCategory();

}
