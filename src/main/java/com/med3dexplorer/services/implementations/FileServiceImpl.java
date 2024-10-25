package com.med3dexplorer.services.implementations;

import com.med3dexplorer.exceptions.FileNotFoundException;
import com.med3dexplorer.services.interfaces.FileService;
import com.med3dexplorer.utils.FileStore;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;


import java.util.*;

@Service
public class FileServiceImpl implements FileService {
    private final FileStore fileStore;

    public FileServiceImpl(FileStore fileStore) {
        this.fileStore = fileStore;
    }

    public String uploadFile(MultipartFile file) {

        // Generate a unique file name, keeping the original file extension
        String extension = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf('.'));
        String folder = extension.equals(".glb") ? "objects" : "images";

        String uniqueFileName = UUID.randomUUID().toString() + extension;

        // Create the full path (without repeating the folder name twice)
        String fileName = String.format("%s/%s", folder, uniqueFileName);

        Map<String, String> metadata = new HashMap<>();
        metadata.put("content-type", file.getContentType());
        metadata.put("content-length", String.valueOf(file.getSize()));

        try {
            // Save the file to the file system
            fileStore.save(folder, uniqueFileName, Optional.of(metadata), file.getInputStream());
            return fileName;
        } catch (Exception e) {
            throw new IllegalStateException("Something went wrong while uploading the file", e);
        }
    }



    public byte[] downloadFile(String fileName) throws FileNotFoundException {
        return fileStore.download(fileName);
    }

    public boolean deleteFile(String path) {
        return fileStore.delete(path);
    }
}


