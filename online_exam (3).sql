-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 29, 2026 at 11:37 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `online_exam`
--

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `name`, `email`, `password`, `reset_token`, `reset_token_expiry`) VALUES
(1, 'System Administrator', 'admin@exam.com', '$2a$10$4Xln9SmHFlwB.WPOhYIk9enzLHBYkm2qRUiGksgWVdfLVQceCDaom', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `admin_notifications`
--

CREATE TABLE `admin_notifications` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_notifications`
--

INSERT INTO `admin_notifications` (`id`, `message`, `is_read`, `created_at`) VALUES
(1, 'New teacher registered: MD Mehedi Hasan (firegamingv8@gmail.com)', 1, '2026-06-28 12:45:45'),
(2, 'Teacher MD Mehedi Hasan changed exam status to LIVE: Exam 8 - 2026', 0, '2026-06-29 14:40:47'),
(3, 'Teacher MD Mehedi Hasan changed exam status to OFFLINE: Exam 8 - 2026', 0, '2026-06-29 15:15:56'),
(4, 'Teacher MD Mehedi Hasan changed exam status to LIVE: Exam 8 - 2026', 0, '2026-06-29 15:16:01'),
(5, 'Teacher MD Mehedi Hasan changed exam status to OFFLINE: Exam 8 - 2026', 0, '2026-06-29 15:16:08');

-- --------------------------------------------------------

--
-- Table structure for table `exams`
--

CREATE TABLE `exams` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `exam_date` datetime NOT NULL,
  `duration_minutes` int(11) NOT NULL,
  `end_time` datetime NOT NULL DEFAULT current_timestamp(),
  `type` enum('MCQ','Written','Both') DEFAULT 'MCQ',
  `is_live` tinyint(1) DEFAULT 0,
  `exam_password` varchar(255) DEFAULT NULL,
  `must_on_camera` tinyint(1) DEFAULT 1,
  `must_on_microphone` tinyint(1) DEFAULT 1,
  `teacher_id` int(11) DEFAULT NULL,
  `course_name` varchar(255) DEFAULT NULL,
  `course_code` varchar(100) DEFAULT NULL,
  `university_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exams`
--

INSERT INTO `exams` (`id`, `title`, `exam_date`, `duration_minutes`, `end_time`, `type`, `is_live`, `exam_password`, `must_on_camera`, `must_on_microphone`, `teacher_id`, `course_name`, `course_code`, `university_name`) VALUES
(2, 'Exam 1 - 2026', '2026-07-05 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'City University'),
(3, 'Exam 2 - 2026', '2026-06-29 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'Primeasia University'),
(4, 'Exam 3 - 2026', '2026-07-01 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'City University'),
(5, 'Exam 4 - 2026', '2026-07-22 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'City University'),
(6, 'Exam 5 - 2026', '2026-07-04 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Database Management', 'CS401', 'City University'),
(7, 'Exam 6 - 2026', '2026-06-29 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Software Engineering', 'CS501', 'City University'),
(8, 'Exam 7 - 2026', '2026-07-14 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'Dhaka University'),
(9, 'Exam 8 - 2026', '2026-07-27 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Software Engineering', 'CS501', 'Dhaka University'),
(10, 'Exam 9 - 2026', '2026-07-14 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'City University'),
(11, 'Exam 10 - 2026', '2026-07-02 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'Dhaka University'),
(12, 'Exam 11 - 2026', '2026-07-19 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'Dhaka University'),
(13, 'Exam 12 - 2026', '2026-07-13 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'City University'),
(14, 'Exam 13 - 2026', '2026-07-16 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'City University'),
(15, 'Exam 14 - 2026', '2026-07-20 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'City University'),
(16, 'Exam 15 - 2026', '2026-07-12 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Database Management', 'CS401', 'City University'),
(17, 'Exam 16 - 2026', '2026-07-01 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Software Engineering', 'CS501', 'Primeasia University'),
(18, 'Exam 17 - 2026', '2026-07-10 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'Primeasia University'),
(19, 'Exam 18 - 2026', '2026-07-10 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(20, 'Exam 19 - 2026', '2026-07-12 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(21, 'Exam 20 - 2026', '2026-07-20 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(22, 'Exam 21 - 2026', '2026-07-06 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Database Management', 'CS401', 'Primeasia University'),
(23, 'Exam 22 - 2026', '2026-06-30 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Computer Science 101', 'CS101', 'Primeasia University'),
(24, 'Exam 23 - 2026', '2026-07-26 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Software Engineering', 'CS501', 'City University'),
(25, 'Exam 24 - 2026', '2026-07-24 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(26, 'Exam 25 - 2026', '2026-07-03 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Software Engineering', 'CS501', 'Primeasia University'),
(27, 'Exam 26 - 2026', '2026-07-23 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'City University'),
(28, 'Exam 27 - 2026', '2026-07-09 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Algorithms', 'CS301', 'Primeasia University'),
(29, 'Exam 28 - 2026', '2026-06-29 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'City University'),
(30, 'Exam 29 - 2026', '2026-07-07 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'Primeasia University'),
(31, 'Exam 30 - 2026', '2026-07-21 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Computer Science 101', 'CS101', 'Primeasia University'),
(32, 'Exam 31 - 2026', '2026-06-28 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'Primeasia University'),
(33, 'Exam 32 - 2026', '2026-07-14 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Algorithms', 'CS301', 'Dhaka University'),
(34, 'Exam 33 - 2026', '2026-07-27 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'Dhaka University'),
(35, 'Exam 34 - 2026', '2026-07-07 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'Dhaka University'),
(36, 'Exam 35 - 2026', '2026-07-03 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'Dhaka University'),
(37, 'Exam 36 - 2026', '2026-06-28 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'Primeasia University'),
(38, 'Exam 37 - 2026', '2026-07-14 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'Dhaka University'),
(39, 'Exam 38 - 2026', '2026-07-27 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'Dhaka University'),
(40, 'Exam 39 - 2026', '2026-07-11 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'Dhaka University'),
(41, 'Exam 40 - 2026', '2026-07-24 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(42, 'Exam 41 - 2026', '2026-07-09 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(43, 'Exam 42 - 2026', '2026-07-07 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Computer Science 101', 'CS101', 'Dhaka University'),
(44, 'Exam 43 - 2026', '2026-06-29 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Artificial Intelligence', 'CS601', 'City University'),
(45, 'Exam 44 - 2026', '2026-07-11 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Database Management', 'CS401', 'Dhaka University'),
(46, 'Exam 45 - 2026', '2026-07-20 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'City University'),
(47, 'Exam 46 - 2026', '2026-07-14 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'Primeasia University'),
(48, 'Exam 47 - 2026', '2026-07-16 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Machine Learning', 'CS701', 'City University'),
(49, 'Exam 48 - 2026', '2026-07-25 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Web Development', 'CS801', 'Dhaka University'),
(50, 'Exam 49 - 2026', '2026-07-01 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Computer Science 101', 'CS101', 'Dhaka University'),
(51, 'Exam 50 - 2026', '2026-07-02 14:04:00', 60, '2026-06-28 14:04:00', 'MCQ', 0, NULL, 1, 1, 12, 'Data Structures', 'CS201', 'Primeasia University');

-- --------------------------------------------------------

--
-- Table structure for table `exam_questions`
--

CREATE TABLE `exam_questions` (
  `id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `question_text` text NOT NULL,
  `type` enum('MCQ','Written') DEFAULT 'MCQ',
  `marks` int(11) NOT NULL DEFAULT 1,
  `option_a` varchar(255) DEFAULT NULL,
  `option_b` varchar(255) DEFAULT NULL,
  `option_c` varchar(255) DEFAULT NULL,
  `option_d` varchar(255) DEFAULT NULL,
  `correct_option` enum('A','B','C','D') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `exam_questions`
--

INSERT INTO `exam_questions` (`id`, `exam_id`, `question_text`, `type`, `marks`, `option_a`, `option_b`, `option_c`, `option_d`, `correct_option`) VALUES
(7, 2, 'Sample Question 1 for Exam 1 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(8, 2, 'Sample Question 2 for Exam 1 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(9, 2, 'Sample Question 3 for Exam 1 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(10, 3, 'Sample Question 1 for Exam 2 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(11, 3, 'Sample Question 2 for Exam 2 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(12, 3, 'Sample Question 3 for Exam 2 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(13, 4, 'Sample Question 1 for Exam 3 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(14, 4, 'Sample Question 2 for Exam 3 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(15, 4, 'Sample Question 3 for Exam 3 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(16, 5, 'Sample Question 1 for Exam 4 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(17, 5, 'Sample Question 2 for Exam 4 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(18, 5, 'Sample Question 3 for Exam 4 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(19, 6, 'Sample Question 1 for Exam 5 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(20, 6, 'Sample Question 2 for Exam 5 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(21, 6, 'Sample Question 3 for Exam 5 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(22, 7, 'Sample Question 1 for Exam 6 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(23, 7, 'Sample Question 2 for Exam 6 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(24, 7, 'Sample Question 3 for Exam 6 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(25, 8, 'Sample Question 1 for Exam 7 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(26, 8, 'Sample Question 2 for Exam 7 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(27, 8, 'Sample Question 3 for Exam 7 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(28, 9, 'Sample Question 1 for Exam 8 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(29, 9, 'Sample Question 2 for Exam 8 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(30, 9, 'Sample Question 3 for Exam 8 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(31, 10, 'Sample Question 1 for Exam 9 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(32, 10, 'Sample Question 2 for Exam 9 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(33, 10, 'Sample Question 3 for Exam 9 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(34, 11, 'Sample Question 1 for Exam 10 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(35, 11, 'Sample Question 2 for Exam 10 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(36, 11, 'Sample Question 3 for Exam 10 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(37, 12, 'Sample Question 1 for Exam 11 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(38, 12, 'Sample Question 2 for Exam 11 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(39, 12, 'Sample Question 3 for Exam 11 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(40, 13, 'Sample Question 1 for Exam 12 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(41, 13, 'Sample Question 2 for Exam 12 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(42, 13, 'Sample Question 3 for Exam 12 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(43, 14, 'Sample Question 1 for Exam 13 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(44, 14, 'Sample Question 2 for Exam 13 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(45, 14, 'Sample Question 3 for Exam 13 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(46, 15, 'Sample Question 1 for Exam 14 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(47, 15, 'Sample Question 2 for Exam 14 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(48, 15, 'Sample Question 3 for Exam 14 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(49, 16, 'Sample Question 1 for Exam 15 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(50, 16, 'Sample Question 2 for Exam 15 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(51, 16, 'Sample Question 3 for Exam 15 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(52, 17, 'Sample Question 1 for Exam 16 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(53, 17, 'Sample Question 2 for Exam 16 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(54, 17, 'Sample Question 3 for Exam 16 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(55, 18, 'Sample Question 1 for Exam 17 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(56, 18, 'Sample Question 2 for Exam 17 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(57, 18, 'Sample Question 3 for Exam 17 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(58, 19, 'Sample Question 1 for Exam 18 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(59, 19, 'Sample Question 2 for Exam 18 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(60, 19, 'Sample Question 3 for Exam 18 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(61, 20, 'Sample Question 1 for Exam 19 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(62, 20, 'Sample Question 2 for Exam 19 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(63, 20, 'Sample Question 3 for Exam 19 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(64, 21, 'Sample Question 1 for Exam 20 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(65, 21, 'Sample Question 2 for Exam 20 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(66, 21, 'Sample Question 3 for Exam 20 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(67, 22, 'Sample Question 1 for Exam 21 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(68, 22, 'Sample Question 2 for Exam 21 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(69, 22, 'Sample Question 3 for Exam 21 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(70, 23, 'Sample Question 1 for Exam 22 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(71, 23, 'Sample Question 2 for Exam 22 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(72, 23, 'Sample Question 3 for Exam 22 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(73, 24, 'Sample Question 1 for Exam 23 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(74, 24, 'Sample Question 2 for Exam 23 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(75, 24, 'Sample Question 3 for Exam 23 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(76, 25, 'Sample Question 1 for Exam 24 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(77, 25, 'Sample Question 2 for Exam 24 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(78, 25, 'Sample Question 3 for Exam 24 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(79, 26, 'Sample Question 1 for Exam 25 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(80, 26, 'Sample Question 2 for Exam 25 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(81, 26, 'Sample Question 3 for Exam 25 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(82, 27, 'Sample Question 1 for Exam 26 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(83, 27, 'Sample Question 2 for Exam 26 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(84, 27, 'Sample Question 3 for Exam 26 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(85, 28, 'Sample Question 1 for Exam 27 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(86, 28, 'Sample Question 2 for Exam 27 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(87, 28, 'Sample Question 3 for Exam 27 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(88, 29, 'Sample Question 1 for Exam 28 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(89, 29, 'Sample Question 2 for Exam 28 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(90, 29, 'Sample Question 3 for Exam 28 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(91, 30, 'Sample Question 1 for Exam 29 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(92, 30, 'Sample Question 2 for Exam 29 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(93, 30, 'Sample Question 3 for Exam 29 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(94, 31, 'Sample Question 1 for Exam 30 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(95, 31, 'Sample Question 2 for Exam 30 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(96, 31, 'Sample Question 3 for Exam 30 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(97, 32, 'Sample Question 1 for Exam 31 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(98, 32, 'Sample Question 2 for Exam 31 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(99, 32, 'Sample Question 3 for Exam 31 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(100, 33, 'Sample Question 1 for Exam 32 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(101, 33, 'Sample Question 2 for Exam 32 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(102, 33, 'Sample Question 3 for Exam 32 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(103, 34, 'Sample Question 1 for Exam 33 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(104, 34, 'Sample Question 2 for Exam 33 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(105, 34, 'Sample Question 3 for Exam 33 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(106, 35, 'Sample Question 1 for Exam 34 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(107, 35, 'Sample Question 2 for Exam 34 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(108, 35, 'Sample Question 3 for Exam 34 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(109, 36, 'Sample Question 1 for Exam 35 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(110, 36, 'Sample Question 2 for Exam 35 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(111, 36, 'Sample Question 3 for Exam 35 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(112, 37, 'Sample Question 1 for Exam 36 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(113, 37, 'Sample Question 2 for Exam 36 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(114, 37, 'Sample Question 3 for Exam 36 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(115, 38, 'Sample Question 1 for Exam 37 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(116, 38, 'Sample Question 2 for Exam 37 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(117, 38, 'Sample Question 3 for Exam 37 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(118, 39, 'Sample Question 1 for Exam 38 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(119, 39, 'Sample Question 2 for Exam 38 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(120, 39, 'Sample Question 3 for Exam 38 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(121, 40, 'Sample Question 1 for Exam 39 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(122, 40, 'Sample Question 2 for Exam 39 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(123, 40, 'Sample Question 3 for Exam 39 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(124, 41, 'Sample Question 1 for Exam 40 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(125, 41, 'Sample Question 2 for Exam 40 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(126, 41, 'Sample Question 3 for Exam 40 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(127, 42, 'Sample Question 1 for Exam 41 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(128, 42, 'Sample Question 2 for Exam 41 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(129, 42, 'Sample Question 3 for Exam 41 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(130, 43, 'Sample Question 1 for Exam 42 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(131, 43, 'Sample Question 2 for Exam 42 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(132, 43, 'Sample Question 3 for Exam 42 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(133, 44, 'Sample Question 1 for Exam 43 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(134, 44, 'Sample Question 2 for Exam 43 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(135, 44, 'Sample Question 3 for Exam 43 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(136, 45, 'Sample Question 1 for Exam 44 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(137, 45, 'Sample Question 2 for Exam 44 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(138, 45, 'Sample Question 3 for Exam 44 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(139, 46, 'Sample Question 1 for Exam 45 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(140, 46, 'Sample Question 2 for Exam 45 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(141, 46, 'Sample Question 3 for Exam 45 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(142, 47, 'Sample Question 1 for Exam 46 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(143, 47, 'Sample Question 2 for Exam 46 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(144, 47, 'Sample Question 3 for Exam 46 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(145, 48, 'Sample Question 1 for Exam 47 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(146, 48, 'Sample Question 2 for Exam 47 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(147, 48, 'Sample Question 3 for Exam 47 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(148, 49, 'Sample Question 1 for Exam 48 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(149, 49, 'Sample Question 2 for Exam 48 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(150, 49, 'Sample Question 3 for Exam 48 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(151, 50, 'Sample Question 1 for Exam 49 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(152, 50, 'Sample Question 2 for Exam 49 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(153, 50, 'Sample Question 3 for Exam 49 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(154, 51, 'Sample Question 1 for Exam 50 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(155, 51, 'Sample Question 2 for Exam 50 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A'),
(156, 51, 'Sample Question 3 for Exam 50 - 2026', 'MCQ', 5, 'Option A (Correct)', 'Option B', 'Option C', 'Option D', 'A');

-- --------------------------------------------------------

--
-- Table structure for table `login_attempts`
--

CREATE TABLE `login_attempts` (
  `id` int(11) NOT NULL,
  `identifier` varchar(100) DEFAULT NULL,
  `failed_count` int(11) DEFAULT 0,
  `blocked_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `login_attempts`
--

INSERT INTO `login_attempts` (`id`, `identifier`, `failed_count`, `blocked_until`) VALUES
(1, 'mehedi.admin@exam.com', 1, NULL),
(3, '232005048', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `proctoring_logs`
--

CREATE TABLE `proctoring_logs` (
  `id` int(11) NOT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `activity_type` varchar(100) NOT NULL,
  `details` text DEFAULT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` varchar(50) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `name`, `email`, `password`, `profile_image`, `status`, `reset_token`, `reset_token_expiry`) VALUES
('232004048', 'MD Mehedi Hasan', 'mehedimridul1919@gmail.com', '$2a$10$OV4pTMbzaPUvmM3vDJUkpephaYeyIRtfO5iSdzCM/Ydvg63RQeY5C', NULL, 'approved', NULL, NULL),
('STU1001', 'Rahul Gupta', 'student1@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1002', 'Rohan Kumar', 'student2@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1003', 'Rita Chowdhury', 'student3@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1004', 'Ashok Roy', 'student4@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1005', 'Karan Sharma', 'student5@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1006', 'Rohan Gupta', 'student6@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1007', 'Raj Roy', 'student7@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1008', 'Meena Jain', 'student8@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1009', 'Rahul Gupta', 'student9@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1010', 'Geeta Das', 'student10@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1011', 'Geeta Sharma', 'student11@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1012', 'Rahul Gupta', 'student12@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1013', 'Rita Gupta', 'student13@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1014', 'Raj Jain', 'student14@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1015', 'Karan Patel', 'student15@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1016', 'Rita Das', 'student16@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1017', 'Sunil Verma', 'student17@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1018', 'Rita Gupta', 'student18@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1019', 'Neha Chowdhury', 'student19@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1020', 'Manoj Verma', 'student20@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1021', 'Anjali Kumar', 'student21@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1022', 'Priya Jain', 'student22@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1023', 'Geeta Kumar', 'student23@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1024', 'Karan Verma', 'student24@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1025', 'Anita Roy', 'student25@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1026', 'Anita Chowdhury', 'student26@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1027', 'Meena Jain', 'student27@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1028', 'Rohan Singh', 'student28@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1029', 'Rohan Jain', 'student29@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1030', 'Amit Gupta', 'student30@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1031', 'Amit Gupta', 'student31@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1032', 'Ashok Sharma', 'student32@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1033', 'Pooja Sharma', 'student33@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1034', 'Geeta Jain', 'student34@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1035', 'Neha Kumar', 'student35@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1036', 'Geeta Das', 'student36@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1037', 'Vikram Das', 'student37@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1038', 'Rahul Gupta', 'student38@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1039', 'Rahul Gupta', 'student39@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1040', 'Kavita Das', 'student40@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1041', 'Pooja Verma', 'student41@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1042', 'Rita Jain', 'student42@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1043', 'Priya Chowdhury', 'student43@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1044', 'Ashok Patel', 'student44@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1045', 'Meena Patel', 'student45@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1046', 'Anita Patel', 'student46@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1047', 'Anita Patel', 'student47@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1048', 'Rita Roy', 'student48@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1049', 'Kavita Singh', 'student49@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1050', 'Kavita Roy', 'student50@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1051', 'Meena Verma', 'student51@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1052', 'Priya Kumar', 'student52@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1053', 'Pooja Singh', 'student53@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1054', 'Sneha Chowdhury', 'student54@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1055', 'Ashok Roy', 'student55@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1056', 'Rahul Chowdhury', 'student56@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1057', 'Rahul Patel', 'student57@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1058', 'Kavita Jain', 'student58@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1059', 'Rohan Das', 'student59@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1060', 'Pooja Singh', 'student60@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1061', 'Anita Sharma', 'student61@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1062', 'Priya Jain', 'student62@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1063', 'Sneha Chowdhury', 'student63@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1064', 'Manoj Sharma', 'student64@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1065', 'Manoj Verma', 'student65@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1066', 'Sunil Patel', 'student66@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1067', 'Rahul Singh', 'student67@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1068', 'Pooja Kumar', 'student68@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1069', 'Vikram Das', 'student69@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1070', 'Sanjay Das', 'student70@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1071', 'Sunil Singh', 'student71@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1072', 'Neha Gupta', 'student72@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1073', 'Manoj Das', 'student73@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1074', 'Sneha Jain', 'student74@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1075', 'Sanjay Kumar', 'student75@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1076', 'Anita Singh', 'student76@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1077', 'Priya Sharma', 'student77@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1078', 'Kavita Patel', 'student78@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1079', 'Rahul Sharma', 'student79@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1080', 'Rohan Singh', 'student80@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1081', 'Rohan Roy', 'student81@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1082', 'Meena Sharma', 'student82@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1083', 'Karan Singh', 'student83@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1084', 'Neha Sharma', 'student84@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1085', 'Raj Das', 'student85@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1086', 'Raj Chowdhury', 'student86@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1087', 'Sunil Patel', 'student87@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1088', 'Kavita Jain', 'student88@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1089', 'Raj Gupta', 'student89@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1090', 'Rita Chowdhury', 'student90@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1091', 'Neha Kumar', 'student91@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1092', 'Karan Singh', 'student92@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1093', 'Anita Roy', 'student93@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1094', 'Karan Chowdhury', 'student94@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1095', 'Raj Chowdhury', 'student95@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1096', 'Raj Das', 'student96@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1097', 'Rita Das', 'student97@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1098', 'Priya Patel', 'student98@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1099', 'Sunil Sharma', 'student99@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL),
('STU1100', 'Manoj Verma', 'student100@exam.com', '$2a$10$2/RiTC7TyONyJM66rqtvYuoOfwU0iw4NKoBRyrXdwtVov3HAQUJ2S', NULL, 'approved', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `student_answers`
--

CREATE TABLE `student_answers` (
  `id` int(11) NOT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `question_id` int(11) DEFAULT NULL,
  `student_answer` text DEFAULT NULL,
  `marks_awarded` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_exams`
--

CREATE TABLE `student_exams` (
  `id` int(11) NOT NULL,
  `student_id` varchar(50) DEFAULT NULL,
  `exam_id` int(11) DEFAULT NULL,
  `started_at` datetime DEFAULT current_timestamp(),
  `finished_at` datetime DEFAULT NULL,
  `status` enum('started','completed','blocked') DEFAULT 'started',
  `demerit_points` int(11) DEFAULT 0,
  `score` int(11) DEFAULT NULL,
  `ai_grading_completed` tinyint(1) DEFAULT 0,
  `block_until` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `profile_image` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `joining_date` date DEFAULT curdate(),
  `llm_api_key` varchar(255) DEFAULT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `teachers`
--

INSERT INTO `teachers` (`id`, `name`, `email`, `password`, `profile_image`, `status`, `joining_date`, `llm_api_key`, `reset_token`, `reset_token_expiry`) VALUES
(1, 'Prof. Raj Patel', 'teacher1@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(2, 'Prof. Sunil Das', 'teacher2@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(3, 'Prof. Rohan Kumar', 'teacher3@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(4, 'Prof. Karan Patel', 'teacher4@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(5, 'Prof. Pooja Verma', 'teacher5@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(6, 'Prof. Priya Verma', 'teacher6@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(7, 'Prof. Karan Patel', 'teacher7@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(8, 'Prof. Pooja Patel', 'teacher8@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(9, 'Prof. Rohan Kumar', 'teacher9@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(10, 'Prof. Meena Gupta', 'teacher10@exam.com', '$2a$10$WEwZl7IsFnUwXSLoEqsTZOxEIxP6BKLacqCM34md2Z6pHpcqu9fRa', NULL, 'approved', '2026-01-01', NULL, NULL, NULL),
(12, 'MD Mehedi Hasan', 'firegamingv8@gmail.com', '$2a$10$nZFo6wp8sVi1AAkiNjneCO4KY8QpCPGudRcZk/UKIEus.2cQGWg52', NULL, 'approved', '2026-06-28', NULL, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `admin_notifications`
--
ALTER TABLE `admin_notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `exams`
--
ALTER TABLE `exams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `teacher_id` (`teacher_id`);

--
-- Indexes for table `exam_questions`
--
ALTER TABLE `exam_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_id` (`exam_id`);

--
-- Indexes for table `login_attempts`
--
ALTER TABLE `login_attempts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `identifier` (`identifier`);

--
-- Indexes for table `proctoring_logs`
--
ALTER TABLE `proctoring_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `exam_id` (`exam_id`),
  ADD KEY `question_id` (`question_id`);

--
-- Indexes for table `student_exams`
--
ALTER TABLE `student_exams`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `exam_id` (`exam_id`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `admin_notifications`
--
ALTER TABLE `admin_notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `exams`
--
ALTER TABLE `exams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `exam_questions`
--
ALTER TABLE `exam_questions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=157;

--
-- AUTO_INCREMENT for table `login_attempts`
--
ALTER TABLE `login_attempts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `proctoring_logs`
--
ALTER TABLE `proctoring_logs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_answers`
--
ALTER TABLE `student_answers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `student_exams`
--
ALTER TABLE `student_exams`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `exams`
--
ALTER TABLE `exams`
  ADD CONSTRAINT `exams_ibfk_1` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `exam_questions`
--
ALTER TABLE `exam_questions`
  ADD CONSTRAINT `exam_questions_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `proctoring_logs`
--
ALTER TABLE `proctoring_logs`
  ADD CONSTRAINT `proctoring_logs_ibfk_1` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proctoring_logs_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_answers`
--
ALTER TABLE `student_answers`
  ADD CONSTRAINT `student_answers_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_answers_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_answers_ibfk_3` FOREIGN KEY (`question_id`) REFERENCES `exam_questions` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `student_exams`
--
ALTER TABLE `student_exams`
  ADD CONSTRAINT `student_exams_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `student_exams_ibfk_2` FOREIGN KEY (`exam_id`) REFERENCES `exams` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
