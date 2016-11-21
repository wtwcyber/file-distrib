Notes:
   I have included batch files to make this easier:
      PSTools\runPSE.bat 
         Will run PsExec on all hostnames in computers.txt. PsExec will then run Shared\exec.bat.
         Accepts one argument, the name you've given the net share. By default, Windows will use "Shared", so use this as the argument if you didn't change it.
      PSTools\runUFTP.bat 
         Will run UFTP as a server. 
         Accepts one argument, the name of a file to distribute.
      auto-everything.bat
         Accepts two arguments, in this order: file to distribute, destination computers
         Example: auto-everything.bat image.zip B112.txt
      

   The normal procedure is:
      Rename a room to "computers.txt"
      Run auto-yoda
      Use runPSE.bat
      Use runUFTP.bat
      Run auto-undo
      Run reboot-remote (to log out)
      Rename "computers.txt" back to the room number

   Or, to do everything all at once, use auto-everything.bat
      Note that this option does EVERYTHING - no need to auto-yoda or rename files ahead of time

GL!
