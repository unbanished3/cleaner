@echo off
SetLocal EnableExtensions EnableDelayedExpansion

for /f "tokens=2 delims=[]" %%i in ('ver') do (@for /f "tokens=2 delims=. " %%a in ("%%i") do set "nka=%%a") 
if %nka% LEQ 5 (call :WINXP & exit /b 1)

reg query "HKEY_USERS\S-1-5-19\Environment" /v TEMP 2>&1 | findstr /I /C:"REG_EXPAND_SZ" 2>&1 >nul || (
	if "%1"=="elevated" (call :NOADMIN & exit /b 1)
	echo CreateObject^("Shell.Application"^).ShellExecute WScript.Arguments^(0^),"elevated","","runas",1 >"%TEMP%\getadmin.vbs"
	wscript.exe //nologo "%TEMP%\getadmin.vbs" "%~dpnx0"
	del /a /f /q "%TEMP%\getadmin.vbs"
	exit /b
) 

title ���⪠ Windows. ���, ��� ��㣨� �� ᬮ���
mode con: cols=75 lines=36
color 1B
echo.
echo.
echo.
echo.
echo.
echo           ��� ���� �ਯ� ��� ���⪨ windows vista, 7, 8, 8.1, 10
echo.
echo                    ��� ����ன ���⪨ ���� �� ��᪥ C:
echo.
call :ECHO "                                                                           " 0C
call :ECHO "                     ����������� �� ���� ����� � ����                      " 0C
call :ECHO "                                                                           " 0C
echo.
echo.
echo.
echo.
echo            ���
echo          �߰ܰ��
echo          ۰��߰�
echo          ۰���������
echo         �����������
echo.
echo.
echo.
echo.
echo.
echo             ������ ���� �������, �⮡� ����� ����� ��⥬�

>nul pause

for /f "usebackq tokens=2 delims==" %%i in (
	`wmic.exe LogicalDisk where "Name='c:'" get FreeSpace /value`
) do set SIZE=%%i
set BEFORE=%SIZE:~0,-7%

:: ���� ᯥ�ᨬ����� � �����
:: �����, �� �뢠�� �㦥�
reg add "HKCR\batfile\shell\runas\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\cmd.exe /C \"\"%%1\" %%*\"" /f 2>nul 1>&2
reg add "HKCR\cmdfile\shell\runas\command" /ve /t REG_EXPAND_SZ /d "%%SystemRoot%%\System32\cmd.exe /C \"\"%%1\" %%*\"" /f 2>nul 1>&2

cls

REM #############################################################################################
REM ##############################   ����ன��   ################################################
REM #############################################################################################

:: �������� ��� ����� �祪 ����⠭������� (�᫨ ⠪�� ����)
call :CLEANRESTORE

:: �������� �窨 ����⠭������� ��। ���⪮�
:: call :CREATERESTORE

:: ��⠭���� �������� �㦡 �� �६� ���⪨ (४���������)
call :STOPSERVICES

:: ���⪠ ���짮��⥫�᪨� �६����� ����� � 䠩���
call :USERTEMP

:: ���⪠ ��� �������� windows � modern �ਫ������ (��� 8 � ���)
call :WSRESET

:: ���⪠ ��襩 ��㧥஢
call :BROWSERS

:: �������� �⠭������ ��ࠧ殢 ��모 � �먤�� �� ����� C:\Users\Public
call :DELMEDIA

:: ���⪠ �६����� ��४�਩ � ��� ��� Steam
:: � �������� ����� ����� ���� �஡���� �த� ����୮�� �⮡ࠦ���� ��࠭��
:: �� 㢫������� �� �⮨�
call :STEAM

:: ���⪠ ��� ࠧ����� ���ᨩ 1�
call :1C

:: ���⪠ ��⥬��� �६����� 䠩��� � �����
call :SYSTEMP

:: �������� ������ ���஢����� ������ �ਫ������, ⠪�� ��� ����, �����, 䠩�� ���������� � �. 
:: �ᯮ�������� ��� ���짮��⥫�᪨� ��४�਩.
call :PROGTEMP

