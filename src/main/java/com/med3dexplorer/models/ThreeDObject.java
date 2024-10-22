package com.med3dexplorer.models;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
public class ThreeDObject {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String descriptionAudio;
    private String image;
    private LocalDateTime createdAt;

    @ManyToOne
    @JoinColumn(name = "professor_id", nullable = false)
    private Professor professor;

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;


}
