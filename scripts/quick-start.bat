@echo off
echo 🎯 GitHub Heatmap Generator - Quick Start
echo ========================================

echo.
echo Setting up GitHub Heatmap Generator...
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

echo ✅ Node.js is installed

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git is not installed. Please install Git first.
    echo Download from: https://git-scm.com/
    pause
    exit /b 1
)

echo ✅ Git is installed

REM Install dependencies
echo.
echo 📦 Installing dependencies...
npm install

echo.
echo 🚀 Ready to go! Here are your options:
echo.
echo 1. Make 3 commits today:     npm run daily
echo 2. Make 5 commits today:     node github-heatmap.js daily 5
echo 3. Schedule commits:         npm run schedule
echo 4. Fill past week:          npm run past-week
echo 5. Make single commit:      npm run single
echo 6. Show stats:              npm run stats
echo.
echo 💡 Tip: Run 'npm run daily' every morning for best results!
echo.

pause
