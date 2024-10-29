package com.med3dexplorer.services.implementations;

import com.med3dexplorer.dto.AdministratorDTO;
import com.med3dexplorer.exceptions.UserNotFoundException;
import com.med3dexplorer.mapper.AdministratorDTOConverter;
import com.med3dexplorer.models.Administrator;
import com.med3dexplorer.repositories.AdministratorRepository;
import com.med3dexplorer.services.interfaces.AdministratorService;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class AdministratorServiceImpl implements AdministratorService {

    private final AdministratorDTOConverter administratorDTOConverter;
    private AdministratorRepository administratorRepository;


    public AdministratorServiceImpl(AdministratorRepository administratorRepository, AdministratorDTOConverter administratorDTOConverter) {
        this.administratorDTOConverter = administratorDTOConverter;
        this.administratorRepository = administratorRepository;
    }


    @Override
    public AdministratorDTO saveAdministrator(AdministratorDTO administratorDTO){
        Administrator administrator=administratorDTOConverter.toEntity(administratorDTO);
        AdministratorDTO savedAdministrator =administratorDTOConverter.toDto(administratorRepository.save(administrator));
        return savedAdministrator;
    }

    @Override
    public AdministratorDTO getAdministratorById(Long administratorId) throws UserNotFoundException {
        Administrator administrator = administratorRepository.findById(administratorId).orElseThrow(() -> new UserNotFoundException("Administrator not found"));
        AdministratorDTO administratorDTO = administratorDTOConverter.toDto(administrator);
        return administratorDTO;
    }

    @Override
    public List<AdministratorDTO> getAllAdministrators() {
        List<Administrator> administrators = administratorRepository.findAll();
        List<AdministratorDTO> administratorDTOs = administrators.stream().map(administrator -> administratorDTOConverter.toDto(administrator)).collect(Collectors.toList());
        return administratorDTOs;
    }

    @Override
    public AdministratorDTO updateAdministrator(AdministratorDTO administratorDTO) throws UserNotFoundException {
        Administrator existingAdministrator = administratorRepository.findById(administratorDTO.getId())
                .orElseThrow(() -> new UserNotFoundException("Administrator not found with id: " + administratorDTO.getId()));
        Administrator updatedAdministrator = administratorRepository.save(administratorDTOConverter.toEntity(administratorDTO));
        return administratorDTOConverter.toDto(updatedAdministrator);
    }

    @Override
    public void deleteAdministrator(Long administratorId) throws UserNotFoundException {
        Administrator administrator=administratorRepository.findById(administratorId).orElseThrow(() -> new UserNotFoundException("Administrator not found"));
        administratorRepository.delete(administrator);
    }

    @Override
    public AdministratorDTO getAdminInfo(String username) throws UserNotFoundException {
        Administrator administrator = administratorRepository.findByEmail(username)
            .orElseThrow(() -> new UserNotFoundException("Admin not found"));
        return administratorDTOConverter.toDto(administrator);
    }
}