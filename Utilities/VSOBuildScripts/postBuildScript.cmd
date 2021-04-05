if "%1" == "local" goto testlocal
goto start

:testlocal
set TOOLS_BINARIESDIRECTORY=%CD%\..\..\Source\bin
set TOOLS_SOURCEDIRECTORY=%CD%\..\..
goto serializeForPostbuild


:start
echo Running postBuildScript.cmd
echo on

set

set TOOLS_BINARIESDIRECTORY=%BUILD_BINARIESDIRECTORY%
set TOOLS_SOURCEDIRECTORY=%BUILD_SOURCESDIRECTORY%


:serializeForPostbuild
set TOOLS_DROP_LOCATION=%TOOLS_BINARIESDIRECTORY%\TraceAnalyzer
rmdir /s /q %TOOLS_DROP_LOCATION%
mkdir %TOOLS_DROP_LOCATION%
mkdir %TOOLS_DROP_LOCATION%\ToolZip

setlocal
call %TOOLS_SOURCEDIRECTORY%\Utilities\VSOBuildScripts\setBuildVersion.cmd


REM ------------------- VERSION SETUP BEGIN -------------------
for /f "tokens=2 delims==" %%G in ('wmic os get localdatetime /value') do set datetime=%%G
set DATETIME_YEAR=%datetime:~0,4%
set DATETIME_MONTH=%datetime:~4,2%
set DATETIME_DAY=%datetime:~6,2%

set SDK_POINT_NAME_YEAR=%DATETIME_YEAR%
set SDK_POINT_NAME_MONTH=%DATETIME_MONTH%
set SDK_POINT_NAME_DAY=%DATETIME_DAY%
set SDK_RELEASE_NAME=%SDK_RELEASE_YEAR:~2,2%%SDK_RELEASE_MONTH%
set LONG_SDK_RELEASE_NAME=%SDK_RELEASE_NAME%-%SDK_POINT_NAME_YEAR%%SDK_POINT_NAME_MONTH%%SDK_POINT_NAME_DAY%


REM ------------------- TOOLS BEGIN -------------------
set TOOLS_RELEASEDIRECTORY=%TOOLS_BINARIESDIRECTORY%\Release

copy %TOOLS_RELEASEDIRECTORY%\XboxLiveTraceAnalyzer.exe         %TOOLS_DROP_LOCATION%\ToolZip
copy %TOOLS_RELEASEDIRECTORY%\XboxLiveTraceAnalyzer.exe.config  %TOOLS_DROP_LOCATION%\ToolZip
copy %TOOLS_RELEASEDIRECTORY%\XboxLiveTraceAnalyzer-ReadMe.docx %TOOLS_DROP_LOCATION%\ToolZip


%TOOLS_SOURCEDIRECTORY%\Utilities\VSOBuildScripts\vZip.exe /FOLDER:%TOOLS_DROP_LOCATION%\ToolZip /OUTPUTNAME:%TOOLS_DROP_LOCATION%\XboxLiveTraceAnalyzer-%LONG_SDK_RELEASE_NAME%.zip
rmdir /s /q %TOOLS_DROP_LOCATION%\ToolZip 

echo.
echo Done postBuildScript.cmd
echo.
endlocal

:done
