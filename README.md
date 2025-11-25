# MindMate - Mental Health Platform

**University Project - Spring Boot JSP Web Application**

---

## 🚨 CRITICAL: How to Port Lovable Code (Read Before Coding)

We are porting a React (Lovable) prototype into a JSP environment. You **cannot** simply copy-paste React code. Follow these 3 rules to ensure your pages work.

### Rule 1: No React Logic allowed
JSP is HTML-based. React logic will break the build.
* **DELETE** all `import` statements at the top of the file.
* **REMOVE** any `const`, `useState`, or `useEffect` hooks.
* **CONVERT** navigation:
    * ❌ React: `<button onClick={() => navigate('/student/assessment')}>`
    * ✅ JSP: `<a href="/student/assessment" class="...">`

### Rule 2: How to use Icons
React components like `<Calendar />` do not work in JSP. We are using **Lucide Icons** via CDN (already configured in `header.jsp`).
* **CONVERT** the tag:
    * ❌ React: `<Calendar className="h-4 w-4" />`
    * ✅ JSP: `<i data-lucide="calendar" class="h-4 w-4"></i>`
* *Note: Use lowercase names (e.g., `BellRing` becomes `bell-ring`).*

### Rule 3: Handling Images
Images referenced in Lovable live on their server. For our app, they must be local.
1.  **SAVE** the image from the prototype to: `src/main/resources/static/images/`
2.  **UPDATE** the source path:
    * ❌ React: `<img src="/lovable-uploads/hero.png" />`
    * ✅ JSP: `<img src="/images/hero.png" />`

---

## Overview

MindMate is a mental health platform built with Spring Boot 3.3.5 and JSP views. This is a "Potemkin Village" (facade) implementation for the Phase 2 demo, featuring working navigation and UI without full backend logic.

## Technical Stack

-   **Framework:** Spring Boot 3.3.5
-   **Language:** Java 17
-   **Build Tool:** Maven
-   **View Engine:** JSP (JavaServer Pages)
-   **Styling:** Tailwind CSS (via CDN)
-   **Packaging:** WAR (Web Application Archive)

## Project Structure

```text
src/main/
├── java/com/mindmate/
│   ├── MindMateApplication.java
│   └── controller/
│       ├── AuthController.java
│       ├── StudentController.java
│       ├── CounselorController.java
│       └── AdminController.java
└── webapp/WEB-INF/jsp/
    ├── common/
    │   ├── header.jsp            <-- Includes Tailwind & Lucide CDN
    │   └── footer.jsp            <-- Includes Icon Activation Script
    ├── auth/
    │   ├── login.jsp
    │   └── register.jsp
    ├── student/
    │   ├── dashboard.jsp
    │   ├── assessment-list.jsp
    │   ├── assessment-questions.jsp
    │   ├── assessment-result.jsp
    │   ├── content-library.jsp
    │   ├── content-view.jsp
    │   ├── forum-list.jsp
    │   ├── forum-thread.jsp
    │   ├── chatbot.jsp
    │   ├── telehealth-book.jsp
    │   └── telehealth-my-appointments.jsp
    ├── counselor/
    │   ├── dashboard.jsp
    │   ├── schedule.jsp
    │   └── content-manager.jsp
    └── admin/
        └── dashboard.jsp