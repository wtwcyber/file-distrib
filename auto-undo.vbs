On Error Resume Next
Const ForReading = 1
Const computers = "Computers.txt"
Dim fso, f, FolderPath, NoticeA, NoticeB
Dim arrComputers()
Dim iUpperBound
dim fileName,REG_LOC1,REG_LOC2,Restpath,REG_LOC3
REG_LOC1 = "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
REG_LOC2 = "SOFTWARE\Microsoft\Windows\CurrentVersion\policies\system"
REG_LOC3 = "SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell"
Dim shell : Set shell = WScript.CreateObject("WScript.Shell")
i=0
FolderPath = Shell.CurrentDirectory
Count = Len(FolderPath)
Result = InStrRev(FolderPath, "\")
FolderPath = Right(FolderPath,Count-Result)
NoticeA = "This system is the property of Fairfax County Public Schools (FCPS)." & vbnewline & "Any attempt to break into this computer unlawfully copy software or unlawfully" & vbnewline & _ 
"use a Local Area Network (LAN) or the Wide Area network (WAN) will be"  & vbnewline & "treated as a violation of state and federal statutes regarding unauthorized"  & vbnewline & _
"use of computing resources" & vbnewline & "All systems and networks are closely monitored by FCPS data security" & vbnewline & "personnel for unauthorized use or suspicious access and attacks." & vbnewline & "Violations will be reported to the Fairfax County Police, the Virginia State" & vbnewline
NoticeB = "Police, the FBI and other appropriate organizations and legal authorities " & vbnewline & "for investigation and prosecution."
  
  
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
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultUserName",""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AltDefaultUserName",""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultPassword",""
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AutoAdminLogon","0"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "ForceAutoLogon","0"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "DefaultDomainName","FCPSEDU"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "AltDefaultDomainName","FCPSEDU"
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC2, "dontdisplaylastusername",1
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC1, "DisableCAD",0
     objRegistry.SetDWORDValue HKEY_LOCAL_MACHINE, REG_LOC2, "DisableLockWorkstation",1
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC2, "legalnoticecaption", "WARNING!"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC2, "legalnoticetext", NoticeA & NoticeB
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "legalnoticecaption", "WARNING!"
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC1, "legalnoticetext", NoticeA & NoticeB
     objRegistry.SetStringValue HKEY_LOCAL_MACHINE, REG_LOC3, "ExecutionPolicy", "Restricted"
  Else
     MessageDidnt = MessageDidnt & vbCrLf & vbTab & strComputer    
  End If
shell.Popup "'" & FolderPath & "' computers finished running the SOL Script." & vbCrLf & "These computers didn't respond:" & MessageDidnt  & _
				vbCrLf & vbCrLf & "These computers did:" & MessageDid , 1,"Message", 0 + 64
Next
If MessageDidnt = "" Then
	wscript.echo "'" & FolderPath & "' computers finished running the Undo-SOL Script." & vbCrLf & MessageDid
Else
	wscript.echo "'" & FolderPath & "' computers finished running the Undo-SOL Script." & vbCrLf & "These computers didn't respond:" & MessageDidnt  & _
				vbCrLf & vbCrLf & "These computers did:" & MessageDid
End If