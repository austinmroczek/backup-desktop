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




call:getDate mydate
call:getDayofMonth dayOfMonth
call:getMonthly monthly

:: ############# set locations here ##############

set myfiles="c:\Personal"
set myfiles_daily_network="\\192.168.1.1\Personal\Daily"
set myfiles_daily_external=s:\Personal\Monthly\%monthly%
set myfiles_monthly_external=s:\Personal\Monthly\%monthly%

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

:getMonthly
  set "%~1=%date:~10,4%%date:~4,2%"
exit /B

