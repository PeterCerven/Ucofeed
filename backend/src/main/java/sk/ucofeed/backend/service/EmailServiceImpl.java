package sk.ucofeed.backend.service;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class EmailServiceImpl {

    private static final Logger LOG = LoggerFactory.getLogger(EmailServiceImpl.class);

    private final JavaMailSender mailSender;

    public EmailServiceImpl(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    public void sendVerificationCode(String toEmail, String verificationCode) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("Your Verification Code - Ucofeed");
            helper.setText(buildEmailContent(verificationCode), true);

            mailSender.send(message);
            LOG.info("Verification email sent successfully to: {}", toEmail);
        } catch (MessagingException e) {
            LOG.error("Failed to send verification email to: {}", toEmail, e);
            throw new RuntimeException("Failed to send verification email", e);
        }
    }

    private String buildEmailContent(String verificationCode) {
        return String.format("""
                <html>
                <body style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
                    <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
                        <h2 style="color: #4CAF50;">Welcome to Ucofeed!</h2>
                        <p>Thank you for signing up. To complete your login, please use the verification code below:</p>
                        <div style="background-color: #f4f4f4; padding: 15px; border-radius: 5px; text-align: center; margin: 20px 0;">
                            <h1 style="color: #4CAF50; margin: 0; font-size: 32px; letter-spacing: 5px;">%s</h1>
                        </div>
                        <p>This code will expire in 15 minutes.</p>
                        <p>If you didn't request this code, please ignore this email.</p>
                        <hr style="border: none; border-top: 1px solid #ddd; margin: 20px 0;">
                        <p style="font-size: 12px; color: #999;">This is an automated message, please do not reply.</p>
                    </div>
                </body>
                </html>
                """, verificationCode);
    }
}