:: ���⪠ WinSXS
call :WINSXS

:: ���⪠ ���ॢ�� ��������⮢ (����⮢ ����������) �� WinSXS
:: ����� ������� �祭� �����, ⮫쪮 ��� windows 8 � ���
call :WINSXS_COMPONENTS

:: �������� ������ ����� ���ᨩ windows (C:\Windows.old, C:\Windows.old.000, C:\Windows.old.001 � ⠪ �����)
call :WINOLD

:: ���⨥ ��� ��⠫�樮���� ����⮢
call :COMPRESSFILES

:: ���⨥ ��⠭���筮�� ��� MS Office (���� ��ᯮ�����)
call :MSOCACHEC

:: �������� �������� �६����� � "����ࠧ����" ��४�਩
:: ��⠢����, ���ਬ��, ��᫥ ��⠭���� �ࠩ��஢ 
call :REMOVEDIR

:: ���⪠ ��২�� �� ��⥬��� ��᪥
call :CLEANREC

:: ��㡮��� ���� �६����� 䠩��� �� ��᪥ C:
call :FINDMORE

:: ������������� ࠡ��� ��⠭�������� �㦡
call :STARTSERVICES

:: ���⪠ �� ����� cleanmgr.exe
:: ���� �ᯮ�짮���� �⤥�쭮, ⠪ ��� ����� �������� �ਫ�筮� �६�
call :CLEANMGR


REM #############################################################################################
REM ##############################   ����ன��   ################################################
REM #############################################################################################




for /f "usebackq tokens=2 delims==" %%i in (
	`wmic.exe LogicalDisk where "Name='c:'" get FreeSpace /value`
) do set SIZE=%%i
set AFTER=%SIZE:~0,-7%

set /a DIFFSIZE=%AFTER%-%BEFORE%

echo.
echo.
if "%SYSCLEANUP_KEY%"=="1" (
	call :ECHO "                ������������ ��१���㧨�� ��������" 1E
	echo 
) else (
	call :ECHO "                          ���⪠ �����襭�" 1A
	echo.
)
echo.
echo.
echo �᢮������� �ਬ�୮ %DIFFSIZE% ��
>nul pause
exit /b 0

:NOADMIN
mode con: cols=70 lines=20
color 0E
title �� 㤠���� ������� �ࠢ� �����������
echo.
echo.
echo               �� 㤠���� ������� �ࠢ� ����������� 
echo                    ���⪠ �� �㤥� �ந�������
echo.
echo             ��१������ �ਯ� � �ࠢ��� �����������
echo.
echo.
>nul pause
exit /b 1


:WINXP
mode con: cols=70 lines=20
color 0E
title ����樮���� ��⥬� �� �����ন������
echo.
echo.
echo             ��� ����樮���� ��⥬� �� �����ন������ 
echo                    ���⪠ �� �㤥� �ந�������
echo.
>nul pause
exit /b 1


:CLEANRESTORE
<nul set /p "T= �������� �祪 ����⠭������� � ⥭���� �����                 :"
vssadmin delete shadows /for=%SYSTEMDRIVE% /all /quiet 2>nul 1>&2

if "!ERRORLEVEL!"=="0" call :ECHO "Done" 1A&echo.
if "!ERRORLEVEL!"=="1" call :ECHO "Empty" 1E&echo.
if "!ERRORLEVEL!"=="2" call :ECHO "FAILED" 1C&echo 
exit /b


:CREATERESTORE
<nul set /p "T= �������� �窨 ����⠭�������                                 :"
cmd /c "wmic /namespace:\\root\default path systemrestore call enable %SYSTEMDRIVE%" 2>nul 1>&2
cmd /c "wmic /namespace:\\root\default path SystemRestore call CreateRestorePoint "���⪠ ��⥬� %DATE%", 100, 12" >nul

if "!ERRORLEVEL!" neq "0" (call :ECHO "FAILED" 1C&echo ) else (call :ECHO "Done" 1A&echo.)
REM call :ECHO "Done" 1A&echo.
exit /b


