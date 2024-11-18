package com.terraViva.controllers;

import com.terraViva.dto.FileResponse;
import com.terraViva.exceptions.FileNotFoundException;
import com.terraViva.services.implementations.FileServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/v1/files")
public class FileController {

    private final FileServiceImpl fileService;

    @Autowired
    public FileController(FileServiceImpl fileService) {
        this.fileService = fileService;
    }

    @PostMapping("/upload")
    public ResponseEntity<FileResponse> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            String filePath = fileService.uploadFile(file);
            return ResponseEntity.status(HttpStatus.OK)
                    .body(new FileResponse("File uploaded successfully", filePath));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new FileResponse("File upload failed: " + e.getMessage(), null));
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

//    @DeleteMapping("/delete/{fileName}")
//    public ResponseEntity<String> deleteFile(@PathVariable String fileName) {
//        boolean deleted = fileService.deleteFile(fileName);
//        if (deleted) {
//            return ResponseEntity.ok("File deleted successfully: " + fileName);
//        } else {
//            return ResponseEntity.status(500).body("File deletion failed.");
//        }
//    }

    @DeleteMapping(path = "/delete/{path}")
    public ResponseEntity<Map<String, String>> deleteUserImage(@PathVariable("path") String path) {
        try {
            path = path.replaceFirst("-", "/");
            boolean isDeleted = fileService.deleteFile(path);

            Map<String, String> response = new HashMap<>();
            if (isDeleted) {
                response.put("message", "Image deleted successfully");
                return ResponseEntity.ok(response);
            } else {
                response.put("message", "Image not found or could not be deleted");
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
            }
        } catch (Exception e) {
            Map<String, String> response = new HashMap<>();
            response.put("message", "Failed to delete image: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
