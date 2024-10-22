package com.med3dexplorer.models;

import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Data
@Entity
@Table(name = "professors")
public class Professor extends User {

    @ManyToOne
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @OneToMany(mappedBy = "professor", cascade = CascadeType.ALL)
    private List<ThreeDObject> threeDObjects;
}