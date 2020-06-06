@echo off

rem #################################################
rem # 
rem # The daily backup saves to a folder with date format YYYYMM.
rem # 
rem # When the month changes, that folder stops being updated, creating a monthly backup.
rem # 
rem # TODO: figure out how to ZIP up the old months to save space
rem #
rem #################################################


:: ######## calculate dates ############

set thisMonth=%date:~4,2% 
set thisYear=%date:~10,4%
if %thisMonth% == "01" (
	set /a lastMonth = 12
	set /a lastYear = thisYear-1
) else (
	set /a lastMonth = %thisMonth% - 1
	set /a lastYear = %thisYear%
)

:: add a zero in front of month
set lastMonth=0%lastMonth%
set lastMonth=%lastMonth:~-2%

set monthly = %thisYear%%thisMonth%
set lastMonthly = %lastYear%%lastMonth%


call:getDate mydate
::call:getDayofMonth dayOfMonth
::call:getMonthly monthly

:: ############# set locations here ##############

set myfiles="c:\Personal"
set myfiles_daily_network="\\192.168.1.1\Personal\Daily"
set myfiles_daily_external=s:\Personal\Monthly\%monthly%
set myfiles_monthly_external=s:\Personal\Monthly\%monthly%
set myfiles_lastMonthly_external=s:\Personal\Monthly\%lastMonthly%

set passwords_filename="passwords-personal.psafe3"
set passwords="C:\Users\Admin\Google Drive\"
set passwords_backup="c:\backups\passwords\"

set backups="c:\Backups"
set backups_external="s:\Backups"

set music="f:\music"
set videos="f:\videos"
set network_music="\\192.168.1.1\Media\Music"
set network_videos="\\192.168.1.1\Media\Videos"

echo ######################## BACKUP PASSWORDS ##########################################
rem copy today's password file to a backup location with date attached
copy %passwords%%passwords_filename% %passwords_backup%%passwords_filename%.%mydate%

echo ##### MIRROR PERSONAL FILES TO NETWORK #####
robocopy %myfiles% %myfiles_daily_network% /MIR

echo ##### MIRROR PERSONAL FILES TO EXTERNAL DRIVE #####
robocopy %myfiles% %myfiles_daily_external% /MIR

echo ##### MIRROR BACKUP FILES TO EXTERNAL DRIVE #####
robocopy %backups% %backups_external% /MIR

echo ##### MIRROR MEDIA TO NETWORK #####
echo copy music to network
robocopy %music% %network_music% /MIR
echo copy videos to network
robocopy %videos% %network_videos% /MIR


:: check if folder for last month exists
if exist %myfiles_lastMonthly_external% (
	echo last month's backup folder exists
	7z a -t7z %temp%\%lastMonthly%.7z %myfiles_lastMonthly_external%
	if exist %temp%\%lastMonthly%.7z (
		rmdir %myfiles_lastMonthly_external%
		move %temp%\%lastMonthly%.7z s:\Personal\Monthly\	
	)
)



exit /B


::  ############################################
::  #####            FUNCTIONS             #####
::  ############################################

:getDate
  set "%~1=%date:~10,4%%date:~4,2%%date:~7,2%"
exit /B


:getDayOfMonth
  set "%~1=%date:~7,2%"
exit /B

:getMonthly monthlyReturnValue
:: returns text string for month in YYYYMM format
	set "%~1=%date:~10,4%%date:~4,2%"
exit /B

:getLastMonthly
:: returns text string for last month in YYYYMM format

	set thisMonth=%date:~4,2% 
	set thisYear=%date:~10,4%
	if %thisMonth% == "1" (
		set /a lastMonth = 12
		set /a lastYear = thisYear-1
	) else (
		set /a lastMonth = %thisMonth% - 1
		set /a lastYear = %thisYear%
	)

	:: add a zero in front of month
	set returnMonth=0%lastMonth%
    set returnMonth=%returnMonth:~-2%
	set "returnValue=%lastYear%%returnMonth%"
	set "%returnValue%"
exit /B

