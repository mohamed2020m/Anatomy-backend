package com.med3dexplorer.utils;


import com.med3dexplorer.dto.RegisterUserDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

@Service
public class ExcelUtility {


    public List<RegisterUserDTO> parseExcelFile(InputStream is) {
        List<RegisterUserDTO> students = new ArrayList<>();

        try (Workbook workbook = new XSSFWorkbook(is)) {
            Sheet sheet = workbook.getSheetAt(0);

            for (int i = 1; i <= sheet.getLastRowNum(); i++) { // Start from row 1 (row 0 is header)
                Row row = sheet.getRow(i);
                RegisterUserDTO student = new RegisterUserDTO();
                student.setFirstName(row.getCell(0).getStringCellValue());
                student.setLastName(row.getCell(1).getStringCellValue());
                student.setEmail(row.getCell(2).getStringCellValue());
                student.setPassword(String.valueOf(row.getCell(3).getNumericCellValue()));
                student.setRole("STUD");
                students.add(student);
            }
        } catch (Exception e) {
            throw new IllegalStateException("Failed to parse Excel file: " + e.getMessage());
        }
        return students;
    }
}
