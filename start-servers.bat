@echo off
title TeachTech - Online Exam Platform Launcher
color 0A
echo.
echo  ============================================
echo    TeachTech - Online Exam Platform
echo    Starting Development Servers...
echo  ============================================
echo.

echo [1/2] Starting Backend API Server (Port 5000)...
start "TeachTech Backend - Port 5000" cmd /k "cd /d E:\xampp\htdocs\Online exam\backend && npm run dev"

timeout /t 2 /nobreak >nul

echo [2/2] Starting Frontend Dev Server (Port 5173)...
start "TeachTech Frontend - Port 5173" cmd /k "cd /d E:\xampp\htdocs\Online exam\frontend && npm run dev"

echo.
echo  ============================================
echo    Both servers launching in new windows!
echo.
echo    Backend:  http://localhost:5000
echo    Frontend: http://localhost:5173
echo.
echo    Admin Login:
echo      Email:    admin@exam.com
echo      Password: admin123
echo.
echo    Sample Student Login:
echo      ID:       STU2001
echo      Password: pass2001
echo  ============================================
echo.
pause
