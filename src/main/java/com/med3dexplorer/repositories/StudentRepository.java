package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Student;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StudentRepository extends JpaRepository<Student, Long> {}

