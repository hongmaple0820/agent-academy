@echo off
chcp 65001 >nul
echo ========================================
echo   Agent Academy 多平台推送脚本
echo ========================================
echo.

cd /d e:\project\openclaw\agent-academy

echo [1/2] 推送到 GitHub...
git push github master
if %errorlevel% neq 0 (
    echo GitHub 推送失败！
    echo 可能原因：SSH 密钥未添加到 GitHub
    echo 请访问：https://github.com/settings/keys
) else (
    echo GitHub 推送成功！
)

echo.
echo [2/2] 推送到 GitCode...
git push gitcode master
if %errorlevel% neq 0 (
    echo GitCode 推送失败！
    echo 可能原因：SSH 密钥未添加到 GitCode
) else (
    echo GitCode 推送成功！
)

echo.
echo ========================================
echo   推送完成！
echo ========================================
echo.
echo 项目地址：
echo - Gitee:   https://gitee.com/hongmaple/agent-academy
echo - GitHub:  https://github.com/hongmaple0820/agent-academy
echo - GitCode: https://gitcode.com/maple168/agent-academy
echo.
pause
