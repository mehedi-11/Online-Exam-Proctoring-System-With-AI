const db = require('../config/db');

// Get Profile
exports.getProfile = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, name, email, profile_image, joining_date, status FROM teachers WHERE id = ?',
      [req.user.id]
    );
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Teacher not found' });
    }
    return res.json(rows[0]);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching profile' });
  }
};

// Update Profile
exports.updateProfile = async (req, res) => {
  const { name, joining_date } = req.body;
  const profile_image = req.file ? `/uploads/${req.file.filename}` : null;

  try {
    if (!name) {
      return res.status(400).json({ message: 'Name is required' });
    }

    let query = 'UPDATE teachers SET name = ?';
    let params = [name];

    if (joining_date) {
      query += ', joining_date = ?';
      params.push(joining_date);
    }

    if (profile_image) {
      query += ', profile_image = ?';
      params.push(profile_image);
    }

    query += ' WHERE id = ?';
    params.push(req.user.id);

    await db.query(query, params);

    // Fetch updated profile
    const [rows] = await db.query(
      'SELECT id, name, email, profile_image, joining_date, status FROM teachers WHERE id = ?',
      [req.user.id]
    );

    return res.json({ message: 'Profile updated successfully', user: rows[0] });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating profile' });
  }
};

// Get Courses assigned to Teacher
exports.getCourses = async (req, res) => {
  try {
    const query = `
      SELECT c.*, 
             (SELECT COUNT(*) FROM course_enrollments ce WHERE ce.course_id = c.id AND ce.status = 'approved') AS enrolled_students_count
      FROM courses c
      JOIN course_assignments ca ON c.id = ca.course_id
      WHERE ca.teacher_id = ?
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching teacher courses' });
  }
};

// Enroll student directly in one of the teacher's courses
exports.enrollStudent = async (req, res) => {
  const { courseId, studentId } = req.body;
  try {
    // Verify teacher teaches this course
    const [check] = await db.query(
      'SELECT course_id FROM course_assignments WHERE course_id = ? AND teacher_id = ?',
      [courseId, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You are not assigned to this course' });
    }

    // Check if student exists
    const [student] = await db.query('SELECT id FROM students WHERE id = ?', [studentId]);
    if (student.length === 0) {
      return res.status(404).json({ message: 'Student not found' });
    }

    // Insert or update enrollment
    const [existing] = await db.query(
      'SELECT status FROM course_enrollments WHERE course_id = ? AND student_id = ?',
      [courseId, studentId]
    );

    if (existing.length > 0) {
      await db.query(
        "UPDATE course_enrollments SET status = 'approved' WHERE course_id = ? AND student_id = ?",
        [courseId, studentId]
      );
    } else {
      await db.query(
        "INSERT INTO course_enrollments (course_id, student_id, status) VALUES (?, ?, 'approved')",
        [courseId, studentId]
      );
    }

    return res.json({ message: 'Student enrolled successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error enrolling student' });
  }
};

// Get Pending Enrollment Requests for teacher's courses
exports.getPendingEnrollments = async (req, res) => {
  try {
    const query = `
      SELECT ce.course_id, ce.student_id, ce.status,
             c.name AS course_name, c.code AS course_code,
             s.name AS student_name, s.email AS student_email
      FROM course_enrollments ce
      JOIN courses c ON ce.course_id = c.id
      JOIN course_assignments ca ON c.id = ca.course_id
      JOIN students s ON ce.student_id = s.id
      WHERE ca.teacher_id = ? AND ce.status = 'pending'
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching pending enrollments' });
  }
};

