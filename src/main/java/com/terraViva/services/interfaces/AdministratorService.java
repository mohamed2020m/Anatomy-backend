package com.terraViva.services.interfaces;

import com.terraViva.dto.AdministratorDTO;
import com.terraViva.dto.UpdateUserInfoRequestDTO;
import com.terraViva.exceptions.UserNotFoundException;

import java.util.List;

public interface AdministratorService {


    AdministratorDTO saveAdministrator(AdministratorDTO administratorDTO);

    AdministratorDTO getAdministratorById(Long administratorId) throws UserNotFoundException;

    List<AdministratorDTO> getAllAdministrators();

    AdministratorDTO updateAdministrator(AdministratorDTO administratorDTO)throws UserNotFoundException;

    void deleteAdministrator(Long administratorId) throws UserNotFoundException;

    AdministratorDTO getAdminInfo(String username);

    Long getAdminsCount();

    void updateAdminInfo(String username, UpdateUserInfoRequestDTO updateUserInfoRequest);
}
