const db = require('./src/config/db');

const unis = ['Primeasia University', 'Dhaka University', 'City University'];
const courses = [
  { name: 'Computer Science 101', code: 'CS101' },
  { name: 'Data Structures', code: 'CS201' },
  { name: 'Algorithms', code: 'CS301' },
  { name: 'Database Management', code: 'CS401' },
  { name: 'Software Engineering', code: 'CS501' },
  { name: 'Artificial Intelligence', code: 'CS601' },
  { name: 'Machine Learning', code: 'CS701' },
  { name: 'Web Development', code: 'CS801' }
];

async function seed() {
  try {
    const email = 'firegamingv8@gmail.com';
    const [teachers] = await db.query('SELECT id FROM teachers WHERE email = ?', [email]);
    
    if (teachers.length === 0) {
      console.log(`Teacher with email ${email} not found.`);
      process.exit(1);
    }
    
    const teacherId = teachers[0].id;
    console.log(`Found teacher ID: ${teacherId}`);

    for (let i = 1; i <= 50; i++) {
      const title = `Exam ${i} - ${new Date().getFullYear()}`;
      const examDate = new Date();
      examDate.setDate(examDate.getDate() + Math.floor(Math.random() * 30)); // random date in next 30 days
      const durationMinutes = 60;
      const type = 'MCQ';
      const course = courses[Math.floor(Math.random() * courses.length)];
      const uni = unis[Math.floor(Math.random() * unis.length)];
      
      const [result] = await db.query(
        'INSERT INTO exams (title, exam_date, duration_minutes, type, teacher_id, must_on_camera, must_on_microphone, course_name, course_code, university_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [title, examDate, durationMinutes, type, teacherId, true, true, course.name, course.code, uni]
      );
      
      const examId = result.insertId;
      console.log(`Created exam ${i} with ID ${examId}`);
      
      // Insert 3 questions for this exam
      for (let j = 1; j <= 3; j++) {
        await db.query(
          'INSERT INTO exam_questions (exam_id, question_text, type, marks, option_a, option_b, option_c, option_d, correct_option) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
          [
            examId,
            `Sample Question ${j} for ${title}`,
            'MCQ',
            5,
            'Option A (Correct)',
            'Option B',
            'Option C',
            'Option D',
            'A'
          ]
        );
      }
    }
    
    console.log('Successfully seeded 50 exams with 3 questions each!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
}

seed();
