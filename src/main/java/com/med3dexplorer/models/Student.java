package com.med3dexplorer.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Entity
@Table(name = "students")
public class Student extends User{

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Note> notes;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Favourite> favourites;

    @ManyToMany
    private List<Category> categories;
}
