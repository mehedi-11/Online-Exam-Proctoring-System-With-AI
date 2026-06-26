const db = require('../config/db');
const bcrypt = require('bcryptjs');

// --- PROFILE MANAGEMENT ---

exports.getProfile = async (req, res) => {
  try {
    const [rows] = await db.query(
      'SELECT id, name, email, profile_image, llm_api_key, joining_date, status FROM teachers WHERE id = ?',
      [req.user.id]
    );
    if (rows.length === 0) return res.status(404).json({ message: 'Teacher not found' });
    const teacher = rows[0];
    teacher.has_llm_api_key = !!teacher.llm_api_key;
    delete teacher.llm_api_key;
    return res.json(teacher);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching profile' });
  }
};

exports.updateProfile = async (req, res) => {
  const { name, llm_api_key } = req.body;
  const profile_image = req.file ? `/uploads/${req.file.filename}` : null;

  try {
    if (!name) return res.status(400).json({ message: 'Name is required' });

    let query = 'UPDATE teachers SET name = ?';
    let params = [name];

    if (llm_api_key !== undefined) {
      query += ', llm_api_key = ?';
      params.push(llm_api_key);
    }

    if (profile_image) {
      query += ', profile_image = ?';
      params.push(profile_image);
    }

    query += ' WHERE id = ?';
    params.push(req.user.id);

    await db.query(query, params);

    const [rows] = await db.query(
      'SELECT id, name, email, profile_image, llm_api_key, joining_date, status FROM teachers WHERE id = ?',
      [req.user.id]
    );

    const teacher = rows[0];
    teacher.has_llm_api_key = !!teacher.llm_api_key;
    delete teacher.llm_api_key;
    return res.json({ message: 'Profile updated successfully', user: teacher });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating profile' });
  }
};

