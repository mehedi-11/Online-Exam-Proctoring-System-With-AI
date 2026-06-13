const express = require('express');
const router = express.Router();
const studentController = require('../controllers/studentController');
const { verifyToken, authorizeRoles } = require('../middleware/authMiddleware');

// Protect all routes here with Student check
router.use(verifyToken, authorizeRoles('student'));

// Profile management
router.get('/profile', studentController.getProfile);
router.put('/change-password', studentController.changePassword);

// Course enrollment
router.get('/courses/enrolled', studentController.getCourses);
router.get('/courses/available', studentController.getAvailableCourses);
router.post('/courses/request-enrollment', studentController.requestEnrollment);

// Exams
router.get('/exams', studentController.getExams);
router.post('/exams/:examId/start', studentController.startExam);
router.get('/exams/:examId/questions', studentController.getExamQuestions);
router.post('/exams/:examId/submit', studentController.submitExam);

module.exports = router;
