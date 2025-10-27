/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import org.apache.poi.xwpf.extractor.XWPFWordExtractor;
import org.apache.poi.xwpf.usermodel.XWPFDocument;

/**
 *
 * @author Admin
 */
public class DocxTextUtil {

    public static String extractText(File docx) throws IOException {
        try (FileInputStream fis = new FileInputStream(docx);
             XWPFDocument doc = new XWPFDocument(fis);
             XWPFWordExtractor extract = new XWPFWordExtractor(doc)) {
            String text = extract.getText();
            return text != null ? text.trim() : "";
        }
    }

    
}
