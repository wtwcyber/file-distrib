@echo off

echo Copying file...
copy %2 computers.txt
echo Done!
echo.

echo Running auto-yoda...
start /W cscript.exe auto-yoda.vbs
echo Done!
echo.

echo Creating network share...
start /W cscript.exe execRunas.vbs
echo Done!
echo.

echo Please press any key when the computers have finished rebooting
pause > nul
echo Continuing!
echo.

echo Running PSExec...
FOR /F "usebackq" %%i IN (`hostname`) DO SET HSTNM=%%i
REM start /W PSTools\PsExec.exe -i -d -s @computers.txt powershell.exe \\%HSTNM%\CPShare\exec.ps1 %HSTNM% CPShare
start /W PSTools\PsExec.exe -i -d -s @computers.txt cmd.exe /c \\%HSTNM%\CPShare\exec.bat %HSTNM% CPShare
echo Done!
echo.

echo Please press any key when the computers have finished copying
pause > nul
echo Continuing!
echo.

echo Running UFTP...
start /W Shared\uftp\uftp.exe -C tfmcc %1
echo Done!
echo.

echo Undoing yoda...
start /W cscript.exe auto-undo.vbs
echo Done!
echo.

echo Reboot computers? (Y/N)
set INPUT=
set /P INPUT=Type input: %=%
IF /I "%INPUT%"=="n" EXIT /B
start /W cscript.exe reboot-remote.vbs
echo Done!
echo.

echo Removing computers.txt...
del computers.txt
echo Done!
echo.