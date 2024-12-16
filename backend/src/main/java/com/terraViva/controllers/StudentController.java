package com.terraViva.controllers;

import com.terraViva.dto.CategoryStudentCountDTO;
import com.terraViva.dto.RegisterUserDTO;
import com.terraViva.dto.ResponseMessage;
import com.terraViva.dto.StudentDTO;
import com.terraViva.services.implementations.AuthenticationServiceImpl;
import com.terraViva.services.implementations.StudentServiceImpl;
import com.terraViva.utils.ExcelUtility;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/v1/students")
@CrossOrigin("*")
public class StudentController {

    private StudentServiceImpl studentService;
    private ExcelUtility excelService;
    private AuthenticationServiceImpl authenticationService;

    public StudentController(StudentServiceImpl  studentService, ExcelUtility excelService, AuthenticationServiceImpl authenticationService) {
        this. studentService =  studentService;
        this.excelService = excelService;
        this.authenticationService = authenticationService;
    }


    @PostMapping
    public ResponseEntity<StudentDTO> saveStudent(@RequestBody StudentDTO studentDTO) {
        return ResponseEntity.ok(studentService.saveStudent(studentDTO));
    }

    @GetMapping("/{id}")
    public ResponseEntity<StudentDTO> getStudentById(@PathVariable Long id){
        return ResponseEntity.ok(studentService.getStudentById(id));
    }


    @GetMapping
    public ResponseEntity<List<StudentDTO>> getAllStudents() {
        return ResponseEntity.ok(studentService.getAllStudents());
    }


    @PutMapping("/{id}")
    public ResponseEntity<StudentDTO> updateStudent(@PathVariable Long id, @RequestBody StudentDTO studentDTO) {
        studentDTO.setId(id);
        StudentDTO updatedStudent = studentService.updateStudent(studentDTO);
        return ResponseEntity.ok(updatedStudent);
    }


    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteStudent(@PathVariable Long id){
        studentService.deleteStudent(id);
        return new ResponseEntity("Student deleted successfully", HttpStatus.OK);
    }

    @GetMapping("/by-professor/{professorId}")
    public ResponseEntity<List<StudentDTO>> getStudentsByProfessorCategory(@PathVariable Long professorId) {
        List<StudentDTO> students = studentService.getStudentsByProfessorCategory(professorId);
        return ResponseEntity.ok(students);
    }

    @GetMapping("/count")
        public Long getCategoriesCount() {
        return studentService.getStudentsCount();
    }

    @GetMapping("/main-categories/student-counts")
    public ResponseEntity<List<CategoryStudentCountDTO>> getStudentsCountByMainCategories() {
        List<CategoryStudentCountDTO> categoryStudentCounts = studentService.getStudentsCountByMainCategories();
        return ResponseEntity.ok(categoryStudentCounts);
    }

    @PostMapping("/upload-excel")
    public ResponseEntity<?> uploadExcelFile(@RequestParam("file") MultipartFile file) {
        try {
            List<RegisterUserDTO> students = excelService.parseExcelFile(file.getInputStream());
            for (RegisterUserDTO student : students) {
                authenticationService.signup(student);
            }
            return ResponseEntity.ok(new ResponseMessage("success", "Students added successfully."));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ResponseMessage("error", e.getMessage()));
        }
    }
}
