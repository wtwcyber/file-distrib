echo Starting...
mkdir C:\CyberPatriot\Scripts
mkdir C:\CyberPatriot\Temp
mkdir C:\CyberPatriot\Recv

robocopy \\$($args[0])\$($args[1]) C:\CyberPatriot\Scripts /E
C:\CyberPatriot\Scripts\uftp\uftpd.exe -T C:\CyberPatriot\Temp -D C:\CyberPatriot\Recv
echo UFTP Complete!
pause > nul
