@ECHO OFF
SET dir_home=%~dp0

goto selection

:selection
color 2
cls
ECHO.
ECHO Welcome to the KCS setup utility, your computer info:
ECHO.
wmic computersystem get model,name,manufacturer,systemtype,domain
ECHO Welcome to the ORGANIZATION NAME setup utility, you're making changes to %computername%
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO 1) Join Domain
ECHO 2) Enable Wake-on-LAN
ECHO 3) Install LANschool
ECHO 4) Automate Shutdown
ECHO 5) Shutdown
ECHO 6) Exit
ECHO.
ECHO M for more options
ECHO.
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO.
SET /P option="What would you like to do: "
if %option% == 1 (goto domain)
if %option% == 2 (goto wol)
if %option% == 3 (goto lanschool)
if %option% == 4 (goto autoshutdown)
if %option% == 5 shutdown /s /f /t 0
if %option% == 6 EXIT
if %option% == m (goto options)
if %option% == M (goto options)
ECHO.
ECHO Unknown value
pause
goto selection

:domain
cls
ECHO.
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO Running Powershell script to join to Domain
Powershell.exe -ExecutionPolicy Unrestricted -File %dir_home%\domain_super_pally_script_9000.ps1
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO.
PAUSE
goto selection

:wol
cls
ECHO.
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO Installing WOL features
Powershell.exe -ExecutionPolicy Unrestricted -File %dir_home%\WOL_enabler.ps1
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO.
PAUSE
goto selection

:lanschool
cls
ECHO.
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO Installing LANschool
SET /P channel="channel number: "
Msiexec.exe /i %dir_home%\student.msi /passive ADVANCED_OPTIONS=1 STEALTH_MODE=1 CHANNEL=%channel%
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO.
PAUSE
goto selection

:autoshutdown
cls
ECHO.
ECHO ----------------------------------------------------------------------------------------------------------------------
ECHO Format example: 18:00
ECHO ----------------------------------------------------------------------------------------------------------------------
SET /P time="Shutdown time:"
schtasks /create /sc daily /tn "auto shutdown my computer daily" /tr "shutdown -s" /st %time%
PAUSE
goto selection

:options
color 4
cls
ECHO.
ECHO **********************************************************************************************************************
ECHO 1) Rename computer
ECHO 2) Scan for problems
ECHO 3) How long have I been left on?
ECHO 4) Stop shutdown


ECHO.
ECHO B to go back
ECHO.
ECHO *********************************************************************************************************************
ECHO .
SET /P option="What would you like to do: "
if %option% == 1 (goto rename)
if %option% == 2 (goto troubleshoot)
if %option% == 3 (goto bootime)
if %option% == 4 shutdown /a
if %option% == B (goto selection)
if %option% == b (goto selection)
ECHO.
ECHO Unknown value
pause
goto options

:rename
cls
ECHO.
ECHO **********************************************************************************************************************
ECHO Rename will happen after restart
ECHO **********************************************************************************************************************
ECHO.
ECHO Current name: %computername%
SET /P newname="New name: "
WMIC computersystem where caption='%computername%' rename %newname%
ECHO.
PAUSE
goto options

:troubleshoot
cls
ECHO.
ECHO **********************************************************************************************************************
sfc /scannow
ECHO **********************************************************************************************************************
ECHO.
PAUSE
goto options

:bootime
cls
ECHO.
ECHO **********************************************************************************************************************
systeminfo | find "Boot Time"
ECHO **********************************************************************************************************************
ECHO.
PAUSE
goto options
