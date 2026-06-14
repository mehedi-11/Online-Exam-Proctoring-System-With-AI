const db = require('../config/db');
const bcrypt = require('bcryptjs');

// Get Admin Profile
exports.getProfile = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, email FROM admins WHERE id = ?', [req.user.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Admin not found' });
    }
    return res.json(rows[0]);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching profile' });
  }
};

// Update Admin Profile
exports.updateProfile = async (req, res) => {
  const { name, email, password } = req.body;
  try {
    if (!name || !email) {
      return res.status(400).json({ message: 'Name and email are required' });
    }

    // Check if email already used by other admins
    const [emailCheck] = await db.query('SELECT id FROM admins WHERE email = ? AND id != ?', [email, req.user.id]);
    if (emailCheck.length > 0) {
      return res.status(400).json({ message: 'Email already in use' });
    }

    if (password && password.trim() !== '') {
      const hashedPassword = await bcrypt.hash(password, 10);
      await db.query(
        'UPDATE admins SET name = ?, email = ?, password = ? WHERE id = ?',
        [name, email, hashedPassword, req.user.id]
      );
    } else {
      await db.query(
        'UPDATE admins SET name = ?, email = ? WHERE id = ?',
        [name, email, req.user.id]
      );
    }

    return res.json({ message: 'Profile updated successfully', name, email });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating profile' });
  }
};

// --- TEACHER MANAGEMENT ---

// Get all teachers
exports.getTeachers = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, email, profile_image, joining_date, status FROM teachers');
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching teachers' });
  }
};

// Add Teacher (Approved directly)
exports.addTeacher = async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    const [existing] = await db.query('SELECT id FROM teachers WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO teachers (name, email, password, status, joining_date) VALUES (?, ?, ?, ?, CURRENT_DATE)',
      [name, email, hashedPassword, 'approved']
    );

    return res.status(201).json({ message: 'Teacher added successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error adding teacher' });
  }
};

// Update Teacher Status (approve, suspend)
exports.updateTeacherStatus = async (req, res) => {
  const { id } = req.params;
  const { status } = req.body; // 'approved', 'suspended', 'pending'
  if (!['approved', 'suspended', 'pending'].includes(status)) {
    return res.status(400).json({ message: 'Invalid status' });
  }
  try {
    await db.query('UPDATE teachers SET status = ? WHERE id = ?', [status, id]);
    return res.json({ message: `Teacher status updated to ${status}` });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating teacher status' });
  }
};

// Delete Teacher
exports.deleteTeacher = async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM teachers WHERE id = ?', [id]);
    return res.json({ message: 'Teacher deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting teacher' });
  }
};

// --- STUDENT MANAGEMENT ---

// Get all students
exports.getStudents = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, email, profile_image, status FROM students');
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching students' });
  }
};

// Add Student (Approved directly)
exports.addStudent = async (req, res) => {
  const { id, name, email, password } = req.body; // id is studentID
  if (!id || !name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    const [existingId] = await db.query('SELECT id FROM students WHERE id = ?', [id]);
    if (existingId.length > 0) {
      return res.status(400).json({ message: 'Student ID already exists' });
    }

    const [existingEmail] = await db.query('SELECT id FROM students WHERE email = ?', [email]);
    if (existingEmail.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO students (id, name, email, password, status) VALUES (?, ?, ?, ?, ?)',
      [id, name, email, hashedPassword, 'approved']
    );

    return res.status(201).json({ message: 'Student added successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error adding student' });
  }
};

// Update Student Status
exports.updateStudentStatus = async (req, res) => {
  const { id } = req.params; // studentID
  const { status } = req.body;
  if (!['approved', 'suspended', 'pending'].includes(status)) {
    return res.status(400).json({ message: 'Invalid status' });
  }
  try {
    await db.query('UPDATE students SET status = ? WHERE id = ?', [status, id]);
    return res.json({ message: `Student status updated to ${status}` });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating student status' });
  }
};

// Delete Student
exports.deleteStudent = async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM students WHERE id = ?', [id]);
    return res.json({ message: 'Student deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting student' });
  }
};

// --- COURSE MANAGEMENT ---

// Get all courses
exports.getCourses = async (req, res) => {
  try {
    const query = `
      SELECT c.*, 
        t.name AS teacher_name, 
        t.id AS teacher_id,
        (SELECT COUNT(*) FROM course_enrollments ce WHERE ce.course_id = c.id AND ce.status = 'approved') AS enrolled_students_count
      FROM courses c
      LEFT JOIN course_assignments ca ON c.id = ca.course_id
      LEFT JOIN teachers t ON ca.teacher_id = t.id
    `;
    const [rows] = await db.query(query);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching courses' });
  }
};

// Create Course
exports.createCourse = async (req, res) => {
  const { name, code, description } = req.body;
  if (!name || !code) {
    return res.status(400).json({ message: 'Course name and code are required' });
  }
  try {
    const [existing] = await db.query('SELECT id FROM courses WHERE code = ?', [code]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Course code already exists' });
    }

    await db.query(
      'INSERT INTO courses (name, code, description) VALUES (?, ?, ?)',
      [name, code, description || '']
    );
    return res.status(201).json({ message: 'Course created successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error creating course' });
  }
};

