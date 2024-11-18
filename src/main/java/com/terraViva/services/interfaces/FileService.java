package com.terraViva.services.interfaces;

import com.terraViva.exceptions.FileNotFoundException;
import org.springframework.web.multipart.MultipartFile;

public interface FileService {

    String uploadFile(MultipartFile file);
    byte[] downloadFile (String fileName) throws FileNotFoundException;
    boolean deleteFile(String path) throws FileNotFoundException;


}
