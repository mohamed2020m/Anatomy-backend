package com.med3dexplorer.utils;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;


@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private TemplateEngine templateEngine;

    public void sendEmail(String recipientEmail, String name) throws MessagingException {
        MimeMessage mimeMessage = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true);

        // Set the email details
        helper.setTo(recipientEmail);
        helper.setSubject("Welcome to Med3D Explorer!");

        // Prepare the email body using the template
        Context context = new Context();
        context.setVariable("name", name);
        String htmlContent = templateEngine.process("email-template", context);

        helper.setText(htmlContent, true);

        // Send the email
        mailSender.send(mimeMessage);
    }
}
