const pool = require('./src/config/db');

async function alterTables() {
  try {
    console.log('Altering admins table...');
    await pool.query('ALTER TABLE admins ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL, ADD COLUMN reset_token_expiry DATETIME DEFAULT NULL');
  } catch (err) {
    console.log('Admins table alter error:', err.message);
  }
  
  try {
    console.log('Altering teachers table...');
    await pool.query('ALTER TABLE teachers ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL, ADD COLUMN reset_token_expiry DATETIME DEFAULT NULL');
  } catch (err) {
    console.log('Teachers table alter error:', err.message);
  }
  
  try {
    console.log('Altering students table...');
    await pool.query('ALTER TABLE students ADD COLUMN reset_token VARCHAR(255) DEFAULT NULL, ADD COLUMN reset_token_expiry DATETIME DEFAULT NULL');
  } catch (err) {
    console.log('Students table alter error:', err.message);
  }
  
  console.log('Done altering tables.');
  process.exit(0);
}

alterTables();
