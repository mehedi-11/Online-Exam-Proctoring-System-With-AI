const mysql = require('mysql2/promise');

async function createTable() {
  const connection = await mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'online_exam'
  });

  try {
    const sql = `CREATE TABLE IF NOT EXISTS student_exams (
        id INT AUTO_INCREMENT PRIMARY KEY,
        student_id VARCHAR(50) NOT NULL,
        exam_id INT NOT NULL,
        started_at DATETIME NOT NULL,
        status ENUM('started', 'completed', 'blocked') DEFAULT 'started',
        demerit_points INT DEFAULT 0,
        block_until DATETIME DEFAULT NULL,
        score INT DEFAULT 0,
        FOREIGN KEY (student_id) REFERENCES students(id),
        FOREIGN KEY (exam_id) REFERENCES exams(id)
    )`;
    await connection.execute(sql);
    console.log("Table student_exams created successfully");
  } catch (error) {
    console.error("Error creating table:", error);
  } finally {
    await connection.end();
  }
}

createTable();
