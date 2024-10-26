package com.med3dexplorer.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Data
@Entity
@DiscriminatorValue("PROF")
public class Professor extends User {

//    @OneToMany(mappedBy="professor",fetch=FetchType.LAZY)
//    @JsonIgnore
//    private List<ThreeDObject> threeDObjects;

    @ManyToOne
    private Category category;
}