exports.changePassword = async (req, res) => {
  const { oldPassword, newPassword } = req.body;
  if (!oldPassword || !newPassword) {
    return res.status(400).json({ message: 'Old and new passwords are required' });
  }
  try {
    const [rows] = await db.query('SELECT password FROM teachers WHERE id = ?', [req.user.id]);
    if (rows.length === 0) {
      return res.status(404).json({ message: 'Teacher not found' });
    }

    const teacher = rows[0];
    const isMatch = await bcrypt.compare(oldPassword, teacher.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Incorrect old password' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await db.query('UPDATE teachers SET password = ? WHERE id = ?', [hashedPassword, req.user.id]);

    return res.json({ message: 'Password updated successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating password' });
  }
};

// --- EXAM MANAGEMENT ---

exports.getExams = async (req, res) => {
  try {
    const query = `
      SELECT e.*, 
             (SELECT COUNT(*) FROM exam_questions eq WHERE eq.exam_id = e.id) AS questions_count,
             (SELECT COUNT(*) FROM student_exams se WHERE se.exam_id = e.id) AS submissions_count
      FROM exams e
      WHERE e.teacher_id = ?
      ORDER BY e.exam_date DESC
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching exams' });
  }
};

exports.createExam = async (req, res) => {
  const { title, exam_date, duration_minutes, type, must_on_camera, must_on_microphone, exam_password } = req.body;
  if (!title || !exam_date || !duration_minutes || !type) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    const [result] = await db.query(
      'INSERT INTO exams (title, exam_date, duration_minutes, type, teacher_id, must_on_camera, must_on_microphone, exam_password) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [title, exam_date, duration_minutes, type, req.user.id, must_on_camera ?? true, must_on_microphone ?? true, exam_password || null]
    );

    await db.query('INSERT INTO admin_notifications (message) VALUES (?)', [`Teacher ${req.user.name} created a new exam: ${title}`]);

    return res.status(201).json({ message: 'Exam created successfully', examId: result.insertId });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error creating exam' });
  }
};

exports.updateExam = async (req, res) => {
  const { id } = req.params;
  const { title, exam_date, duration_minutes, type, must_on_camera, must_on_microphone, exam_password } = req.body;
  
  if (!title || !exam_date || !duration_minutes || !type) {
    return res.status(400).json({ message: 'All fields are required' });
  }
  
  try {
    const [result] = await db.query(
      `UPDATE exams SET title=?, exam_date=?, duration_minutes=?, type=?, must_on_camera=?, must_on_microphone=?, exam_password=?
       WHERE id=? AND teacher_id=?`,
      [title, exam_date, duration_minutes, type, must_on_camera ?? true, must_on_microphone ?? true, exam_password || null, id, req.user.id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Exam not found or unauthorized' });

    await db.query('INSERT INTO admin_notifications (message) VALUES (?)', [`Teacher ${req.user.name} updated the exam: ${title}`]);

    return res.json({ message: 'Exam updated successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating exam' });
  }
};

exports.deleteExam = async (req, res) => {
  const { id } = req.params;
  try {
    const [exam] = await db.query('SELECT title FROM exams WHERE id = ? AND teacher_id = ?', [id, req.user.id]);
    const examTitle = exam.length > 0 ? exam[0].title : `ID ${id}`;

    const [result] = await db.query('DELETE FROM exams WHERE id = ? AND teacher_id = ?', [id, req.user.id]);
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Exam not found or unauthorized' });

    await db.query('INSERT INTO admin_notifications (message) VALUES (?)', [`Teacher ${req.user.name} deleted the exam: ${examTitle}`]);

    return res.json({ message: 'Exam deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting exam' });
  }
};

exports.toggleExamLive = async (req, res) => {
  const { id } = req.params;
  const { is_live, exam_password } = req.body;
  
  try {
    const [exam] = await db.query('SELECT title FROM exams WHERE id = ? AND teacher_id = ?', [id, req.user.id]);
    const examTitle = exam.length > 0 ? exam[0].title : `ID ${id}`;

    const [result] = await db.query(
      'UPDATE exams SET is_live=?, exam_password=? WHERE id=? AND teacher_id=?',
      [is_live ? 1 : 0, is_live ? exam_password : null, id, req.user.id]
    );
    if (result.affectedRows === 0) return res.status(404).json({ message: 'Exam not found or unauthorized' });

    const statusStr = is_live ? 'LIVE' : 'OFFLINE';
    await db.query('INSERT INTO admin_notifications (message) VALUES (?)', [`Teacher ${req.user.name} changed exam status to ${statusStr}: ${examTitle}`]);

    return res.json({ message: is_live ? 'Exam is now live!' : 'Exam is no longer live.' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error toggling live status' });
  }
};


// --- QUESTION MANAGEMENT ---

exports.getQuestions = async (req, res) => {
  const { examId } = req.params;
  try {
    // Verify exam ownership first
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    const [rows] = await db.query('SELECT * FROM exam_questions WHERE exam_id = ? ORDER BY id ASC', [examId]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching questions' });
  }
};

exports.createQuestion = async (req, res) => {
  const { exam_id, type, question_text, marks, option_a, option_b, option_c, option_d, correct_option } = req.body;
  
  if (!exam_id || !type || !question_text || !marks) {
    return res.status(400).json({ message: 'Exam ID, Type, Question Text, and Marks are required' });
  }

  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [exam_id, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    await db.query(
      `INSERT INTO exam_questions (exam_id, type, question_text, marks, option_a, option_b, option_c, option_d, correct_option)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [exam_id, type, question_text, marks, option_a||null, option_b||null, option_c||null, option_d||null, correct_option||null]
    );

    return res.status(201).json({ message: 'Question added successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error adding question' });
  }
};

