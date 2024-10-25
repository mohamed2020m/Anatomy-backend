package com.med3dexplorer.services.interfaces;

import com.med3dexplorer.dto.NoteDTO;
import com.med3dexplorer.exceptions.FileNotFoundException;
import com.med3dexplorer.exceptions.NoteNotFoundException;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface FileService {

    String uploadFile(MultipartFile file);
    byte[] downloadFile (String fileName) throws FileNotFoundException;
    boolean deleteFile(String path) throws FileNotFoundException;


}
