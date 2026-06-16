const mysql = require('mysql2/promise');

async function test() {
  try {
    const pool = mysql.createPool({
      host: 'localhost',
      user: 'root',
      password: '',
      database: 'online_exam',
    });
    
    const [rows] = await pool.query('SELECT * FROM admins');
    console.log("Admins:");
    console.log(rows);
    process.exit(0);
  } catch (err) {
    console.error("DB Error:", err.message);
    process.exit(1);
  }
}

test();
