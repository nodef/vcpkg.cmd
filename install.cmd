@echo off
@setlocal enabledelayedexpansion
set "REPO=https://github.com/Microsoft/vcpkg"
set "TEMP_DIR=temp"


:: We want to download vcpkg in the current directory
:: 1. Download the repo to a temp folder
git --version >nul 2>&1
if "%errorlevel%" neq "0" (
  echo Git is not installed. Please install Git and ensure it is in your PATH.
  exit /b 1
)
git clone %REPO% "%TEMP_DIR%" --depth 1
:: 2. Move the contents of the temp folder to the current directory
robocopy /? >nul 2>&1
if "%errorlevel%"=="0" (
  robocopy "%TEMP_DIR%" . /e /move /nfl /ndl /njh /njs /np /nc /ns /xd "%TEMP_DIR%\.git"
)
else (
  for /d %%D in ("%TEMP_DIR%\*") do (
    if /i not "%%~nxD"==".git" move "%%D" .
  )
  for %%F in ("%TEMP_DIR%\*") do (
    if /i not "%%~nxF"==".git" move "%%F" .
  )
)
if exist "%TEMP_DIR%\" (
  rmdir /i /q "%TEMP_DIR%"
)


:: Now, lets install vcpkg
bootstrap-vcpkg -disableMetrics
vcpkg integrate install
