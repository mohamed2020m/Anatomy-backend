package com.med3dexplorer.models;


import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "categories")
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String image;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdAt;

    @OneToMany(mappedBy="category",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<ThreeDObject> threeDObjects;

    @OneToMany(mappedBy="category",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Professor> professors;







}
