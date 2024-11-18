package com.terraViva.models;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Entity
@Table(name = "categories")
@Builder
public class Category {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String description;
    private String image;

    @CreationTimestamp
    private LocalDateTime createdAt;
    @UpdateTimestamp
    private LocalDateTime updatedAt;

//    @OneToMany(mappedBy="category",fetch=FetchType.EAGER, cascade=CascadeType.ALL)
//    @JsonIgnore
//    private List<ThreeDObject> threeDObjects;
//
//    @OneToMany(mappedBy="category", fetch=FetchType.EAGER, cascade=CascadeType.ALL)
//    @JsonIgnore
//    private List<Professor> professors;
//
//    @OneToMany(mappedBy = "parentCategory", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
//    @JsonIgnore
//    private List<Category> subCategories;

    @OneToMany(mappedBy="category", fetch=FetchType.EAGER, cascade=CascadeType.REMOVE, orphanRemoval = true)
    @JsonIgnore
    private List<ThreeDObject> threeDObjects;

    @OneToMany(mappedBy="category", fetch=FetchType.EAGER, cascade=CascadeType.REMOVE, orphanRemoval = true)
    @JsonIgnore
    private List<Professor> professors;

    @OneToMany(mappedBy = "parentCategory", fetch = FetchType.LAZY, cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonIgnore
    private List<Category> subCategories;

    @ManyToOne
    @JoinColumn(name = "parent_category_id")
    private Category parentCategory;

    @ManyToMany(mappedBy = "categories",fetch = FetchType.EAGER)
    @JsonIgnore
    private Collection<Student> students=new ArrayList<>();


    @Override
    public String toString() {
        return "Category{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", image='" + image + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", professorCount=" + (professors != null ? professors.size() : 0) +
                '}';
    }
}