:STOPSERVICES
<nul set /p "T= �६����� �⠭���� ��⥬��� �㦡 ������ ���⪥           :"
set SERVICES=wuauserv BITS CryptSvc msiserver TrustedInstaller IEEtwCollectorService sppsvc "Windows Search"
for %%a in (%SERVICES%) do net stop %%a /y 2>nul 1>&2
set srv=1
call :ECHO "Done" 1A&echo.
exit /b


:USERTEMP
echo.���⪠ �६����� ��४�਩ ��� ��� ���짮��⥫��:
<nul set /p "T=���짮��⥫�: "
for /f "delims=" %%a in ('dir /b /ad-h "%userprofile%\..\*"^|findstr/ixvc:"All Users" /c:"Public" /c:"UpdatusUser" /c:"Default.migrated"') do (
	set N=0
	call :ECHO "%%~a " 1F
	call :USERTEMPMAIN "\..\%%a"
	if "!N!" GTR "0" (call :ECHO "Done   " 1A) else (call :ECHO "Empty  " 1E)
	set N=
)
echo.&echo.
exit /b

:USERTEMPMAIN
REM taskkill /f /im explorer.exe 2>nul 1>&2

for %%a in (
"%userprofile%%~1\Tracing"
"%userprofile%%~1\AppData\LocalLow\Unity\WebPlayer\Cache"
"%userprofile%%~1\AppData\Roaming\Macromedia\Flash Player"
"%userprofile%%~1\AppData\Roaming\uTorrent\updates"
"%userprofile%%~1\AppData\Local\TEMP"
"%userprofile%%~1\AppData\Local\Microsoft\Feeds Cache"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\Caches"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\Explorer"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\WER"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\INetCache"
"%userprofile%%~1\AppData\Local\Steam\htmlcache"
"%userprofile%%~1\AppData\Local\Adobe\Acrobat\9.0\Cache"
"%userprofile%%~1\AppData\Local\Adobe\Acrobat\10.0\Cache"
"%userprofile%%~1\AppData\Local\Adobe\Acrobat\11.0\Cache"
"%userprofile%%~1\AppData\Local\Facebook\Games\Cache"
"%userprofile%%~1\AppData\Local\Windows Live\.cache"
) do (call :EMPTD "%%~a")

(pushd "%userprofile%%~1\AppData\Local\NVIDIA\NvBackend"
for /f "tokens=1 delims=" %%d in ('dir /ad /b /s "Packages"') do call :EMPTD "%%~d"
popd)2>nul 1>&2

for %%a in (
"%userprofile%%~1\AppData\Local\Opera Software"
"%userprofile%%~1\AppData\Local\Google\Chrome"
) do (pushd "%%~a" && (del /a /f /s /q *.7z && (set /a N+=1) & popd))2>nul 1>&2

del /a /f /q "%userprofile%%~1\AppData\Local\IconCache.db" 2>nul 1>&2
REM start "" explorer.exe 2>nul 1>&2
exit /b


:WSRESET
ver | findstr /i "6.2. 6.3. 10.0." >nul && (
	<nul set /p "T= ���⪠ ��� windows store � modern �ਫ������                :"
	(taskkill /f /im WinStore.App.exe & WSReset.exe & timeout 1 & taskkill /f /im WinStore.App.exe)2>nul 1>&2
	call :ECHO "Done" 1A&echo.
)
exit /b


:BROWSERS
echo.���⪠ ��� ��⠭�������� ��㧥஢ ��� ��� ���짮��⥫��:
<nul set /p "T=���짮��⥫�: "

for /f "delims=" %%a in ('dir /b /ad-h "%userprofile%\..\*"^|findstr/ixvc:"All Users" /c:"Public" /c:"UpdatusUser" /c:"Default.migrated"') do (
	set N=0
	call :ECHO "%%~a " 1F
	call :BROWSERSMAIN "\..\%%a"
	if "!N!" GTR "0" (call :ECHO "Done   " 1A) else (call :ECHO "Empty  " 1E)
	set N=
)
echo.&echo.
exit /b

