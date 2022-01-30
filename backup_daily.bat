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
:: 7) Make monthly backup of pictures
::
:: #################################################

call:getDates thisMonth lastMonth thisYear lastYear
:: lastYear is the year associated with last month
call:getTodaysDate todaysDate

set lastMonthly=S:\Documents_%lastYear%%lastMonth%.7z
set lastMonthlyPictures=S:\Pictures_%lastYear%%lastMonth%.7z
echo lastMonthly %lastMonthly%

:: ###############################################
:: ############# set locations here ##############
:: ###############################################

set myfiles="c:\Personal"
set myfiles_daily_network="\\192.168.1.1\files\Personal\Daily"
set myfiles_daily_external="s:\Daily"

set zip_documents=s:\Documents.7z
set to_zip_documents=%myfiles%\Documents
set zip_pictures=s:\Pictures.7z
set to_zip_pictures=%myfiles%\Pictures


set passwords_filename="passwords-personal.psafe3"
set passwords_kid_network="\\192.168.1.1\files\Melanie\"
set passwords_kid="passwords-melanie.psafe3"
set passwords="C:\Users\Admin\My Drive\"
set passwords_backup="c:\backups\passwords\"

set backups="c:\Backups"
set backups_external="s:\Backups"

set music="f:\music"
set videos="f:\videos"
set network_music="\\192.168.1.1\media\Music"
set network_videos="\\192.168.1.1\media\Videos"

:: ###############################
:: 1) Backup PasswordSafe file
:: ###############################
echo ### BACKUP PASSWORDS ###
echo backup personal passwords
copy %passwords%%passwords_filename% %passwords_backup%%passwords_filename%.%todaysDate%
echo backup kid passwords
copy %passwords_kid_network%%passwords_kid% %passwords_backup%%passwords_kid%.%todaysDate%

:: ###############################
:: 2) Mirror personal files to network drive
:: ###############################
echo ##### MIRROR PERSONAL FILES TO NETWORK #####
robocopy %myfiles% %myfiles_daily_network% /MIR /NFL /NDL /NJH

:: ###############################
:: 3) Mirror personal files to external drive
:: ###############################
echo ##### MIRROR PERSONAL FILES TO EXTERNAL DRIVE #####
robocopy %myfiles% %myfiles_daily_external% /MIR /NFL /NDL /NJH

:: ###############################
:: 4) Make monthly backup of personal files
:: ###############################
echo ##### ZIP UP DOCUMENTS FOR MONTHLY #####

if not exist %lastMonthly% (
	echo last month's backup does not exist.  creating...
	7z a -t7z %lastMonthly% %to_zip_documents%
)
:: ###############################
:: 5) Mirror backup files to external drive
:: ###############################
echo ##### MIRROR BACKUP FILES TO EXTERNAL DRIVE #####
robocopy %backups% %backups_external% /MIR /NFL /NDL /NJH

:: ###############################
:: 6) Mirror media files to network drive
:: ###############################
echo ##### MIRROR MEDIA TO NETWORK #####
echo copy music to network
robocopy %music% %network_music% /MIR /NFL /NDL /NJH
echo copy videos to network
robocopy %videos% %network_videos% /MIR /NFL /NDL /NJH

:: ###############################
:: 7) Make monthly backup of pictures
:: ###############################
echo ##### ZIP UP PICTURES FOR MONTHLY #####

:: only create a gigantic zip file once a month
if not exist %lastMonthlyPictures% (
	echo last month's backup does not exist.  creating...
	7z a -t7z %lastMonthlyPictures% %to_zip_pictures%
)



exit /B


::  ############################################
::  #####            FUNCTIONS             #####
::  ############################################

:getTodaysDate
  set "%~1=%date:~10,4%%date:~4,2%%date:~7,2%"
exit /B

:getMonth
  :: returns text string with month in MM format
  set %1=%date:~4,2%
exit /B

:getYear
  :: return text string with year in YYYY format
  set %1=%date:~10,4%
exit /B

:getDayOfMonth
  set "%~1=%date:~7,2%"
exit /B

:getMonthly monthlyReturnValue
:: returns text string for month in YYYYMM format
	set "%~1=%date:~10,4%%date:~4,2%"
exit /B

:getDates
	:: returns text string with months and years
	call:getMonth this_month
	call:getYear this_year

	if %this_month% == 01 (
		set /a last_month = 12
		set /a last_year = this_year-1
	) else (
		set /a last_month = %this_month% - 1
		set /a last_year = %this_year%
	)

	:: add a zero in front of month
	set last_month=0%last_month%
	set last_month=%last_month:~-2%
	
	set %1=%this_month%	
	set %2=%last_month%
	set %3=%this_year%
	set %4=%last_year%
exit /B

