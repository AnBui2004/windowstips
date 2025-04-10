@echo off
fsutil dirty query %systemdrive% >nul || (
    echo Requesting administrative privileges...
    set "ELEVATE_CMDLINE=cd /d "%cd%" & call "%~f0" %*"
    findstr "^:::" "%~sf0">"%temp%\getadmin.vbs"
    cscript //nologo "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs" & exit /b
)

rem ------- getadmin.vbs ----------------------------------
::: Set objShell = CreateObject("Shell.Application")
::: Set objWshShell = WScript.CreateObject("WScript.Shell")
::: Set objWshProcessEnv = objWshShell.Environment("PROCESS")
::: strCommandLine = Trim(objWshProcessEnv("ELEVATE_CMDLINE"))
::: objShell.ShellExecute "cmd", "/c " & strCommandLine, "", "runas"
rem -------------------------------------------------------

echo Running script as admin.
echo Script file : %~f0
echo Arguments   : %*
echo Working dir : %cd%
echo.
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $true"
curl -L --output Remove-Edge.exe "https://github.com/ShadowWhisperer/Remove-MS-Edge/blob/main/Remove-Edge.exe?raw=true"
Remove-Edge.exe
del Remove-Edge.exe
powershell -command "Set-MpPreference -DisableRealtimeMonitoring $false"