exports.updateQuestion = async (req, res) => {
  const { id } = req.params;
  const { type, question_text, marks, option_a, option_b, option_c, option_d, correct_option } = req.body;
  
  if (!type || !question_text || !marks) {
    return res.status(400).json({ message: 'Type, Question Text, and Marks are required' });
  }

  try {
    const [exam] = await db.query(`
      SELECT e.id FROM exams e 
      JOIN exam_questions eq ON e.id = eq.exam_id 
      WHERE eq.id = ? AND e.teacher_id = ?
    `, [id, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    await db.query(
      `UPDATE exam_questions SET type=?, question_text=?, marks=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_option=?
       WHERE id=?`,
      [type, question_text, marks, option_a||null, option_b||null, option_c||null, option_d||null, correct_option||null, id]
    );

    return res.json({ message: 'Question updated successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error updating question' });
  }
};

exports.deleteQuestion = async (req, res) => {
  const { id } = req.params;
  try {
    // Verify exam ownership via question
    const [exam] = await db.query(`
      SELECT e.id FROM exams e 
      JOIN exam_questions eq ON e.id = eq.exam_id 
      WHERE eq.id = ? AND e.teacher_id = ?
    `, [id, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    await db.query('DELETE FROM exam_questions WHERE id = ?', [id]);
    return res.json({ message: 'Question deleted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error deleting question' });
  }
};

// --- EXAM RESULTS & GRADING ---

exports.getExamResults = async (req, res) => {
  const { id } = req.params;
  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [id, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    const query = `
      SELECT se.student_id, se.score, se.status, se.started_at, se.finished_at,
             s.name, s.email
      FROM student_exams se
      JOIN students s ON se.student_id = s.id
      WHERE se.exam_id = ?
    `;
    const [rows] = await db.query(query, [id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching exam results' });
  }
};

exports.getStudentAnswersheet = async (req, res) => {
  const { examId, studentId } = req.params;
  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    // Get answers with questions
    const query = `
      SELECT sa.id as answer_id, sa.student_answer, sa.marks_awarded,
             eq.id as question_id, eq.type, eq.question_text, eq.marks as max_marks,
             eq.option_a, eq.option_b, eq.option_c, eq.option_d, eq.correct_option
      FROM exam_questions eq
      LEFT JOIN student_answers sa ON eq.id = sa.question_id AND sa.student_id = ?
      WHERE eq.exam_id = ?
    `;
    const [rows] = await db.query(query, [studentId, examId]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching answersheet' });
  }
};

exports.manualGradeAnswersheet = async (req, res) => {
  const { examId, studentId } = req.params;
  const { grades } = req.body; // Map: { answer_id: marks_awarded }

  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    let totalMarks = 0;
    
    // Begin transaction? No need, just simple updates.
    for (const [answer_id, marks_awarded] of Object.entries(grades)) {
      await db.query(
        'UPDATE student_answers SET marks_awarded = ? WHERE id = ?',
        [marks_awarded, answer_id]
      );
    }
    
    // Recalculate total score
    const [scoreResult] = await db.query(
      'SELECT SUM(marks_awarded) as total FROM student_answers WHERE exam_id=? AND student_id=?',
      [examId, studentId]
    );
    
    const finalScore = scoreResult[0].total || 0;
    
    await db.query(
      'UPDATE student_exams SET score = ? WHERE exam_id=? AND student_id=?',
      [finalScore, examId, studentId]
    );

    return res.json({ message: 'Grades saved successfully', score: finalScore });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error saving grades' });
  }
};

exports.aiGradeAnswersheet = async (req, res) => {
  const { examId, studentId } = req.params;
  const { gradesData } = req.body; // Array of items to grade: [{ answer_id, question_text, student_answer, max_marks }]

  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    // 1. Get teacher's LLM API Key
    const [teacher] = await db.query('SELECT llm_api_key FROM teachers WHERE id = ?', [req.user.id]);
    if (teacher.length === 0 || !teacher[0].llm_api_key) {
      return res.status(400).json({ message: 'LLM API Key is missing. Please add it in Profile Settings.' });
    }
    
    const apiKey = teacher[0].llm_api_key;
    
    // 2. Prepare Prompt for LLM
    let promptText = "You are an expert strict AI examiner grading a student's exam answers. Evaluate the following questions and answers.\n\n";
    promptText += "For each question, assign a numeric score between 0 and the max marks based on correctness. Output MUST be valid JSON containing an array of objects with format { \"answer_id\": number, \"marks_awarded\": number, \"reason\": \"short reasoning\" }.\n\n";
    
    gradesData.forEach((item, idx) => {
      promptText += `Q${idx+1} [ID: ${item.answer_id}] [Max Marks: ${item.max_marks}]: ${item.question_text}\n`;
      promptText += `Student Answer: ${item.student_answer || "(No answer)"}\n\n`;
    });
    
    promptText += "\nOnly return the JSON array, no markdown blocks, no extra text.";

    // 3. Call Gemini API using native fetch
    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${apiKey}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          contents: [{ parts: [{ text: promptText }] }],
          generationConfig: {
              temperature: 0.2,
              responseMimeType: "application/json"
          }
        })
      }
    );

    if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error?.message || 'Failed to call Gemini API');
    }
    
    const data = await response.json();
    const aiResponseText = data.candidates[0].content.parts[0].text;
    
    let gradingResults;
    try {
      gradingResults = JSON.parse(aiResponseText);
    } catch (e) {
      // Fallback regex if it wrapped in markdown
      const match = aiResponseText.match(/\[.*\]/s);
      if (match) {
        gradingResults = JSON.parse(match[0]);
      } else {
         throw new Error("Failed to parse AI response JSON");
      }
    }
    
    // 4. Update the Database with AI Grades
    for (const result of gradingResults) {
      if (result.answer_id && result.marks_awarded !== undefined) {
        await db.query(
          'UPDATE student_answers SET marks_awarded = ? WHERE id = ?',
          [result.marks_awarded, result.answer_id]
        );
      }
    }
    
    // Recalculate total score
    const [scoreResult] = await db.query(
      'SELECT SUM(marks_awarded) as total FROM student_answers WHERE exam_id=? AND student_id=?',
      [examId, studentId]
    );
    
    const finalScore = scoreResult[0].total || 0;
    await db.query(
      'UPDATE student_exams SET score = ? WHERE exam_id=? AND student_id=?',
      [finalScore, examId, studentId]
    );

    return res.json({ message: 'AI Grading completed successfully', score: finalScore, ai_results: gradingResults });
  } catch (error) {
    console.error(error);
    const msg = error.response?.data?.error?.message || error.message || 'Server error during AI grading';
    return res.status(500).json({ message: 'AI API Error: ' + msg });
  }
};


