const db = require('../config/db');
const bcrypt = require('bcryptjs');

// Get Profile
exports.getProfile = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, name, email, profile_image, status FROM students WHERE id = ?',
      [req.user.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }
    return res.json(rows[0]);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching student profile' });
  }
};

// Change Password Only
exports.changePassword = async (req, res) => {
  const { oldPassword, newPassword } = req.body;
  if (!oldPassword || !newPassword) {
    return res.status(400).json({ message: 'Old and new passwords are required' });
  }
  try {
    const [rows] = await db.query('SELECT password FROM students WHERE id = ?', [req.user.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }

    const student = rows[0];
    const isMatch = await bcrypt.compare(oldPassword, student.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Incorrect old password' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await db.query('UPDATE students SET password = ? WHERE id = ?', [hashedPassword, req.user.id]);

    return res.json({ message: 'Password updated successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating password' });
  }
};

// Get Enrolled Courses
exports.getCourses = async (req, res) => {
  try {
    const query = `
      SELECT c.*, ce.status AS enrollment_status
      FROM courses c
      JOIN course_enrollments ce ON c.id = ce.course_id
      WHERE ce.student_id = ? AND ce.status = 'approved'
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching enrolled courses' });
  }
};

// Get All Courses with enrollment status for student
exports.getAvailableCourses = async (req, res) => {
  try {
    const query = `
      SELECT c.*, 
             ce.status AS enrollment_status,
             t.name AS teacher_name
      FROM courses c
      LEFT JOIN course_enrollments ce ON c.id = ce.course_id AND ce.student_id = ?
      LEFT JOIN course_assignments ca ON c.id = ca.course_id
      LEFT JOIN teachers t ON ca.teacher_id = t.id
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching available courses' });
  }
};

// Request Course Enrollment (Status = 'pending')
exports.requestEnrollment = async (req, res) => {
  const { courseId } = req.body;
  if (!courseId) {
    return res.status(400).json({ message: 'Course ID is required' });
  }
  try {
    // Check if course exists
    const [course] = await db.query('SELECT id FROM courses WHERE id = ?', [courseId]);
    if (course.length === 0) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // Check if already enrolled or requested
    const [existing] = await db.query(
      'SELECT status FROM course_enrollments WHERE course_id = ? AND student_id = ?',
      [courseId, req.user.id]
    );

    if (existing.length > 0) {
      return res.status(400).json({ message: `Enrollment status is already: ${existing[0].status}` });
    }

    await db.query(
      "INSERT INTO course_enrollments (course_id, student_id, status) VALUES (?, ?, 'pending')",
      [courseId, req.user.id]
    );

    return res.status(201).json({ message: 'Enrollment request sent successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error requesting enrollment' });
  }
};

// --- EXAM ATTENDANCE ---

// Get list of exams available for enrolled courses
exports.getExams = async (req, res) => {
  try {
    const query = `
      SELECT e.*, c.name AS course_name, c.code AS course_code,
             se.score, se.started_at, se.finished_at, se.status AS exam_status,
             se.demerit_points, se.block_until
      FROM exams e
      JOIN courses c ON e.course_id = c.id
      JOIN course_enrollments ce ON c.id = ce.course_id
      LEFT JOIN student_exams se ON e.id = se.exam_id AND se.student_id = ?
      WHERE ce.student_id = ? AND ce.status = 'approved'
    `;
    const [rows] = await db.query(query, [req.user.id, req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching exams' });
  }
};

// Start an exam (Creates entry in student_exams or returns existing)
exports.startExam = async (req, res) => {
  const { examId } = req.params;
  try {
    // Verify student is enrolled in the course for this exam
    const queryCheck = `
      SELECT e.id FROM exams e
      JOIN course_enrollments ce ON e.course_id = ce.course_id
      WHERE e.id = ? AND ce.student_id = ? AND ce.status = 'approved'
    `;
    const [enrollCheck] = await db.query(queryCheck, [examId, req.user.id]);
    if (enrollCheck.length === 0) {
      return res.status(403).json({ message: 'You are not enrolled in this course to take this exam' });
    }

    // Check if exam is already started/completed
    const [existing] = await db.query(
      'SELECT * FROM student_exams WHERE student_id = ? AND exam_id = ?',
      [req.user.id, examId]
    );

    if (existing.length > 0) {
      if (existing[0].status === 'completed') {
        return res.status(400).json({ message: 'You have already completed this exam' });
      }
      return res.json(existing[0]); // Return active session
    }

    // Create new exam attempt
    const newAttempt = {
      student_id: req.user.id,
      exam_id: examId,
      started_at: new Date(),
      status: 'started',
      demerit_points: 0
    };

    await db.query(
      'INSERT INTO student_exams (student_id, exam_id, started_at, status, demerit_points) VALUES (?, ?, ?, ?, ?)',
      [newAttempt.student_id, newAttempt.exam_id, newAttempt.started_at, newAttempt.status, newAttempt.demerit_points]
    );

    return res.status(201).json(newAttempt);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error starting exam' });
  }
};

// Get active exam questions (only if exam started and not completed/blocked)
exports.getExamQuestions = async (req, res) => {
  const { examId } = req.params;
  try {
    const [attempt] = await db.query(
      'SELECT status, block_until FROM student_exams WHERE student_id = ? AND exam_id = ?',
      [req.user.id, examId]
    );

    if (attempt.length === 0) {
      return res.status(400).json({ message: 'Exam session has not been started' });
    }

    if (attempt[0].status === 'completed') {
      return res.status(400).json({ message: 'You have already completed this exam' });
    }

    // Check if currently blocked
    if (attempt[0].block_until && new Date(attempt[0].block_until) > new Date()) {
      return res.status(403).json({
        message: 'Exam is currently locked due to proctoring block',
        block_until: attempt[0].block_until
      });
    }

    // Return questions (without correct option for security!)
    const [questions] = await db.query(
      'SELECT id, question_text, option_a, option_b, option_c, option_d FROM exam_questions WHERE exam_id = ?',
      [examId]
    );

    return res.json(questions);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error retrieving questions' });
  }
};

// Submit exam answers and calculate score
exports.submitExam = async (req, res) => {
  const { examId } = req.params;
  const { answers } = req.body; // Map: { questionId: chosenOption } e.g. { 1: 'B', 2: 'C' }

  try {
    const [attempt] = await db.query(
      'SELECT status FROM student_exams WHERE student_id = ? AND exam_id = ?',
      [req.user.id, examId]
    );

    if (attempt.length === 0) {
      return res.status(400).json({ message: 'No active exam session' });
    }

    if (attempt[0].status === 'completed') {
      return res.status(400).json({ message: 'Exam already submitted' });
    }

    // Get correct answers
    const [questions] = await db.query(
      'SELECT id, correct_option FROM exam_questions WHERE exam_id = ?',
      [examId]
    );

    let score = 0;
    questions.forEach(q => {
      const studentAnswer = answers[q.id];
      if (studentAnswer && studentAnswer.toUpperCase() === q.correct_option.toUpperCase()) {
        score++;
      }
    });

    // Update status to completed
    await db.query(
      "UPDATE student_exams SET score = ?, finished_at = NOW(), status = 'completed' WHERE student_id = ? AND exam_id = ?",
      [score, req.user.id, examId]
    );

    return res.json({ message: 'Exam submitted successfully', score, total: questions.length });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error submitting exam' });
  }
};
