@ echo off
FOR /F "usebackq" %%i IN (`hostname`) DO SET HSTNM=%%i
PsExec.exe -i -d -s @..\computers.txt cmd.exe /c \\%HSTNM%\%1\exec.bat %HSTNM% %1 