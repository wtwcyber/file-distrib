On Error Resume Next
Const ForReading = 1
Const computers = "Computers.txt"
Dim fso, f, FolderPath
Dim arrComputers()
Dim iUpperBound
dim fileName,REG_LOC1,REG_LOC2,REG_LOC3
REG_LOC1 = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
REG_LOC2 = "SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system"
REG_LOC3 = "SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
pass = InputBox("Enter yoda's password")

Dim shell : Set shell = WScript.CreateObject("WScript.Shell")
i=0
FolderPath = Shell.CurrentDirectory
Count = Len(FolderPath)
Result = InStrRev(FolderPath, "\")
FolderPath = Right(FolderPath,Count-Result)
  
' Prepare to read the CompNames.txt file into an aray
Set fso = CreateObject("Scripting.FileSystemObject")
Set f = fso.OpenTextFile(computers, ForReading)

' Read the file line by line, and add each line to the array.
iUpperBound = 0
While Not f.AtEndOfStream
   ReDim Preserve arrComputers(iUpperBound)
   arrComputers(UBound(arrComputers)) = f.ReadLine
   iUpperBound = iUpperBound + 1
Wend 

f.Close

Const HKEY_LOCAL_MACHINE = &H80000002

For Each strComputer In arrComputers
    err.clear
  Set objRegistry = GetObject _
    ("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
  
  if (Err.number = 0) then
     MessageDid = MessageDid & vbCrLf & vbTab & strComputer
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC2, "DisableLockWorkstation",1
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultUserName","yoda"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AltDefaultUserName",pass
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultPassword",pass
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AutoAdminLogon","1"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "ForceAutoLogon","1"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultDomainName","FCPSEDU"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AltDefaultDomainName","FCPSEDU"
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC1, "DisableCAD",1
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC2, "Dontdisplaylastusername",0
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC2, "legalnoticecaption", ""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC2, "legalnoticetext", ""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "legalnoticetext", ""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "LegalNoticeCaption", ""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC3, "ExecutionPolicy", "Unrestricted"
     Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate,(Shutdown)}!\\" & _
        strComputer & "\root\cimv2")
     Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
	For Each objOperatingSystem in colOperatingSystems
	   ObjOperatingSystem.Reboot()    ' or Shutdown(1)
	Next
  Else
     MessageDidnt = MessageDidnt & vbCrLf & vbTab & strComputer    
  End If
shell.Popup "'" & FolderPath & "' computers finished running the SOL Script." & vbCrLf & "These computers didn't respond:" & MessageDidnt  & _
				vbCrLf & vbCrLf & "These computers did:" & MessageDid , 1,"Message", 0 + 64
Next

If MessageDidnt = "" Then
	wscript.echo "'" & FolderPath & "' computers finished running the SOL Script." & vbCrLf & MessageDid
Else
	wscript.echo "'" & FolderPath & "' computers finished running the SOL Script." & vbCrLf & "These computers didn't respond:" & MessageDidnt  & _
				vbCrLf & vbCrLf & "These computers did:" & MessageDid
End If

