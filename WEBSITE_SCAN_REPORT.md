# Website Scan Report

Project: Online Exam Proctoring System With AI  
Scan date: 2026-06-26  
Workspace: `E:\xampp\htdocs\Online-Exam-Proctoring-System-With-AI`

## Executive Summary

This project is a full-stack online exam and proctoring website with a React/Vite frontend, Express.js backend, MySQL database, JWT authentication, role-based dashboards, live exam flow, answer submission, manual/AI grading, and proctoring incident logs.

Overall status: functional foundation is good, and the frontend production build succeeds. However, there are several high-priority security and authorization issues that should be fixed before using this system in a real exam environment.

## Technology Stack

| Layer | Technology |
| --- | --- |
| Frontend | React 18, Vite, Tailwind CSS, React Router, Axios, Lucide icons |
| Backend | Node.js, Express.js, CommonJS |
| Database | MySQL via `mysql2/promise` |
| Auth | JWT, bcryptjs |
| Uploads | Multer local file uploads |
| AI grading | Gemini API through teacher-provided API key |
| Proctoring | Browser event detection, webcam preview, simulated YOLOv8 alert buttons, database/file logging |

## Main Features Found

- Public landing, login, and registration pages.
- Role-based dashboards for Admin, Teacher, and Student.
- Admin can manage admins, teachers, and students.
- Teacher can manage profile, exams, questions, live exam password, results, grading, and proctor logs.
- Student can view exams, start live exams, answer MCQ/written questions, auto-save, and submit.
- Exam page has webcam preview, copy/paste/focus-change detection, demerit points, and temporary blocking.
- Proctoring incidents are saved in `proctoring_logs` and appended to `backend/cheating_activity.log`.
- Database schema includes admins, teachers, students, exams, questions, exam attempts, answers, and proctoring logs.

## Verification Results

| Check | Result | Notes |
| --- | --- | --- |
| Frontend production build | Passed | `npm run build` completed successfully after running outside sandbox due to Windows `EPERM` spawn restriction. |
| Frontend lint | Failed | `npm run lint` fails because `eslint` command is not available locally, although `eslint.config.js` exists. Add `eslint` as a dev dependency or update the script. |
| Backend tests | Not available | Backend package has only `start` and `dev` scripts. |
| Git working tree before report | Clean | No existing tracked changes were present before this report was added. |

## High Priority Findings

### 1. Public password reset can change passwords without OTP/token

Affected files:

- `backend/src/routes/authRoutes.js:15`
- `backend/src/routes/authRoutes.js:16`
- `backend/src/controllers/authController.js:274`
- `backend/src/controllers/authController.js:298`
- `backend/src/controllers/authController.js:308`
- `backend/src/controllers/authController.js:310`
- `backend/src/controllers/authController.js:312`

The reset flow exposes `/api/auth/verify-identifier` and `/api/auth/reset-password` publicly. `resetPassword` directly updates student, teacher, or admin passwords using only role, identifier, and new password. There is no OTP, signed reset token, email verification, expiration, or session proof.

Risk: anyone who knows an admin/teacher email or student ID can reset that account's password.

Recommended fix:

- Generate a one-time password reset token or OTP.
- Store a hashed token with expiry in the database.
- Send reset confirmation via verified email.
- Require the token/OTP when calling `reset-password`.
- Rate-limit reset attempts.

### 2. Proctor incident endpoint trusts client-supplied `studentId`

Affected files:

- `backend/src/routes/proctorRoutes.js:7`
- `backend/src/controllers/proctorController.js:9`
- `backend/src/controllers/proctorController.js:42`
- `backend/src/controllers/proctorController.js:81`

The endpoint requires a valid token, but it accepts `studentId` from the request body. A logged-in student can potentially submit proctoring incidents for another student ID and affect another student's demerit score/block status.

Risk: student impersonation in proctor logs and unfair exam blocking.

Recommended fix:

- Use `req.user.id` as the student ID for student-submitted incidents.
- Validate that `req.user.role === 'student'` for student-side logging.
- For admin/teacher/system events, create separate protected endpoints with explicit authorization.

### 3. Teacher question creation/update has incomplete ownership checks

Affected files:

- `backend/src/controllers/teacherController.js:202`
- `backend/src/controllers/teacherController.js:223`

`createQuestion` accepts `exam_id` from the body and inserts a question without first verifying that the exam belongs to the logged-in teacher. `updateQuestion` updates by question ID without checking ownership through the parent exam.

