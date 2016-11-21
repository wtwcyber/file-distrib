On Error Resume Next
Const ForReading = 1
Const computers = "Computers.txt"
Dim fso, f, FolderPath
Dim arrComputers()
Dim iUpperBound
dim fileName,REG_LOC1,REG_LOC2

Dim shell : Set shell = WScript.CreateObject("WScript.Shell")
i=0
FolderPath = Shell.CurrentDirectory
Count = Len(FolderPath)
Result = InStrRev(FolderPath, "\")
FolderPath = Right(FolderPath,Count-Result)
  
' Prepare to read the CompNames.txt file into an array
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


For Each strComputer In arrComputers
    err.clear
    Set objRegistry = GetObject _
        ("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
  
    if (Err.number = 0) then
        MessageDid = MessageDid & vbCrLf & vbTab & strComputer
        Set objWMIService = GetObject("winmgmts:{impersonationLevel=impersonate,(Shutdown)}!\\" & _
            strComputer & "\root\cimv2")
        Set colOperatingSystems = objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
	For Each objOperatingSystem in colOperatingSystems
    	    ObjOperatingSystem.Reboot()    ' or Shutdown(1)
	Next

    Else
        MessageDidnt = MessageDidnt & vbCrLf & vbTab & strComputer    
    End If
Next

If MessageDidnt = "" Then
	wscript.echo "'" & FolderPath & "' computers finished running the Reboot Script." & vbCrLf & MessageDid
Else
	wscript.echo "'" & FolderPath & "' computers finished running the SOL Script." & vbCrLf & "These computers didn't respond:" & MessageDidnt  & _
				vbCrLf & vbCrLf & "These computers did:" & MessageDid
End If













