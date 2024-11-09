package com.med3dexplorer.controllers;

import com.med3dexplorer.dto.StudentDTO;
import com.med3dexplorer.models.Student;
import com.med3dexplorer.services.implementations.StudentServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/students")
@CrossOrigin("*")
public class StudentController {

        private StudentServiceImpl studentService;

        public StudentController(StudentServiceImpl  studentService) {
            this. studentService =  studentService;
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
}
