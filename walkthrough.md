# Walkthrough - SafeExam.AI Online Exam & AI Proctoring Platform

This walkthrough provides a summary of the implementation and validation details for the **SafeExam.AI** application.

---

## 🚀 Accomplished Features

The platform is divided into three distinct roles (Admin, Teacher, and Student) with custom pages, modals, and endpoints:

1. **Admin Control Panel (Enhanced)**:
   - **Responsive Side Navigation Layout**: Replaced the horizontal tabs with a premium, collapsible sidenav that slides in on mobile devices.
   - Manage admin credentials.
   - Add, suspend, and delete teacher and student accounts.
   - Review pending user registrations and approve or reject them.
   - Create courses and assign teachers to them.
   - **Bulk Direct Enrollment Modal**: Replaced the single student selector with a searchable checkable list allowing the admin to search students by ID/Name, select multiple students (with "Select All" support), and enroll them simultaneously.
   - Direct enroll multiple students to courses at once in a single transaction in the backend.

2. **Teacher Console**:
   - Manage teacher profile (with profile picture upload support).
   - View and manage taught courses.
   - Create exams with customized questions (option keys A, B, C, D), date/time, and duration parameters.
   - Approve student enrollment requests.
   - View **live AI Proctor logs** feed (updated automatically) and read the raw physical `cheating_activity.log` file, with options to download or clear it.

3. **Student Portal**:
   - Change student password securely.
   - View available scheduled exams and enter the active sitting workspace.
   - Submit course enrollment requests.
   - Attend online exams with:
     - **Webcam feed monitor** verification.
     - **Copy-paste prevention** (Ctrl+C, selection copy, and answer box pasting are hooked and trigger suspicion reports).
     - **AI Proctor YOLOv8 Simulation Panel** to manually trigger suspicious events (Talking, Mobile Watch, Taking Photo) for test evaluations.
     - **5-Minute Lockout Block Screen**: Activates instantly if demerits reach 5 points, disabling all question panels. Additional violations during lock extend the block duration.

---

## 🛠️ Port & Server Configurations

- **Frontend client**: Running at `http://localhost:5173/` using Vite + React Router + Tailwind CSS.
- **Backend API**: Running at `http://localhost:5000/` using ExpressJS + NodeJS + MySQL pool.
- **Log file**: Cheating records are saved to `backend/cheating_activity.log`.
- **Database**: Loaded and tested on `online_exam` database using local XAMPP MySQL.

---

## 📊 Seeded Students & Excel sheet

We created a Node.js database seeding script `backend/src/seedStudents.js` and loaded **100 students** directly into the `students` table in the database.
An Excel-compatible CSV file containing their login IDs and passwords has been generated in the backend directory:
- **File path**: [student_logins.csv](file:///e:/xampp/htdocs/Online%20exam/backend/student_logins.csv)

### Student Login Credentials Format
- **Student ID**: Range from `STU2001` to `STU2100` (e.g. `STU2001`, `STU2002`).
- **Plain Text Password**: Pattern of `pass` + ID number (e.g. `pass2001`, `pass2002`).
- **Status**: Approved and active immediately.

---

## 🔑 Primary Logins

The database has been seeded with initial credentials. You can log in using:

### 1. Admin Login
- **Email**: `admin@exam.com`
- **Password**: `admin123`

### 2. Teacher Login
- **Email**: `teacher@exam.com`
- **Password**: `teacher123`

### 3. Student Login (Manual Mock)
- **Student ID**: `STU1001`
- **Password**: `student123`
