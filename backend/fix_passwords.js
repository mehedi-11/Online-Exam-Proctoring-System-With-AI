const bcrypt = require('bcryptjs');
const mysql = require('mysql2/promise');

async function fixPasswords() {
  try {
    const pool = mysql.createPool({
      host: 'localhost',
      user: 'root',
      password: '',
      database: 'online_exam',
    });

    console.log("Generating new hashes...");
    const adminHash = await bcrypt.hash('admin123', 10);
    const teacherHash = await bcrypt.hash('teacher123', 10);
    const studentHash = await bcrypt.hash('student123', 10);

    console.log("Updating database...");
    await pool.query('UPDATE admins SET password = ? WHERE email = ?', [adminHash, 'admin@exam.com']);
    await pool.query('UPDATE teachers SET password = ? WHERE email = ?', [teacherHash, 'teacher@exam.com']);
    await pool.query('UPDATE students SET password = ? WHERE id = ?', [studentHash, 'student123']);
    await pool.query('UPDATE students SET password = ? WHERE id = ?', [studentHash, 'STU1001']);

    console.log("===================================");
    console.log("✅ Passwords updated successfully!");
    console.log("You can now login with:");
    console.log("Admin: admin@exam.com / admin123");
    console.log("===================================");
    
    process.exit(0);
  } catch (error) {
    console.error("Error:", error);
    process.exit(1);
  }
}

fixPasswords();
