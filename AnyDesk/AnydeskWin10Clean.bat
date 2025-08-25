@ECHO OFF

TITLE Generate A New AnyDesk ID



@ECHO Disabling the AnyDesk service...

SC.exe stop AnyDesk >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= // >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= //// >NUL 2>&1
SC.exe failure AnyDesk reset= 86400 actions= ////// >NUL 2>&1
SC.exe config AnyDesk start= disabled >NUL 2>&1



@ECHO Killing the AnyDesk process...

TASKKILL.exe /F /IM AnyDesk.exe /T >NUL 2>&1



@ECHO Deleting AnyDesk settings in ProgramData...

TAKEOWN.exe /F "%ProgramData%\AnyDesk" /A /R /D Y >NUL 2>&1
ICACLS.exe "%ProgramData%\AnyDesk" /T /C /Q /GRANT Administrators:F System:F Everyone:F >NUL 2>&1
RMDIR "%ProgramData%\AnyDesk" /S /Q >NUL 2>&1
RD "%ProgramData%\AnyDesk" /S /Q >NUL 2>&1



@ECHO Deleting AnyDesk settings in local user accounts...

FOR /F "tokens=2,*" %%A IN ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" /s /v ProfileImagePath ^| FIND "ProfileImagePath"') DO (
    IF EXIST "%%B\AppData\Roaming\AnyDesk" (
        TAKEOWN.exe /F "%%B\AppData\Roaming\AnyDesk" /A /R /D Y >NUL 2>&1
        ICACLS.exe "%%B\AppData\Roaming\AnyDesk" /T /C /Q /GRANT Administrators:F System:F Everyone:F >NUL 2>&1
        RMDIR "%%B\AppData\Roaming\AnyDesk" /S /Q >NUL 2>&1
    )
)



@ECHO Enabling the AnyDesk service...

SC.exe config AnyDesk start= auto >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0 >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0/restart/0 >NUL 2>&1
SC.exe failure AnyDesk reset= 0 actions= restart/0/restart/0/restart/0 >NUL 2>&1
SC.exe start AnyDesk >NUL 2>&1



@ECHO Starting the AnyDesk process...

IF "%PROCESSOR_ARCHITECTURE%"=="AMD64" GOTO 64BIT
IF "%PROCESSOR_ARCHITECTURE%"=="x86" GOTO 32BIT

@ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
@ECHO ^| This OS architecture is not supported!                            ^|
@ECHO ^+^=^=^=^=^=^==^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
PAUSE
GOTO END



:64BIT

IF EXIST "C:\Program Files (x86)\AnyDesk" (
    CD "C:\Program Files (x86)\AnyDesk" >NUL 2>&1
    START AnyDesk.exe >NUL 2>&1
    GOTO END >NUL 2>&1
    ) ELSE GOTO ADINF



:32BIT

IF EXIST "C:\Program Files\AnyDesk" (
    CD "C:\Program Files\AnyDesk" >NUL 2>&1
    START AnyDesk.exe >NUL 2>&1
    GOTO END >NUL 2>&1
    ) ELSE GOTO ADINF



:ADINF

@ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+
@ECHO ^| Seems like AnyDesk is not installed or it's not installed in the  ^|
@ECHO ^| default installation directory. You will have to start AnyDesk    ^|
@ECHO ^| manually, wherever it may reside.                                 ^|
@ECHO ^+^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^=^+

PAUSE



:END

@ECHO Done!
PAUSE
