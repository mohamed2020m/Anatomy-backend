package com.terraViva.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;
import java.util.Optional;

@Service
public class FileStore {
    private static final Logger logger = LoggerFactory.getLogger(FileStore.class);

    private final String storageFolder = "storage_3d_objs";

    public FileStore() {
        // Create the main storage directory if it does not exist
        File directory = new File(storageFolder);
        if (!directory.exists()) {
            directory.mkdirs();
        }
    }

    public void save(String path, String fileName, Optional<Map<String, String>> optionalMetaData, InputStream inputStream) {
        Path fullPath = Paths.get(storageFolder, path, fileName);

        try {
            // Ensure the folder for the file type exists (e.g., "objects" or "images")
            Files.createDirectories(fullPath.getParent());

            try (FileOutputStream outputStream = new FileOutputStream(fullPath.toFile())) {
                byte[] buffer = new byte[1024];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }
        } catch (IOException e) {
            throw new IllegalStateException("Failed to store file locally: " + e.toString());
        }
    }

    public byte[] download(String fileName) {
        Path fullPath = Paths.get(storageFolder, fileName);

        try (FileInputStream inputStream = new FileInputStream(fullPath.toFile())) {
            return inputStream.readAllBytes();
        } catch (IOException e) {
            throw new IllegalStateException("Failed to download file locally: " + e.toString());
        }
    }

    public boolean delete(String path) {
        Path fullPath = Paths.get(storageFolder, path);
        logger.info(String.valueOf(fullPath));

        try {
            Files.delete(fullPath);
            return true;
        } catch (IOException e) {
            return false;
        }
    }
}