// --- PROCTORING LOGS ---

exports.getProctoringLogs = async (req, res) => {
  try {
    const query = `
      SELECT pl.*, 
             s.name AS student_name, s.email AS student_email,
             e.title AS exam_title
      FROM proctoring_logs pl
      JOIN students s ON pl.student_id = s.id
      JOIN exams e ON pl.exam_id = e.id
      WHERE e.teacher_id = ?
      ORDER BY pl.timestamp DESC
    `;
    const [rows] = await db.query(query, [req.user.id]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error fetching proctoring logs' });
  }
};

// Get students for a specific exam
exports.getExamStudents = async (req, res) => {
  const { examId } = req.params;
  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    const [rows] = await db.query(`
      SELECT s.id, s.name, se.status, se.demerit_points, se.score
      FROM student_exams se
      JOIN students s ON se.student_id = s.id
      WHERE se.exam_id = ?
    `, [examId]);
    return res.json(rows);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error retrieving exam students' });
  }
};

// Download logs for a specific exam as CSV (Excel compatible)
exports.downloadExamLogs = async (req, res) => {
  const { examId } = req.params;
  try {
    const [exam] = await db.query('SELECT id FROM exams WHERE id = ? AND teacher_id = ?', [examId, req.user.id]);
    if (exam.length === 0) return res.status(403).json({ message: 'Unauthorized' });

    const [logs] = await db.query(`
      SELECT pl.student_id, s.name, pl.activity_type, pl.details, pl.timestamp
      FROM proctoring_logs pl
      JOIN students s ON pl.student_id = s.id
      WHERE pl.exam_id = ?
      ORDER BY pl.timestamp DESC
    `, [examId]);

    let csvContent = 'Student ID,Student Name,Activity Type,Details,Timestamp\n';
    logs.forEach(log => {
      const row = [
        `"${log.student_id}"`,
        `"${log.name}"`,
        `"${log.activity_type}"`,
        `"${log.details}"`,
        `"${new Date(log.timestamp).toISOString()}"`
      ].join(',');
      csvContent += row + '\n';
    });

    res.setHeader('Content-Type', 'text/csv; charset=utf-8');
    res.setHeader('Content-Disposition', `attachment; filename="exam_${examId}_proctor_logs.csv"`);
    return res.send(csvContent);
  } catch (error) {
    console.error(error);
    return res.status(500).json({ message: 'Server error downloading logs' });
  }
};
