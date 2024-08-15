@ECHO OFF
if "%~1"=="" goto :blank
set name=%1
cd %name%/
del %name%.love
tar.exe --exclude=%name%.zip -a -cf %name%.zip *
ren %name%.zip %name%.love
love %name%.love
cd ..
goto :done

:blank
echo No folder specified

:done
@ECHO ON