Risk: a teacher may create or edit questions for another teacher's exam if they know IDs.

Recommended fix:

- Before creating a question, check `SELECT id FROM exams WHERE id = ? AND teacher_id = ?`.
- Before updating a question, join `exam_questions` to `exams` and verify `teacher_id = req.user.id`.

### 4. Teacher result/grading endpoints miss ownership validation

Affected files:

- `backend/src/controllers/teacherController.js:266`
- `backend/src/controllers/teacherController.js:284`
- `backend/src/controllers/teacherController.js:304`

Exam results, student answer sheets, and manual grading are accessible by exam/student IDs without confirming that the exam belongs to the logged-in teacher.

Risk: one teacher may view or grade another teacher's exam data.

Recommended fix:

- Add ownership checks for every teacher route that accepts `examId`, `id`, `studentId`, or `answer_id`.
- In grading, verify each `answer_id` belongs to the specified exam and the exam belongs to `req.user.id`.

## Medium Priority Findings

### 5. Proctor log CSV download uses a table name that does not exist

Affected files:

- `backend/src/controllers/teacherController.js:470`
- `backend/src/controllers/teacherController.js:475`
- `database.sql:95`

The database schema defines `proctoring_logs`, but `downloadExamLogs` queries `proctor_logs`. This will fail at runtime.

Recommended fix:

- Change the query to use `proctoring_logs`.
- Update selected columns to match schema fields: `activity_type`, `details`, `demerit_points`, `timestamp`.

### 6. JWT secret is not guarded at startup

Affected file:

- `backend/src/middleware/authMiddleware.js:16`

JWT verification/signing uses `process.env.JWT_SECRET`, but the app does not fail fast if the secret is missing.

Risk: confusing runtime failures or insecure local defaults if later added casually.

Recommended fix:

- Validate required environment variables on backend startup.
- Stop the server with a clear error if `JWT_SECRET` or DB settings are missing in production.

### 7. Teacher API keys are stored and returned in profile responses

Affected files:

- `backend/src/controllers/teacherController.js:9`
- `backend/src/controllers/teacherController.js:21`
- `backend/src/controllers/teacherController.js:46`
- `backend/src/controllers/teacherController.js:345`

Teacher `llm_api_key` is stored in the database and returned by profile endpoints. This may expose sensitive API keys to browser storage, network logs, or screenshots.

Recommended fix:

- Encrypt API keys at rest.
- Avoid returning the full key to the frontend; return only masked metadata like `has_llm_api_key: true`.
- Consider storing provider config server-side only.

### 8. File upload has no size limit

Affected file:

- `backend/src/routes/teacherRoutes.js`

Multer filters image extensions/MIME types, but no `limits.fileSize` is configured.

Risk: large uploads can consume disk/memory and affect server availability.

Recommended fix:

- Add a reasonable file size limit, for example 2 MB.
- Optionally normalize/resize uploaded profile images.

## Low Priority / Maintainability Notes

- Backend has no test script or automated API tests.
- Frontend lint script exists, but `eslint` is not installed in `frontend/package.json`.
- Some frontend exam proctoring logic is client-side only and can be bypassed by a determined user. Treat it as a warning signal, not hard security.
- `navigator.sendBeacon` sends JSON without setting authorization headers, so exam auto-save on unload may not authenticate successfully.
- Several database writes that affect multiple rows would be safer inside transactions, especially grading and submission.
- Some admin delete/status update endpoints do not check affected rows before returning success.

## Recommended Next Steps

1. Fix public password reset immediately.
2. Change proctor incident logging to use authenticated user identity.
3. Add ownership validation to all teacher exam/question/result/grading endpoints.
4. Fix `proctor_logs` vs `proctoring_logs` table mismatch.
5. Add backend environment validation for `JWT_SECRET` and DB configuration.
6. Add upload size limits and mask/encrypt teacher LLM API keys.
7. Add basic automated tests for auth, role authorization, exam ownership, and submission flow.
8. Add/install ESLint properly and keep frontend build/lint in CI or a local verification script.

## Overall Assessment

The project is a strong academic/demo implementation with a complete user flow and working frontend build. Before production use, the main work should focus on authentication recovery, authorization boundaries, and data ownership checks. Once those are fixed, the system will be much safer for real teacher/student exam scenarios.
