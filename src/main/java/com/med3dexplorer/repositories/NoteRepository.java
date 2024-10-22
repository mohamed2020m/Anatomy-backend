package com.med3dexplorer.repositories;

import com.med3dexplorer.models.Note;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NoteRepository extends JpaRepository<Note, Long> {}