// Approve student enrollment request
exports.approveEnrollment = async (req, res) => {
  const { courseId, studentId } = req.body;
  try {
    // Verify teacher teaches this course
    const [check] = await db.query(
      'SELECT course_id FROM course_assignments WHERE course_id = ? AND teacher_id = ?',
      [courseId, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You are not assigned to this course' });
    }

    await db.query(
      "UPDATE course_enrollments SET status = 'approved' WHERE course_id = ? AND student_id = ?",
      [courseId, studentId]
    );

    return res.json({ message: 'Enrollment request approved successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error approving enrollment' });
  }
};

// --- EXAM MANAGEMENT ---

// Get Exams created under teacher's courses
exports.getExams = async (req, res) => {
  try {
    const query = `
      SELECT e.*, c.name AS course_name, c.code AS course_code,
             (SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.id) AS questions_count
      FROM exams e
      JOIN courses c ON e.course_id = c.id
      JOIN course_assignments ca ON c.id = ca.course_id
      WHERE ca.teacher_id = ?
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching exams' });
  }
};

// Create Exam
exports.createExam = async (req, res) => {
  const { course_id, title, exam_date, duration_minutes } = req.body;
  if (!course_id || !title || !exam_date || !duration_minutes) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    // Verify teacher teaches this course
    const [check] = await db.query(
      'SELECT course_id FROM course_assignments WHERE course_id = ? AND teacher_id = ?',
      [course_id, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You are not assigned to this course' });
    }

    const [result] = await db.query(
      'INSERT INTO exams (course_id, title, exam_date, duration_minutes) VALUES (?, ?, ?, ?)',
      [course_id, title, exam_date, duration_minutes]
    );

    return res.status(201).json({ message: 'Exam created successfully', examId: result.insertId });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error creating exam' });
  }
};

// Delete Exam
exports.deleteExam = async (req, res) => {
  const { id } = req.params;
  try {
    // Verify teacher owns the course of this exam
    const [check] = await db.query(
      `SELECT e.id FROM exams e
       JOIN course_assignments ca ON e.course_id = ca.course_id
       WHERE e.id = ? AND ca.teacher_id = ?`,
      [id, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You do not have permission to delete this exam' });
    }

    await db.query('DELETE FROM exams WHERE id = ?', [id]);
    return res.json({ message: 'Exam deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting exam' });
  }
};

// --- QUESTION MANAGEMENT ---

// Get Questions for an exam
exports.getQuestions = async (req, res) => {
  const { examId } = req.params;
  try {
    // Verify teacher teaches the course for this exam
    const [check] = await db.query(
      `SELECT e.id FROM exams e
       JOIN course_assignments ca ON e.course_id = ca.course_id
       WHERE e.id = ? AND ca.teacher_id = ?`,
      [examId, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You do not have permission to view these questions' });
    }

    const [rows] = await db.query('SELECT * FROM exam_questions WHERE exam_id = ?', [examId]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching questions' });
  }
};

// Create/Add Question to Exam
exports.createQuestion = async (req, res) => {
  const { exam_id, question_text, option_a, option_b, option_c, option_d, correct_option } = req.body;
  if (!exam_id || !question_text || !option_a || !option_b || !option_c || !option_d || !correct_option) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    // Verify teacher teaches the course for this exam
    const [check] = await db.query(
      `SELECT e.id FROM exams e
       JOIN course_assignments ca ON e.course_id = ca.course_id
       WHERE e.id = ? AND ca.teacher_id = ?`,
      [exam_id, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You do not have permission to add questions to this exam' });
    }

    await db.query(
      `INSERT INTO exam_questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [exam_id, question_text, option_a, option_b, option_c, option_d, correct_option]
    );

    return res.status(201).json({ message: 'Question added successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error adding question' });
  }
};

// Delete Question
exports.deleteQuestion = async (req, res) => {
  const { id } = req.params;
  try {
    // Verify teacher owns the exam for this question
    const [check] = await db.query(
      `SELECT q.id FROM exam_questions q
       JOIN exams e ON q.exam_id = e.id
       JOIN course_assignments ca ON e.course_id = ca.course_id
       WHERE q.id = ? AND ca.teacher_id = ?`,
      [id, req.user.id]
    );
    if (check.length === 0) {
      return res.status(403).json({ message: 'You do not have permission to delete this question' });
    }

    await db.query('DELETE FROM exam_questions WHERE id = ?', [id]);
    return res.json({ message: 'Question deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting question' });
  }
};

// --- PROCTORING LOGS ---

// Get Proctoring Logs for courses taught by teacher
exports.getProctoringLogs = async (req, res) => {
  try {
    const query = `
      SELECT pl.*, 
             s.name AS student_name, s.email AS student_email,
             e.title AS exam_title,
             c.name AS course_name
      FROM proctoring_logs pl
      JOIN students s ON pl.student_id = s.id
      JOIN exams e ON pl.exam_id = e.id
      JOIN courses c ON e.course_id = c.id
      JOIN course_assignments ca ON c.id = ca.course_id
      WHERE ca.teacher_id = ?
      ORDER BY pl.timestamp DESC
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching proctoring logs' });
  }
};
