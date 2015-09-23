@echo off
echo starting...
:loop
rem Get start time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "start=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)
IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\node_modules\gulp\bin\gulp.js" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\node_modules\gulp\bin\gulp.js" %*
)

rem Get end time:
for /F "tokens=1-4 delims=:.," %%a in ("%time%") do (
   set /A "end=(((%%a*60)+1%%b %% 100)*60+1%%c %% 100)*100+1%%d %% 100"
)

rem Get elapsed time:
set /A elapsed=end-start

if %elapsed% GTR 200 (
  rem ran for more than 2 seconds
  echo Gulp ran for %elapsed%0 ms, which is more than 2 seconds.  Waiting for 1 second and running again...
  sleep 1
  echo looping
  goto loop
)
echo Gulp ran for %elapsed%0 ms, which is less than 2 seconds - exiting loop
