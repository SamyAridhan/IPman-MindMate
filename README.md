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
````

## Prerequisites

  - Java 17 or higher
  - Maven 3.6 or higher
  - IDE (IntelliJ IDEA, Eclipse, or VS Code recommended)

## Setup Instructions

### 1\. Clone the Repository

```bash
git clone <repository-url>
cd IPman-MindMate
```

### 2\. Build the Project

```bash
mvn clean install
```

### 3\. Run the Application

**Option A: Using Maven Spring Boot Plugin (RECOMMENDED)**

```bash
mvn spring-boot:run
```

**Option B: Using Java**

```bash
java -jar target/mindmate-1.0.0.war
```

**Option C: Deploy as WAR**

  - Build the WAR file: `mvn clean package`
  - Deploy `target/mindmate-1.0.0.war` to your application server (Tomcat, etc.)

### 4\. Access the Application

  - Open your browser and navigate to: `http://localhost:8080`
  - You will be redirected to the login page

## Demo Access

The login page includes three demo buttons to bypass authentication:

  - **Login as Student** → `/student/dashboard`
  - **Login as Counselor** → `/counselor/dashboard`
  - **Login as Admin** → `/admin/dashboard`

## Available Routes

### Authentication

  - `GET /` → Redirects to `/login`
  - `GET /login` → Login page
  - `GET /register` → Registration page
  - `POST /login` → Mock login (redirects to student dashboard)

### Student Routes (`/student`)

  - `GET /student/dashboard` → Student dashboard
  - `GET /student/assessment` → Assessment list
  - `GET /student/assessment/take` → Take assessment
  - `GET /student/library` → Content library
  - `GET /student/forum` → Forum list (with dummy threads)
  - `GET /student/forum/thread` → Forum thread view
  - `GET /student/chatbot` → Chatbot interface
  - `GET /student/telehealth` → Book telehealth appointment
  - `GET /student/telehealth/my-appointments` → View appointments

### Counselor Routes (`/counselor`)

  - `GET /counselor/dashboard` → Counselor dashboard
  - `GET /counselor/content` → Content manager
  - `GET /counselor/schedule` → Schedule manager

### Admin Routes (`/admin`)

  - `GET /admin/dashboard` → Admin dashboard

## Development Notes

### Hot Reload

Spring Boot DevTools is included. Changes to Java files will trigger an automatic server restart.

### JSP Development

  - JSP files are located in `src/main/webapp/WEB-INF/jsp/`
  - Tailwind CSS is loaded via CDN in `common/header.jsp`
  - **Always** include `<jsp:include page="../common/header.jsp" />` at the top of new pages.

## Configuration

Application properties are configured in `src/main/resources/application.properties`:

```properties
spring.mvc.view.prefix=/WEB-INF/jsp/
spring.mvc.view.suffix=.jsp
server.port=8080
```

## Generation Report

### Structure Verification

✅ All folders created as specified
✅ Complete directory structure matches requirements

### Controller Check

✅ **AuthController:** `/`, `/login`, `/register`, `POST /login`
✅ **StudentController:** All 9 student modules mapped.
✅ **CounselorController:** Dashboard, Content Management, and Schedule mapped.
✅ **AdminController:** Dashboard mapped.

### Next Steps Checklist

  - [x] Project structure created
  - [x] Dependencies configured in pom.xml
  - [x] Controllers implemented
  - [x] JSP views created
  - [ ] Run `mvn clean install` to build
  - [ ] Run `mvn spring-boot:run` to start server
  - [ ] Navigate to `http://localhost:8080` in browser
  - [ ] Test navigation using demo login buttons

## License

University Project - Internal Use Only

```
```