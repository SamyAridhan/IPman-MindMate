// src/main/java/com/mindmate/util/SessionHelper.java

package com.mindmate.util;

import jakarta.servlet.http.HttpSession;

/**
 * Utility class for managing user session data.
 * Provides convenient methods to check authentication status and retrieve user info.
 * 
 * @author Samy (A23CS0246)
 */
public class SessionHelper {

    // Session attribute keys
    private static final String USER_ID = "userId";
    private static final String USER_NAME = "userName";
    private static final String USER_EMAIL = "userEmail";
    private static final String USER_ROLE = "userRole";

    /**
     * Checks if a user is currently logged in.
     * 
     * @param session The HTTP session
     * @return true if user is authenticated, false otherwise
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session.getAttribute(USER_ID) != null;
    }

    /**
     * Gets the role of the currently logged-in user.
     * 
     * @param session The HTTP session
     * @return Role string ("student", "counselor", "admin") or null if not logged in
     */
    public static String getRole(HttpSession session) {
        return (String) session.getAttribute(USER_ROLE);
    }

    /**
     * Gets the ID of the currently logged-in user.
     * 
     * @param session The HTTP session
     * @return User ID or null if not logged in
     */
    public static Long getUserId(HttpSession session) {
        return (Long) session.getAttribute(USER_ID);
    }

    /**
     * Gets the name of the currently logged-in user.
     * 
     * @param session The HTTP session
     * @return User name or null if not logged in
     */
    public static String getUserName(HttpSession session) {
        return (String) session.getAttribute(USER_NAME);
    }

    /**
     * Gets the email of the currently logged-in user.
     * 
     * @param session The HTTP session
     * @return User email or null if not logged in
     */
    public static String getUserEmail(HttpSession session) {
        return (String) session.getAttribute(USER_EMAIL);
    }

    /**
     * Stores user information in the session after successful login.
     * 
     * @param session The HTTP session
     * @param userId User's database ID
     * @param userName User's full name
     * @param userEmail User's email
     * @param userRole User's role (student/counselor/admin)
     */
    public static void setUserSession(HttpSession session, Long userId, String userName, 
                                     String userEmail, String userRole) {
        session.setAttribute(USER_ID, userId);
        session.setAttribute(USER_NAME, userName);
        session.setAttribute(USER_EMAIL, userEmail);
        session.setAttribute(USER_ROLE, userRole);
    }

    /**
     * Clears all user data from the session (logout).
     * 
     * @param session The HTTP session
     */
    public static void clearSession(HttpSession session) {
        session.invalidate();
    }
}