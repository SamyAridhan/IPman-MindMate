//src\main\java\com\mindmate\MindMateApplication.java
package com.mindmate;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class MindMateApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(MindMateApplication.class, args);
    }
}

