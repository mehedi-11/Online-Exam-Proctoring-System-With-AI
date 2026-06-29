const db = require('./src/config/db');

async function alterTable() {
  try {
    console.log('Adding block_until column to student_exams table...');
    await db.query(`
      ALTER TABLE student_exams 
      ADD COLUMN block_until DATETIME DEFAULT NULL;
    `);
    console.log('Column added successfully!');
    process.exit(0);
  } catch (error) {
    console.error('Error altering table:', error);
    process.exit(1);
  }
}

alterTable();
