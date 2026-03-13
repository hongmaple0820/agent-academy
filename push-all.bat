@echo off
echo ========================================
echo   Agent Academy - Push to All Platforms
echo ========================================
echo.

cd /d e:\project\openclaw\agent-academy

echo [1/2] Pushing to GitHub...
git push github master
if %errorlevel% neq 0 (
    echo Failed to push to GitHub!
) else (
    echo GitHub push completed!
)

echo.
echo [2/2] Pushing to GitCode...
git push gitcode master
if %errorlevel% neq 0 (
    echo Failed to push to GitCode!
) else (
    echo GitCode push completed!
)

echo.
echo ========================================
echo   Done!
echo ========================================
pause
