const db = require('../config/db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// Register Teacher
exports.registerTeacher = async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Check if email already exists in teachers, students, or admins
    const [existingTeacher] = await db.query('SELECT id FROM teachers WHERE email = ?', [email]);
    if (existingTeacher.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO teachers (name, email, password, status) VALUES (?, ?, ?, ?)',
      [name, email, hashedPassword, 'pending']
    );

    return res.status(201).json({ message: 'Teacher registration request submitted. Awaiting Admin approval.' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error during teacher registration' });
  }
};

// Register Student
exports.registerStudent = async (req, res) => {
  const { id, name, email, password } = req.body; // id is Student ID
  if (!id || !name || !email || !password) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Check if student id or email already exists
    const [existingStudentId] = await db.query('SELECT id FROM students WHERE id = ?', [id]);
    if (existingStudentId.length > 0) {
      return res.status(400).json({ message: 'Student ID already exists' });
    }

    const [existingStudentEmail] = await db.query('SELECT id FROM students WHERE email = ?', [email]);
    if (existingStudentEmail.length > 0) {
      return res.status(400).json({ message: 'Email already registered' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await db.query(
      'INSERT INTO students (id, name, email, password, status) VALUES (?, ?, ?, ?, ?)',
      [id, name, email, hashedPassword, 'approved']
    );

    return res.status(201).json({ message: 'Student registration successful. You can now login.' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error during student registration' });
  }
};

// Admin Login (Email + Password)
exports.adminLogin = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  try {
    const [rows] = await db.query('SELECT * FROM admins WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const admin = rows[0];
    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: admin.id, email: admin.email, name: admin.name, role: 'admin' },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.json({
      token,
      user: { id: admin.id, email: admin.email, name: admin.name, role: 'admin' }
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error during admin login' });
  }
};

// Teacher Login (Email + Password)
exports.teacherLogin = async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    return res.status(400).json({ message: 'Email and password are required' });
  }

  try {
    const [rows] = await db.query('SELECT * FROM teachers WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const teacher = rows[0];

    // Status checks
    if (teacher.status === 'pending') {
      return res.status(403).json({ message: 'Your account is pending admin approval' });
    }
    if (teacher.status === 'suspended') {
      return res.status(403).json({ message: 'Your account has been suspended. Contact support.' });
    }

    const isMatch = await bcrypt.compare(password, teacher.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: teacher.id, email: teacher.email, name: teacher.name, role: 'teacher' },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.json({
      token,
      user: {
        id: teacher.id,
        email: teacher.email,
        name: teacher.name,
        role: 'teacher',
        profile_image: teacher.profile_image,
        joining_date: teacher.joining_date
      }
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error during teacher login' });
  }
};

// Student Login (StudentID + Password)
exports.studentLogin = async (req, res) => {
  const { studentId, password } = req.body;
  if (!studentId || !password) {
    return res.status(400).json({ message: 'StudentID and password are required' });
  }

  try {
    const [rows] = await db.query('SELECT * FROM students WHERE id = ?', [studentId]);
    if (rows.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const student = rows[0];

    // Status checks
    if (student.status === 'pending') {
      return res.status(403).json({ message: 'Your account is pending admin approval' });
    }
    if (student.status === 'suspended') {
      return res.status(403).json({ message: 'Your account has been suspended. Contact support.' });
    }

    const isMatch = await bcrypt.compare(password, student.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { id: student.id, email: student.email, name: student.name, role: 'student' },
      process.env.JWT_SECRET,
      { expiresIn: '24h' }
    );

    return res.json({
      token,
      user: {
        id: student.id,
        email: student.email,
        name: student.name,
        role: 'student',
        profile_image: student.profile_image
      }
    });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error during student login' });
  }
};
