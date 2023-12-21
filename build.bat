rem Use the MSVS developer command prompt:
rem     https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170#developer_command_prompt_shortcuts

echo off

set PLATFORM=%1
set PREFIX=%2

set CC=cl.exe
set LIB=lib.exe
set BUILD_DIR=.\build

echo "Using PREFIX=%PREFIX%"
echo "Using BUILD_DIR=%BUILD_DIR%"
echo "Using PLATFORM=%PLATFORM%"
echo "Using CC=%CC%"
echo "Using LIB=%LIB%"

rmdir /S /Q %BUILD_DIR%
mkdir %BUILD_DIR%

mkdir %PREFIX%\lib\%PLATFORM%
mkdir %PREFIX%\bin\%PLATFORM%
mkdir %PREFIX%\share\%PLATFORM%
mkdir %PREFIX%\include\tremolo


set CFLAGS="-D_GNU_SOURCE -funsigned-char -Wall -Werror -Wno-unused-variable -Os -DONLY_C"


rem rem list taken from "Android.bp"
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\bitwise.obj Tremolo\bitwise.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\codebook.obj Tremolo\codebook.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\dsp.obj Tremolo\dsp.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\floor0.obj Tremolo\floor0.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\floor1.obj Tremolo\floor1.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\floor_lookup.obj Tremolo\floor_lookup.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\framing.obj Tremolo\framing.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\mapping0.obj Tremolo\mapping0.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\mdct.obj Tremolo\mdct.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\misc.obj Tremolo\misc.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\res012.obj Tremolo\res012.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\treminfo.obj Tremolo\treminfo.c
%CC% -nologo -c %CFLAGS% /Fo:%BUILD_DIR%\vorbisfile.obj Tremolo\vorbisfile.c

%LIB% /nologo /OUT:%PREFIX%\lib\%PLATFORM%\libtremolo.lib %BUILD_DIR%\*.obj

xcopy /y /s /i Tremolo\*.h %PREFIX%\include\tremolo

del %BUILD_DIR%\*.obj
