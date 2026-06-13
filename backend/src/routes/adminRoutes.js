const express = require('express');
const router = express.Router();
const adminController = require('../controllers/adminController');
const { verifyToken, authorizeRoles } = require('../middleware/authMiddleware');

// Protect all routes here with Admin check
router.use(verifyToken, authorizeRoles('admin'));

// Profile
router.get('/profile', adminController.getProfile);
router.put('/profile', adminController.updateProfile);

// Teacher management
router.get('/teachers', adminController.getTeachers);
router.post('/teachers', adminController.addTeacher);
router.put('/teachers/:id/status', adminController.updateTeacherStatus);
router.delete('/teachers/:id', adminController.deleteTeacher);

// Student management
router.get('/students', adminController.getStudents);
router.post('/students', adminController.addStudent);
router.put('/students/:id/status', adminController.updateStudentStatus);
router.delete('/students/:id', adminController.deleteStudent);

// Course management
router.get('/courses', adminController.getCourses);
router.post('/courses', adminController.createCourse);
router.put('/courses/:id', adminController.updateCourse);
router.delete('/courses/:id', adminController.deleteCourse);

// Course assignments & enrollments
router.post('/courses/assign-teacher', adminController.assignTeacher);
router.post('/courses/enroll-student', adminController.enrollStudent);
router.get('/enrollments/pending', adminController.getPendingEnrollments);
router.post('/enrollments/approve', adminController.approveEnrollment);

module.exports = router;