:BROWSERSMAIN
(
REM Internet Explorer

REM taskkill /f /im iexplore.exe
if "%~1"=="" start /wait "" RunDll32 InetCpl.cpl,ClearMyTracksByProcess 8

for %%a in (
"%userprofile%%~1\AppData\Local\Microsoft\Windows\Temporary Internet Files"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\WebCache"
"%userprofile%%~1\AppData\Local\Microsoft\Windows\WebCache.old"
) do (
	call :EMPTD "%%~a"
)


REM Firefox
if exist "%userprofile%%~1\AppData\Roaming\Mozilla\Firefox\profiles.ini" (
	REM taskkill /f /im firefox.exe
	for /f "tokens=2 delims=/" %%a in (
		'type "%userprofile%%~1\AppData\Roaming\Mozilla\Firefox\profiles.ini" ^|find /i "Path="'
	) do (
	call :EMPTD "%userprofile%%~1\AppData\Local\Mozilla\Firefox\Profiles\%%~a\cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Mozilla\Firefox\Profiles\%%~a\cache2"
	))


REM Palemoon
if exist "%userprofile%%~1\AppData\Roaming\Moonchild Productions\Pale Moon\profiles.ini" (
	REM taskkill /f /im palemoon.exe
	for /f "tokens=2 delims=/" %%a in (
		'type "%userprofile%%~1\AppData\Roaming\Moonchild Productions\Pale Moon\profiles.ini" ^|find /i "Path="'
	) do (
	call :EMPTD "%userprofile%%~1\AppData\Local\Moonchild Productions\Pale Moon\Profiles\%%~a\Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Moonchild Productions\Pale Moon\Profiles\%%~a\Cache"
	))


REM Chromium
if exist "%userprofile%%~1\AppData\Local\Chromium\User Data\" (
	REM taskkill /f /im chrome.exe

	call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\ShaderCache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\Default\Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\Default\GPUCache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\Default\Media Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\Default\Pepper Data"

	for /f "delims=" %%d in ('dir /b /ad "%userprofile%%~1\AppData\Local\Chromium\User Data\Profile*"') do (
		call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\%%d\Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\%%d\GPUCache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\%%d\Media Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Chromium\User Data\%%d\Pepper Data"
	))


REM Google Chrome
if exist "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\" (
	REM taskkill /f /im chrome.exe

	call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\ShaderCache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\Default\Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\Default\GPUCache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\Default\Media Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\Default\Pepper Data"

	call :EMPTD "%userprofile%%~1\AppData\Local\Google\CrashReports"

	for /f "delims=" %%d in ('dir /b /ad "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\Profile*"') do (
		call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\%%d\Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\%%d\GPUCache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\%%d\Media Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Google\Chrome\User Data\%%d\Pepper Data"
	))


REM Opera Presto & Blink
if exist "%userprofile%%~1\AppData\Local\Opera\" (
	REM taskkill /f /im opera.exe
	call :EMPTD "%userprofile%%~1\AppData\Local\Opera\opera x64\cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Opera\opera\cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Opera Software\Opera Stable\Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Opera Software\Opera Next\Cache"
	)


REM Yandex Browser
if exist "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\" (
	REM taskkill /f /im browser.exe

	call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\Default\Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\Default\GPUCache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\Default\Media Cache"
	call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\Default\Pepper Data"

	for /f "delims=" %%d in ('dir /b /ad "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\Profile*"') do (
		call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\%%d\Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\%%d\GPUCache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\%%d\Media Cache"
		call :EMPTD "%userprofile%%~1\AppData\Local\Yandex\YandexBrowser\User Data\%%d\Pepper Data"
	))

)2>nul 1>&2
exit /b


:STEAM
<nul set /p "T= ���⪠ ��४�਩ Steam                                      :"

set "key_x86=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam"
set "key_x64=HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Steam"

reg query "%key_x86%" >nul 2>&1 && (
	for /f "tokens=2,*" %%i in (
		'reg query %key_x86% /s ^| findstr /irc:"UninstallString"'
		) do set "STEAMDIR=%%~dpj"
		)


