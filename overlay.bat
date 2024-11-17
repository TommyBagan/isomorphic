@echo off

set build=N
set save=%1
if "%save%"=="-b" (
  set build=Y
  set save=%2
)

if "%save%"=="" (
    echo "ERROR: Must specify the [WORLD-SAVE]."
    echo.
    call :usage
    exit /B 2
)

set MC_DIR=%APPDATA%/.minecraft
if not exist "%MC_DIR%/saves/%save%" (
  echo "ERROR: Found no Minecraft world save %save%"
  echo.
  call :usage
  exit /B 3
)

pushd %~dp0
set "SCRIPT_DIR=%CD%"
popd
if "%build%"=="Y" (
call %SCRIPT_DIR%/build.bat
  if %ERRORLEVEL% neq 0 (
    echo "ERROR: Couldn't build the packs."
    echo.
    call :usage
    exit /B 4
  )
)

set OUT_DIR=%SCRIPT_DIR%/out

set flag=N
if not exist "%OUT_DIR%/isomorphic_data.zip" set flag=Y
if not exist "%OUT_DIR%/isomorphic_resc.zip" set flag=Y
if "%flag%"=="Y" (
  echo "ERROR: Couldn't find both build output zips under %OUT_DIR%."
  echo.
  call :usage
  exit /B 5
)

cp -f "%OUT_DIR%/isomorphic_data.zip" "%MC_DIR%/saves/%save%/datapacks/"
cp -f "%OUT_DIR%/isomorphic_resc.zip" "%MC_DIR%/resourcepacks/"

echo "Overlay Successful!"
echo.

goto end

:usage
echo "usage: overlay.bat [OPTION] [WORLD-SAVE]"
echo "Overlays the datapack and resource pack into Minecraft [WORLD-SAVE]."
exit /B

:end