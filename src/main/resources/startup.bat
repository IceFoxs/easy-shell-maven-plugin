@echo off & setlocal enabledelayedexpansion
chcp 65001
set BASE_DIR=%~dp0
rem added double quotation marks to avoid the issue caused by the folder names containing spaces.
rem removed the last 5 chars(which means \bin\) to get the base DIR.
set BASE_DIR="%BASE_DIR:~0,-5%"

set LOG_HOME=%BASE_DIR%/logs

set SERVER_NAME=${appName}

set SERVER=${appNameJar}


set JAVA_OPTS=-server -Xmx2g -Xms2g -Xmn1g -Xss256k -XX:+DisableExplicitGC  -XX:LargePageSizeInBytes=128m
for /f tokens^=2-5^ delims^=^" %%j in ('java -fullversion 2^>^&1') do set "version=%%j"
echo %version%| findstr "^1.8" >nul && (
   set "JAVA_OPTS=%JAVA_OPTS%  -XX:+UseConcMarkSweepGC -XX:+CMSParallelRemarkEnabled -XX:+UseFastAccessorMethods -XX:+UseCMSInitiatingOccupancyOnly -XX:CMSInitiatingOccupancyFraction=70"
)
echo %version%| findstr "^11" >nul && (
    set "JAVA_OPTS=%JAVA_OPTS%"
)
echo %version%| findstr "^17" >nul && (
   set "JAVA_OPTS=%JAVA_OPTS%"
)

set "JAVA_OPTS=%JAVA_OPTS% -Dapp.home=${BASE_DIR}"
set "JAVA_OPTS=%JAVA_OPTS% -Djava.net.preferIPv4Stack=true"
set "JAVA_OPTS=%JAVA_OPTS% -Dfile.encoding=utf-8"
set "JAVA_OPTS=%JAVA_OPTS% -jar %BASE_DIR%/target/%SERVER%.jar"
set "JAVA_OPTS=%JAVA_OPTS% --logging.config=%BASE_DIR%/config/logback-spring.xml"
set "JAVA_OPTS=%JAVA_OPTS% --logging.file.path=%BASE_DIR%/logs"
set "JAVA_OPTS=%JAVA_OPTS% --spring.config.location=%BASE_DIR%/config/application.yml"
echo Starting the %SERVER_NAME% ...
java %JAVA_OPTS%
pause