reg query "%key_x64%" >nul 2>&1 && (
	for /f "tokens=2,*" %%i in (
		'reg query %key_x64% /s ^| findstr /irc:"UninstallString"'
		) do set "STEAMDIR=%%~dpj"
		)

if not defined STEAMDIR call :ECHO "No Steam" 1E&echo.&exit /b

set N=0

for %%a in (
"%STEAMDIR%\dumps"
"%STEAMDIR%\logs"
"%STEAMDIR%\appcache\httpcache"
"%STEAMDIR%\Backups"
"%STEAMDIR%\depotcache"
) do (call :EMPTD "%%~a")

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
exit /b


:1C
<nul set /p "T= ���⪠ ��� 1� ��� ��� ���짮��⥫��                        :"
REM if not exist "%userprofile%\AppData\Roaming\1C" call :ECHO "No 1C" 1E&echo.&exit /b
if exist "%PROGRAMFILES%\1C*" set 1C=1
if exist "%PROGRAMFILES(x86)%\1C*" set 1C=1
if not defined 1C call :ECHO "No 1C" 1E&echo.&exit /b
echo.
<nul set /p "T=���짮��⥫�: "
for /f "delims=" %%a in ('dir /b /ad-h "%userprofile%\..\*"^|findstr/ixvc:"All Users" /c:"Public" /c:"UpdatusUser" /c:"Default.migrated"') do (
	set N=0
	call :ECHO "%%~a " 1F
	call :1CMAIN "\..\%%a"
	if "!N!" GTR "0" (call :ECHO "Done   " 1A) else (call :ECHO "Empty  " 1E)
	set N=
)
echo.&echo.
exit /b


:1CMAIN

for %%a in (
"%userprofile%%~1\AppData\Local\1C\1cv8"
"%userprofile%%~1\AppData\Local\1C\1cv82"
) do (
	pushd "%%~a"
	for /d %%b in ("????????-????-????-????-????????????") do (rd /s /q "%%~fb" && set /a N+=1)
	for /d %%b in ("dumps" "logs") do (call :EMPTD "%%~fb")
	popd
	)2>nul 1>&2

exit /b


:REMOVEDIR
<nul set /p "T= �������� ��४�਩ ���襭��� ��⠭��騪���                 :"

set N=0

for %%a in (
"%SYSTEMROOT%\Installer\$PatchCache$"
"%SYSTEMROOT%\SoftwareDistribution.old"
"%SYSTEMROOT%\SoftwareDistribution.bak"
"%SYSTEMDRIVE%\Config.Msi"
"%SYSTEMDRIVE%\$SysReset"
"%SYSTEMDRIVE%\found.*"
"%SYSTEMDRIVE%\$Windows.~BT"
"%SYSTEMDRIVE%\$Windows.~WS"
"%SYSTEMDRIVE%\$GetCurrent"
"%SYSTEMDRIVE%\Windows10Upgrade"
"%SYSTEMDRIVE%\ATI"
"%SYSTEMDRIVE%\AMD"
"%SYSTEMDRIVE%\INTEL"
"%SYSTEMDRIVE%\NVIDIA"
"%SYSTEMDRIVE%\SWSETUP"
"%SYSTEMDRIVE%\ESD"
) do (rd /s /q "%%~a" && set /a N+=1)2>nul 1>&2

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
set N=
exit /b



:DELMEDIA
<nul set /p "T= �������� �⠭������ ��ࠧ殢 �����                           :"

set N=0

for %%a in (
"%PUBLIC%\Recorded TV\Sample Media\win7_scenic-demoshort_raw.wtv"
"%PUBLIC%\Music\Sample Music\Kalimba.mp3"
"%PUBLIC%\Music\Sample Music\Maid with the Flaxen Hair.mp3"
"%PUBLIC%\Music\Sample Music\Sleep Away.mp3"
"%PUBLIC%\Videos\Sample Videos\Wildlife.wmv"
"%PUBLIC%\Pictures\Sample Pictures\Hydrangeas.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Koala.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Lighthouse.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Jellyfish.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Penguins.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Desert.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Tulips.jpg"
"%PUBLIC%\Pictures\Sample Pictures\Chrysanthemum.jpg"
) do (if exist "%%~a" (del /a /f /q "%%~a" & set /a N+=1))2>nul 1>&2

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
set N=
exit /b



