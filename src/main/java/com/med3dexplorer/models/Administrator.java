package com.med3dexplorer.models;


import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@DiscriminatorValue("ADMIN")
public class Administrator extends User {
}
