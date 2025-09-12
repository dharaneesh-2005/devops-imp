@echo off
REM GitHub Heatmap Scheduler for Windows
REM This script runs the heatmap generator at scheduled intervals

echo Starting GitHub Heatmap Scheduler...
echo Press Ctrl+C to stop

:loop
REM Make a commit
node github-heatmap.js single

REM Wait for 2-4 hours (randomized)
set /a delay=%RANDOM% %% 7200 + 7200
echo Waiting %delay% seconds until next commit...

timeout /t %delay% /nobreak >nul
goto loop
