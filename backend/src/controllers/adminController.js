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

// --- ADMIN MANAGEMENT ---

exports.getAdmins = async (req, res) => {
  try {
    const [rows] = await db.query('SELECT id, name, email FROM admins');
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching admins' });
  }
};

exports.addAdmin = async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  try {
    const [existing] = await db.query('SELECT id FROM admins WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO admins (name, email, password) VALUES (?, ?, ?)',
      [name, email, hashedPassword]
    );
    return res.status(201).json({ message: 'Admin added successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error adding admin' });
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

// --- DASHBOARD STATS ---
exports.getDashboardStats = async (req, res) => {
  try {
    const [[{ totalTeachers }]] = await db.query("SELECT COUNT(*) AS totalTeachers FROM teachers");
    const [[{ totalStudents }]] = await db.query("SELECT COUNT(*) AS totalStudents FROM students");
    const [[{ totalLiveExams }]] = await db.query("SELECT COUNT(*) AS totalLiveExams FROM exams");
    
    return res.json({
      totalTeachers,
      totalStudents,
      totalLiveExams
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching dashboard stats' });
  }
};
