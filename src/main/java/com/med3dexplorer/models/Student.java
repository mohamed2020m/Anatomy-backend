package com.med3dexplorer.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
@Entity
@DiscriminatorValue("STUD")
public class Student extends User{


    @OneToMany(mappedBy="student",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Note> notes;

    @OneToMany(mappedBy="student",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Favourite> favourites;


    @ManyToMany(fetch = FetchType.EAGER)
    @JsonIgnore
    private Collection<Category> categories=new ArrayList<>();




    /*
    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Note> notes;

    @OneToMany(mappedBy = "student", cascade = CascadeType.ALL)
    private List<Favourite> favourites;

    @ManyToMany
    private List<Category> categories;*/
}
