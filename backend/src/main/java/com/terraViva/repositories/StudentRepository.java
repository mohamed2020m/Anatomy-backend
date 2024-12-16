package com.terraViva.repositories;

import com.terraViva.models.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {
    Optional<Student> findByEmail(String email);

    @Query("SELECT s FROM Student s JOIN s.categories c WHERE c.id = :categoryId")
    List<Student> findByCategoryId(@Param("categoryId") Long categoryId);

}
