package com.terraViva.repositories;

import com.terraViva.models.Favourite;
import com.terraViva.models.Student;
import com.terraViva.models.ThreeDObject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavouriteRepository extends JpaRepository<Favourite, Long> {

    boolean existsByThreeDObjectAndStudent(ThreeDObject threeDObject, Student student);

    @Query("SELECT o FROM ThreeDObject o " +
            "WHERE o.id IN (SELECT f.threeDObject.id FROM Favourite f WHERE f.student.id = :studentId)")
    List<ThreeDObject> findThreeDObjectsMarkedAsFavoriteByStudent(Long studentId);

    List<Favourite> findByStudentId(Long studentId);

    Optional<Favourite> findByThreeDObjectAndStudent(ThreeDObject threeDObject, Student student);
}
