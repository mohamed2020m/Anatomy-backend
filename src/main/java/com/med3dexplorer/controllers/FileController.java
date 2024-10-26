package com.med3dexplorer.controllers;

import com.med3dexplorer.exceptions.FileNotFoundException;
import com.med3dexplorer.services.implementations.FileServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/files")
public class FileController {

    private final FileServiceImpl fileService;

    @Autowired
    public FileController(FileServiceImpl fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    public ResponseEntity<String> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String filePath = fileService.uploadFile(file);
            return ResponseEntity.ok("File uploaded successfully: " + filePath);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("File upload failed: " + e.getMessage());
        }
    }

    @GetMapping("/download/{fileName}")
    public ResponseEntity<byte[]> downloadFile(@PathVariable String fileName) {
        try {
            byte[] fileData = fileService.downloadFile(fileName.replaceFirst("-", "/"));
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .body(fileData);
        } catch (FileNotFoundException e) {
            return ResponseEntity.status(500).body(null);
        }
    }

    @DeleteMapping("/delete/{fileName}")
    public ResponseEntity<String> deleteFile(@PathVariable String fileName) {
        boolean deleted = fileService.deleteFile(fileName);
        if (deleted) {
            return ResponseEntity.ok("File deleted successfully: " + fileName);
        } else {
            return ResponseEntity.status(500).body("File deletion failed.");
        }
    }
}
