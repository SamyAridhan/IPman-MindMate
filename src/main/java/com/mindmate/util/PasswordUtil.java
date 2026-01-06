// src/main/java/com/mindmate/util/PasswordUtil.java

package com.mindmate.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

/**
 * Utility class for password hashing and verification using BCrypt.
 * * @author Samy (A23CS0246)
 */
public class PasswordUtil {

    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    /**
     * Hashes a plain text password using BCrypt.
     * * @param plainPassword The plain text password
     * @return BCrypt hashed password
     */
    public static String hashPassword(String plainPassword) {
        return encoder.encode(plainPassword);
    }

    /**
     * Verifies if a plain text password matches a hashed password.
     * * @param plainPassword The plain text password to check
     * @param hashedPassword The BCrypt hashed password from database
     * @return true if passwords match, false otherwise
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        return encoder.matches(plainPassword, hashedPassword);
    }

    /**
     * Checks if a plain text password matches a hashed password.
     * (Alias for verifyPassword to support Controller logic)
     * * @param plainPassword The plain text password to check
     * @param hashedPassword The BCrypt hashed password from database
     * @return true if passwords match, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return encoder.matches(plainPassword, hashedPassword);
    }
}