// Update Course
exports.updateCourse = async (req, res) => {
  const { id } = req.params;
  const { name, code, description } = req.body;
  if (!name || !code) {
    return res.status(400).json({ message: 'Course name and code are required' });
  }
  try {
    const [existing] = await db.query('SELECT id FROM courses WHERE code = ? AND id != ?', [code, id]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Course code already exists' });
    }

    await db.query(
      'UPDATE courses SET name = ?, code = ?, description = ? WHERE id = ?',
      [name, code, description || '', id]
    );
    return res.json({ message: 'Course updated successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating course' });
  }
};

// Delete Course
exports.deleteCourse = async (req, res) => {
  const { id } = req.params;
  try {
    await db.query('DELETE FROM courses WHERE id = ?', [id]);
    return res.json({ message: 'Course deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting course' });
  }
};

// Assign Teacher to Course
exports.assignTeacher = async (req, res) => {
  const { courseId, teacherId } = req.body;
  if (!courseId || !teacherId) {
    return res.status(400).json({ message: 'Course ID and Teacher ID are required' });
  }
  try {
    // Check if course exists
    const [course] = await db.query('SELECT id FROM courses WHERE id = ?', [courseId]);
    if (course.length === 0) {
      return res.status(404).json({ message: 'Course not found' });
    }

    // Check if teacher exists
    const [teacher] = await db.query('SELECT id FROM teachers WHERE id = ?', [teacherId]);
    if (teacher.length === 0) {
      return res.status(404).json({ message: 'Teacher not found' });
    }

    // Remove any existing assignment first (since a course typically has 1 main teacher in this requirement)
    await db.query('DELETE FROM course_assignments WHERE course_id = ?', [courseId]);

    // Insert new assignment
    await db.query('INSERT INTO course_assignments (course_id, teacher_id) VALUES (?, ?)', [courseId, teacherId]);

    return res.json({ message: 'Teacher assigned to course successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error assigning teacher' });
  }
};

// Enroll Student in Course (Direct Approval - supports single or multiple students)
exports.enrollStudent = async (req, res) => {
  const { courseId, studentId, studentIds } = req.body;

  if (!courseId) {
    return res.status(400).json({ message: 'Course ID is required' });
  }

  // Support studentId as single string or array, or studentIds as array
  let ids = [];
  if (Array.isArray(studentIds) && studentIds.length > 0) {
    ids = studentIds;
  } else if (Array.isArray(studentId) && studentId.length > 0) {
    ids = studentId;
  } else if (studentId && typeof studentId === 'string') {
    ids = [studentId];
  }

  if (ids.length === 0) {
    return res.status(400).json({ message: 'Please select at least one student to enroll' });
  }

  try {
    let enrolledCount = 0;
    for (const sId of ids) {
      // Check if enrollment already exists
      const [existing] = await db.query(
        'SELECT status FROM course_enrollments WHERE course_id = ? AND student_id = ?',
        [courseId, sId]
      );

      if (existing.length > 0) {
        if (existing[0].status !== 'approved') {
          // Approve existing pending request
          await db.query(
            "UPDATE course_enrollments SET status = 'approved' WHERE course_id = ? AND student_id = ?",
            [courseId, sId]
          );
          enrolledCount++;
        }
        // If already approved, skip silently
      } else {
        await db.query(
          "INSERT INTO course_enrollments (course_id, student_id, status) VALUES (?, ?, 'approved')",
          [courseId, sId]
        );
        enrolledCount++;
      }
    }

    return res.json({ message: `Successfully enrolled/updated ${enrolledCount} student(s) out of ${ids.length} selected` });
  } catch (error) {
    console.error('Error enrolling students:', error);
    return res.status(500).json({ message: 'Server error enrolling students' });
  }
};

// Approve Course Enrollment Request (Pending -> Approved)
exports.approveEnrollment = async (req, res) => {
  const { courseId, studentId } = req.body;
  if (!courseId || !studentId) {
    return res.status(400).json({ message: 'Course ID and Student ID are required' });
  }
  try {
    const [rows] = await db.query(
      'SELECT * FROM course_enrollments WHERE course_id = ? AND student_id = ?',
      [courseId, studentId]
    );
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Enrollment request not found' });
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

// Get Pending Enrollment Requests
exports.getPendingEnrollments = async (req, res) => {
  try {
    const query = `
      SELECT ce.course_id, ce.student_id, ce.status,
             c.name AS course_name, c.code AS course_code,
             s.name AS student_name, s.email AS student_email
      FROM course_enrollments ce
      JOIN courses c ON ce.course_id = c.id
      JOIN students s ON ce.student_id = s.id
      WHERE ce.status = 'pending'
    `;
    const [rows] = await db.query(query);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching pending enrollments' });
  }
};