:CLEANREC
<nul set /p "T= ���⪠ ��২�� �� ��⥬��� ��᪥                            :"
for %%a in (
"%SYSTEMDRIVE%\$RECYCLE.BIN"
"%SYSTEMDRIVE%\RECYCLER"
) do (rd /s /q "%%~a")2>nul 1>&2
call :ECHO "Done" 1A&echo.
exit /b


:SYSTEMP
<nul set /p "T= ���⪠ ��⥬��� �६����� ��४�਩                        :"

taskkill /f /im makecab.exe 2>nul 1>&2

set N=0

for %%a in (
"%SYSTEMDRIVE%\Temp"
"%SYSTEMDRIVE%\PerfLogs"
"%SYSTEMROOT%\Minidump"
"%SYSTEMROOT%\TEMP"
"%SYSTEMROOT%\Logs\CBS"
"%SYSTEMROOT%\Logs\DISM"
"%SYSTEMROOT%\debug"
"%SYSTEMROOT%\tracing"
"%SYSTEMROOT%\SoftwareDistribution\Download"
"%SYSTEMROOT%\SoftwareDistribution\SelfUpdate"
"%SYSTEMROOT%\ServiceProfiles\LocalService\AppData\Local\Temp"
"%SYSTEMROOT%\ServiceProfiles\NetworkService\AppData\Local\Temp"
"%SYSTEMROOT%\LiveKernelReports"
"%SYSTEMROOT%\System32\wdi\LogFiles"
"%SYSTEMROOT%\Minidump"
"%ALLUSERSPROFILE%\Microsoft\Windows Defender\Definition Updates"
"%ALLUSERSPROFILE%\Microsoft\Windows Defender\Scans"
"%ALLUSERSPROFILE%\Microsoft\Windows\WER"
"%ALLUSERSPROFILE%\USOShared\Logs"
"%ALLUSERSPROFILE%\Microsoft\Diagnosis"
"%ALLUSERSPROFILE%\Microsoft\Windows\Caches"
"%ALLUSERSPROFILE%\Microsoft\Windows\Power Efficiency Diagnostics"
"%ALLUSERSPROFILE%\Microsoft\Windows\Sqm"
"%ALLUSERSPROFILE%\Microsoft\Windows\DRM"
"%ALLUSERSPROFILE%\Microsoft\Search\Data\Applications\Windows"
) do (call :EMPTD "%%~a")

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
set N=
exit /b


:PROGTEMP
<nul set /p "T= ���⪠ ���஢����� ������ ࠧ����� �ணࠬ�                :"

set N=0

for %%a in (
"%ALLUSERSPROFILE%\NVIDIA Corporation\NetService"
"%ALLUSERSPROFILE%\NVIDIA Corporation\Downloader"
"%ALLUSERSPROFILE%\NVIDIA\Updatus"
"%ALLUSERSPROFILE%\Origin\SelfUpdate"
"%ALLUSERSPROFILE%\Kaspersky Lab"
"%ALLUSERSPROFILE%\Eset\Eset Nod32 Antivirus\updfiles\temp"
"%ALLUSERSPROFILE%\Eset\Eset Nod32 Antivirus\updfiles\oldfiles"
"%ALLUSERSPROFILE%\Blizzard Entertainment\Battle.net\Cache"
"%PROGRAMFILES%\Google\Update\Download"
"%PROGRAMFILES(x86)%\Google\Update\Download"
) do (call :EMPTD "%%~a")

for %%a in (
"%PROGRAMFILES%\Google\Chrome\Application"
"%PROGRAMFILES(x86)%\Google\Chrome\Application"
) do (pushd "%%~a" && (del /a /f /s /q *.7z && (set /a N+=1) & popd))2>nul 1>&2

