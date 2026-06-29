const jwt = require('jsonwebtoken');
require('dotenv').config();

const token = jwt.sign({ id: 1, email: 'test@test.com', role: 'teacher' }, process.env.JWT_SECRET, { expiresIn: '1h' });

const test = async () => {
  const lRes = await fetch('http://localhost:5000/api/teacher/proctoring-logs', {
    headers: { Authorization: `Bearer ${token}` }
  });
  console.log('teacher logs status:', lRes.status);
  
  const rRes = await fetch('http://localhost:5000/api/proctor/raw-logs', {
    headers: { Authorization: `Bearer ${token}` }
  });
  console.log('raw logs status:', rRes.status);
};

test();
