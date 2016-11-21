dim fso: set fso = CreateObject("Scripting.FileSystemObject")
dim CurrentDirectory
CurrentDirectory = fso.GetAbsolutePathName(".")
dim Directory
Directory = fso.BuildPath(CurrentDirectory, "Shared")
Set objShell = CreateObject("Shell.Application")
objShell.ShellExecute "PSTools\netsharer.bat", Directory, "", "runas", 1