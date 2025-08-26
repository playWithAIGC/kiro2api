@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title 启动 Kiro（符号链接版，支持 .kiro 和 .aws）

set "APP_EXE=kiro.exe"
set "TARGET=%~dp0data"

:: 要重定向的源目录
set "SOURCES=.kiro .aws"

:: 创建目标 data 文件夹
if not exist "%TARGET%" mkdir "%TARGET%"

:: 遍历每个源目录
for %%D in (%SOURCES%) do (
    set "SRC=%USERPROFILE%\%%D"
    set "TARGET_DIR=%TARGET%\%%D"
    
    :: 创建目标子目录
    if not exist "!TARGET_DIR!" mkdir "!TARGET_DIR!"
    
    :: 检查是否已经是符号链接
    dir "!SRC!" 2>nul | find "SYMLINKD" >nul
    if errorlevel 1 (
        :: 不是符号链接
        if exist "!SRC!" (
            echo 迁移 %%D 数据...
            robocopy "!SRC!" "!TARGET_DIR!" /E /MOVE
            if exist "!SRC!" rmdir "!SRC!" /S /Q
        )
        echo 创建符号链接 %%D...
        mklink /D "!SRC!" "!TARGET_DIR!"
    ) else (
        echo 符号链接 %%D 已存在，无需迁移
    )
)

:: 启动程序
pushd "%~dp0"
start "" "%APP_EXE%"
popd

echo 完成！
pause
exit