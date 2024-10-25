package com.med3dexplorer.repositories;

import com.med3dexplorer.models.ThreeDObject;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ThreeDObjectRepository extends JpaRepository<ThreeDObject, Long> {
}