pushd "%SYSTEMDRIVE%\Users" && (del /a /f /q browser.7z & popd) 2>nul 1>&2
pushd "%SYSTEMDRIVE%\Users" && (del /a /f /q install.7z & popd) 2>nul 1>&2

REM forfiles -p "%PROGRAMFILES%\NVIDIA Corporation\Installer2" -s -m *.* -d -60 -c "cmd /c del /a /f /q @path && (set /a N+=1)" 2>nul 1>&2
REM forfiles -p "%PROGRAMFILES(x86)%\NVIDIA Corporation\Installer2" -s -m *.* -d -60 -c "cmd /c del /a /f /q @path && (set /a N+=1)" 2>nul 1>&2

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
set N=
exit /b


:WINSXS
echo.���⪠ WinSXS:
<nul set /p "T= ��४�ਨ/䠩��:   "
pushd "%SYSTEMROOT%\winsxs"

for %%a in ("backup" "ManifestCache") do (
	dir "%%~a" /a-d 2>nul 1>&2
	if errorlevel 1 (
		call :ECHO "%%~a " 1F
		call :ECHO "Empty   " 1E
	) else (
		call :ECHO "%%~a " 1F
		(takeown /a /f "%%~a\*"
		icacls "%%~a\*" /q /c /grant ������������:F
		icacls "%%~a\*" /q /c /grant "%USERDOMAIN%\%USERNAME%":F
		del /a /f /q "%%~a\*")2>nul 1>&2
		call :ECHO "Done   " 1A
	)
)

if exist reserve.tmp (
	call :ECHO "reserve.tmp " 1F
	(takeown /a /f "reserve.tmp"
	icacls "reserve.tmp" /q /c /grant ������������:F
	icacls "reserve.tmp" /q /c /grant "%USERDOMAIN%\%USERNAME%":F
	del /a /f /q "reserve.tmp")2>nul 1>&2
	call :ECHO "Done   " 1A
)
popd
echo.
echo.
exit /b


:WINSXS_COMPONENTS
ver | findstr /i "6.2. 6.3. 10.0." >nul && (
	<nul set /p "T= �����⠫��� ���ॢ�� ��������⮢ �� WinSXS                 :"
	dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase 2>nul 1>&2
	call :ECHO "Done" 1A&echo.
)
exit /b


:WINOLD
<nul set /p "T= �������� ������ ����� ���ᨩ windows (Windows.old)           :"

set N=0

for /d %%a in ("%SYSTEMDRIVE%\Windows.old*") do (
	if exist "%%~a" (
		(takeown /a /f "%%~a"
		icacls "%%~a\*" /q /c /grant ������������:F
		icacls "%%~a\*" /q /c /grant "%USERDOMAIN%\%USERNAME%":F
		rd /s /q "%%~a"
		set /a N+=1)2>nul 1>&2
		)
	)

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)

set N=

exit /b


:MSOCACHEC
<nul set /p "T= ���⨥ ��� ��⠭������ 䠩��� MS Office                     :"

set N=0

for %%a in ("%SYSTEMDRIVE%\MSOCache" "%ALLUSERSPROFILE%\Microsoft\OEMOffice14" "%ALLUSERSPROFILE%\Microsoft\OEMOffice15" "%ALLUSERSPROFILE%\Microsoft\ClickToRun") do (
	if exist "%%~a" (
		compact /C /I /s:"%%~a" 2>nul 1>&2
		set /a N+=1
	)
)

if "!N!" GTR "0" (call :ECHO "Done" 1A&echo.) else (call :ECHO "Empty" 1E&echo.)
set N=
exit /b


:COMPRESSFILES
<nul set /p "T= ���⨥ ��� ��⠭������ ����⮢ �ணࠬ�                     :"
compact /C /I "%SYSTEMROOT%\Installer\*.msi" "%SYSTEMROOT%\Installer\*.msp" 2>nul 1>&2

