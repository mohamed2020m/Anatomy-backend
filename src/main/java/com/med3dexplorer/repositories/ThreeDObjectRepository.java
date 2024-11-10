package com.med3dexplorer.repositories;

import com.med3dexplorer.dto.ThreeDObjectDTO;
import com.med3dexplorer.models.Professor;
import com.med3dexplorer.models.ThreeDObject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ThreeDObjectRepository extends JpaRepository<ThreeDObject, Long> {
    Optional<ThreeDObject> findByName(String name);
    List<ThreeDObject> findByProfessor(Professor professor);

    @Query("SELECT COUNT(o.name) " +
            "FROM ThreeDObject o " +
            "WHERE o.professor.id = :professorId")
    Long threeDObjectCountByProfessorId (Long professorId);

    @Query("SELECT c.name, COUNT(obj) " +
            "FROM ThreeDObject obj JOIN obj.category c " +
            "WHERE c.parentCategory IS NOT NULL " +
            "AND obj.professor.id = :professorId " +
            "GROUP BY c.name " +
            "ORDER BY COUNT(obj) DESC")
    List<Object[]> findThreeDObjectCountsByProfessorSubCategories(@Param("professorId") Long professorId);

}
