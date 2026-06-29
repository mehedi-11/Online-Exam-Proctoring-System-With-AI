const db = require('./src/config/db');

async function createTable() {
  try {
    console.log('Creating login_attempts table...');
    await db.query(`
      CREATE TABLE IF NOT EXISTS login_attempts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        identifier VARCHAR(100) UNIQUE,
        failed_count INT DEFAULT 0,
        blocked_until DATETIME DEFAULT NULL
      );
    `);
    console.log('Table created successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error creating table:', error);
    process.exit(1);
  }
}

createTable();
