package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Favourite;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FavouriteRepository extends JpaRepository<Favourite, Long> {
}
