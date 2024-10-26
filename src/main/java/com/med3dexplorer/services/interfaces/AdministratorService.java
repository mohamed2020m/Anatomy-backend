package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.AdministratorDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;

import java.util.List;

public interface AdministratorService {


    AdministratorDTO saveAdministrator(AdministratorDTO administratorDTO);

    AdministratorDTO getAdministratorById(Long administratorId) throws UserNotFoundException;

    List<AdministratorDTO> getAllAdministrators();

    AdministratorDTO updateAdministrator(AdministratorDTO administratorDTO)throws UserNotFoundException;

    void deleteAdministrator(Long administratorId) throws UserNotFoundException;

    AdministratorDTO getAdminInfo(String username);
}
