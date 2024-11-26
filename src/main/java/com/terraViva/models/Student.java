package com.terraViva.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Data;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
@Entity
@DiscriminatorValue("STUD")
public class Student extends User{
//    @OneToMany(mappedBy="student", fetch=FetchType.EAGER, cascade=CascadeType.ALL)
//    @JsonIgnore
//    private List<Note> notes = new ArrayList<>();

    @OneToMany(mappedBy="student", fetch=FetchType.EAGER, cascade=CascadeType.ALL)
    @JsonIgnore
    private List<Favourite> favourites = new ArrayList<>();

    @ManyToMany(fetch = FetchType.EAGER)
    @JsonIgnore
    private Collection<Category> categories=new ArrayList<>();
}
