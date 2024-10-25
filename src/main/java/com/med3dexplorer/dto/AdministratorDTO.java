package com.med3dexplorer.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AdministratorDTO {

    private Long id;
    private String email;
    private String firstName;
    private String lastName;
    private String password;
}