for %%a in (
"%LOCALAPPDATA%\Package Cache"
"%PROGRAMFILES%\NVIDIA Corporation\Installer"
"%PROGRAMFILES%\NVIDIA Corporation\Installer2"
"%PROGRAMFILES(x86)%\NVIDIA Corporation\Installer"
"%PROGRAMFILES(x86)%\NVIDIA Corporation\Installer2"
"%PROGRAMFILES%\MSECache"
"%PROGRAMFILES(x86)%\MSECache"
"%ALLUSERSPROFILE%\Microsoft\VisualStudioSecondaryInstaller"
"%ALLUSERSPROFILE%\NokiaInstallerCache"
"%ALLUSERSPROFILE%\Eset\Eset Nod32 Antivirus\Installer"
"%ALLUSERSPROFILE%\Adobe"
"%ALLUSERSPROFILE%\Package Cache"
"%ALLUSERSPROFILE%\Oracle\Java\installcache"
"%ALLUSERSPROFILE%\Oracle\Java\installcache_x64"
"%ALLUSERSPROFILE%\Skype"
) do (compact /C /I /s:"%%~a" 2>nul 1>&2)
call :ECHO "Done" 1A&echo.
exit /b


:FINDMORE
<nul set /p "T= ��㡮��� ���� �६����� 䠩���                               :"
(
pushd "%SYSTEMDRIVE%\" && (del /a /f /s /q *.bak *.old *.temp *.tmp & popd)
pushd "%SYSTEMROOT%\Logs" && (del /a /f /s /q *.log *.cab & popd)
pushd "%SYSTEMROOT%" && (del /a /f /q *.dmp *.log & popd)
pushd "%PROGRAMDATA%" && (del /a /f /s /q *.log & popd)
pushd "%PROGRAMFILES%" && (del /a /f /s /q *.log *.dmp & popd)
pushd "%PROGRAMFILES(x86)%" && (del /a /f /s /q *.log *.dmp & popd)
pushd "%SYSTEMDRIVE%\Users" && (del /a /f /q *.dmp & popd)
)2>nul 1>&2
call :ECHO "Done" 1A&echo.
exit /b


:CLEANMGR
<nul set /p "T= ���⪠ �� ����� Cleanmgr                                   :"

for /f "delims=" %%i in (
	'reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"'
	) do reg add "%%i" /v StateFlags0999 /d "2" /t REG_DWORD /f 2>nul 1>&2

start "" /wait cleanmgr /sagerun:999
call :ECHO "Done" 1A&echo.
set SYSCLEANUP_KEY=1
exit /b


:STARTSERVICES
if defined srv (
	<nul set /p "T= ������������� ࠡ��� ��⥬��� �㦡                          :"
	for %%a in (%SERVICES%) do net start %%a 2>nul 1>&2
	call :ECHO "Done" 1A&echo.
	)
exit /b


:EMPTD
if exist "%~1" for /f "usebackq" %%f in (`dir "%~1\" /b /a:`) do set "EMPTD=1"

if defined EMPTD (
	pushd "%~1" || (set "EMPTD=" & exit /b)
	rd /s /q "%~1"
	set /a N+=1
	popd
)2>nul 1>&2

set "EMPTD="
exit /b


:ECHO
for /f %%i in ('"prompt $h& for %%i in (.) do rem"') do (set Z=%%i)
pushd "%TEMP%" && (
	<nul>"%~1^" set /p="%Z%%Z%  %Z%%Z%"
	findstr /a:%2 . "%~1^*"
	del "%~1^"
	popd
	)
exit /b


:: Cleanup 8.0
:: ���� ��������� - vavun
:: http://www.cyberforum.ru/members/367235.html

:: �᫨ ����� � ��ࠧ�� ��� ������ ��� � �㪨, � ����� �����
:: �� �����⢥���� 楫�� ᮧ����� ᥣ� ������� �뫮 ���祭��
:: ���������⥩ bat, � ���९����� �� �ࠪ⨪� ����祭��� ������

:: � �� ���� �⢥��⢥����� �� ��������� ����� ������ ��� ���襭�� ࠡ��� �� � ���

:: 2015 - 2017