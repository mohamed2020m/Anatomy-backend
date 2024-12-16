package com.terraViva.services.implementations;

import com.terraViva.dto.AdministratorDTO;
import com.terraViva.dto.UpdateUserInfoRequestDTO;
import com.terraViva.exceptions.UserNotFoundException;
import com.terraViva.mapper.AdministratorDTOConverter;
import com.terraViva.models.Administrator;
import com.terraViva.repositories.AdministratorRepository;
import com.terraViva.services.interfaces.AdministratorService;
import jakarta.transaction.Transactional;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class AdministratorServiceImpl implements AdministratorService {

    private final PasswordEncoder passwordEncoder;

    private final AdministratorDTOConverter administratorDTOConverter;
    private AdministratorRepository administratorRepository;


    public AdministratorServiceImpl(PasswordEncoder passwordEncoder,AdministratorRepository administratorRepository, AdministratorDTOConverter administratorDTOConverter) {
        this.administratorDTOConverter = administratorDTOConverter;
        this.passwordEncoder = passwordEncoder;
        this.administratorRepository = administratorRepository;
    }


    @Override
    public AdministratorDTO saveAdministrator(AdministratorDTO administratorDTO){
        Administrator administrator=administratorDTOConverter.toEntity(administratorDTO);
        administrator.setCreatedAt(LocalDateTime.now());
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
        if (administratorDTO.getEmail() != null) {
            existingAdministrator.setEmail(administratorDTO.getEmail());
        }
        if (administratorDTO.getFirstName() != null) {
            existingAdministrator.setFirstName(administratorDTO.getFirstName());
        }

        if (administratorDTO.getLastName() != null) {
            existingAdministrator.setLastName(administratorDTO.getLastName());
        }
        if (administratorDTO.getPassword() != null) {
            existingAdministrator.setPassword(passwordEncoder.encode(administratorDTO.getPassword()));
        }
        if (administratorDTO.getCreatedAt() != null) {
            existingAdministrator.setCreatedAt(administratorDTO.getCreatedAt());
        }

        existingAdministrator.setUpdatedAt(LocalDateTime.now());
        Administrator updatedAdministrator = administratorRepository.save(existingAdministrator);
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

    @Override
    public Long getAdminsCount() {
        return administratorRepository.count();
    }

    @Override
    public void updateAdminInfo(String username, UpdateUserInfoRequestDTO updateUserInfoRequest) {
        Administrator administrator = administratorRepository.findByEmail(username)
                .orElseThrow(() -> new UserNotFoundException("Administrator not found"));

        if (updateUserInfoRequest.getFirstName() != null) {
            administrator.setFirstName(updateUserInfoRequest.getFirstName());
        }
        if (updateUserInfoRequest.getLastName() != null) {
            administrator.setLastName(updateUserInfoRequest.getLastName());
        }

        administrator.setUpdatedAt(LocalDateTime.now());
        administratorRepository.save(administrator);
    }
}