package com.m15.clicknbuy.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.m15.clicknbuy.entity.User;
import com.m15.clicknbuy.repository.UserRepository;

@Component
public class AdminInitializer implements CommandLineRunner {

    @Autowired
    UserRepository userRepository;

    @Autowired
    PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        if (!userRepository.findByEmail("admin@gmail.com").isPresent()) {
            User admin = new User();
            admin.setName("Admin");
            admin.setEmail("admin@gmail.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setMobile(9999999999L);
            admin.setGender("Male");
            admin.setVerified(true);
            admin.setRole("ROLE_ADMIN");
            userRepository.save(admin);
            System.out.println("Default Admin account created: admin@gmail.com / admin123");
        }
    }
}
