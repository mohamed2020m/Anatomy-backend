package com.med3dexplorer.models;


import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "administrators")
public class Administrator extends User {
}
