@echo off

:: #################################################
:: 
:: This daily backup script performs the following:
::
:: 1) Backup PasswordSafe file
:: 2) Mirror personal files to network drive 
:: 3) Mirror personal files to external drive
:: 4) Make monthly backup of personal files
:: 5) Mirror backup files to external drive
:: 6) Mirror media files to network drive

:: TODO:  fix the network drive

:: #################################################


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
set lastMonthly=S:\PersonalFiles_%lastYear%%lastMonth%.7z

echo lastMonth %lastMonth%
echo lastYear %lastYear%
echo lastMonthly %lastMonthly%

set monthly = "%thisYear%%thisMonth%"
:: set lastMonthly = "%lastYear%%lastMonth%"

echo thisMonth %thisMonth%
echo thisYear %thisYear%
echo monthly %monthly%
echo lastMonthly %lastMonthly%

call:getDate mydate
::call:getDayofMonth dayOfMonth
::call:getMonthly monthly

:: ###############################################
:: ############# set locations here ##############
:: ###############################################

set myfiles="c:\Personal"
set myfiles_daily_network="\\192.168.1.1\Personal\Daily"
set myfiles_daily_external="s:\Daily"

set personal_7z=s:\PersonalFiles.7z

set passwords_filename="passwords-personal.psafe3"
set passwords="C:\Users\Admin\Google Drive\"
set passwords_backup="c:\backups\passwords\"

set backups="c:\Backups"
set backups_external="s:\Backups"

set music="f:\music"
set videos="f:\videos"
set network_music="\\192.168.1.1\Media\Music"
set network_videos="\\192.168.1.1\Media\Videos"

:: ###############################
:: 1) Backup PasswordSafe file
:: ###############################
echo ### BACKUP PASSWORDS ###
copy %passwords%%passwords_filename% %passwords_backup%%passwords_filename%.%mydate%


:: ###############################
:: 2) Mirror personal files to network drive
:: ###############################
echo ##### MIRROR PERSONAL FILES TO NETWORK #####
robocopy %myfiles% %myfiles_daily_network% /MIR


:: ###############################
:: 3) Mirror personal files to external drive
:: ###############################
echo ##### MIRROR PERSONAL FILES TO EXTERNAL DRIVE #####
robocopy %myfiles% %myfiles_daily_external% /MIR


:: ###############################
:: 4) Make monthly backup of personal files
:: ###############################

:: 4. a) Update a 7z file with personal files in the backup folder
7z u -t7z %personal_7z% %myfiles%

:: 4. b) If last month file doesn't exist, create it
if not exist %lastMonthly% (
	echo last month's backup does not exist.  creating...
	move %personal_7z% %lastMonthly%
)


:: ###############################
:: 5) Mirror backup files to external drive
:: ###############################
echo ##### MIRROR BACKUP FILES TO EXTERNAL DRIVE #####
robocopy %backups% %backups_external% /MIR


:: ###############################
:: 6) Mirror media files to network drive
:: ###############################
echo ##### MIRROR MEDIA TO NETWORK #####
echo copy music to network
robocopy %music% %network_music% /MIR
echo copy videos to network
robocopy %videos% %network_videos% /MIR




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

