@echo off
title Import Database - TeachTech
echo Importing database.sql into MySQL...
echo.
E:\xampp\mysql\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS online_exam; USE online_exam; source database.sql;"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo Database imported successfully!
    echo You can now run start-servers.bat
) else (
    echo.
    echo Error importing database. Make sure XAMPP MySQL is running.
)
echo.
pause
