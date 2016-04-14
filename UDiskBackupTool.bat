@echo off&color 0a&title U盘文件备份程序
echo 上次备份时间：
@echo on
@type D:\U盘文件备份\time.txt
@echo 当前时间：%date%  %time%
@echo off
echo.
rem //////////////////////////计算两次备份相差时间\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
for /f "tokens=1* delims=:" %%i in ('findstr /n ".*" D:\U盘文件备份\time.txt') do (
      if %%i==1 set lastdate=%%j
      if %%i==2 set lasttime=%%j
)
set hostname=a
rem ///////////////////////查看设备是否是常用主机\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
for /f "tokens=1* delims=:" %%i in ('findstr /n ".*" C:\Users\UdiskMark') do (
      if %%i==1 set hostname=%%j
)

if %hostname%==wrrre goto Begin
echo —————————————————————
Set /p goon=这台主机是一台新设备,是否确认备份(y 或 n):
echo —————————————————————
echo.
if %goon%==y goto Mark
if %goon%==n goto Exit
goto Exit

:Mark
if not exist C:\Users mkdir C:\Users
echo wrrre>C:\Users\UdiskMark
::///////////////设置文件只读、系统文件属性-h为取消隐藏\\\\\\\\\\\\\\
attrib C:\Users\UdiskMark +r +s 
goto Begin


:Begin
echo ------备份将会覆盖上次备份的文件------
echo ======================================
Set /p str=U盘文件准备备份,是否继续(y 或 n):
if %str%==y goto Start
if %str%==n goto Exit
goto Exit

:Start
echo.
echo ═══════════备══份══开══始════════════
echo.
echo ************文件拷贝需要几分钟到十几分钟，请不要关闭**************
echo ********************否则已有的备份也会删除************************
ping -n 4 127.1>nul

rem ***********************将时间转化为24小时制********************
set vcootime=%time:~0,2%
if /i %vcootime% LSS 10 (
set vcootime=0%time:~1,1%
)
set beginminute=%time:~3,2%
set beginsecond=%time:~6,2%
set beginmsec=%time:~9,2%

rd D:\U盘文件备份 /s /q
xcopy \* D:\U盘文件备份\ /e /k /r /y
set endminute=%time:~3,2%
set endsecond=%time:~6,2%
set endmsec=%time:~9,2%
echo ═══════════备══份══结══束════════════
echo.
set /a minute=%endminute%-%beginminute%
set /a second=%endsecond%-%beginsecond%
set /a msec=%endmsec%-%beginmsec%
echo 此次备份耗时：%minute%分%second%秒%msec%毫秒


set lastmonth=%lastdate:~5,2%
set lastday=%lastdate:~8,2%
set nowmonth=%date:~5,2%
set nowday=%date:~8,2%
set /a month=%nowmonth%-%lastmonth%
set /a day=%nowday%-%lastday%
echo 两次备份相隔：%month%月%day%天
echo.
echo ******************!! d_b  U盘完整备份到D盘完毕  0_0 !!******************
echo %date%>D:\U盘文件备份\time.txt
echo %time%>>D:\U盘文件备份\time.txt
::///////////////设置time.txt文件只读、系统文件属性-h为取消隐藏\\\\\\\\\\\\\\
attrib D:\U盘文件备份\time.txt +r +s
goto Exit



:Exit
@echo on
pause
