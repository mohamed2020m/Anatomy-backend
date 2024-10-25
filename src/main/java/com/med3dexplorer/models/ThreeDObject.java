package com.med3dexplorer.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.time.LocalDateTime;
import java.util.List;

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


    @OneToMany(mappedBy="threeDObject",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Note> notes;

    @OneToMany(mappedBy="threeDObject",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Favourite> favourites;

    @ManyToOne
    private Professor professor;


    @ManyToOne
    private Category category;




}
