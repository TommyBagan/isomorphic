@echo off
pushd %~dp0
set "SCRIPT_DIR=%CD%"
popd
set "OUT_DIR=%SCRIPT_DIR%/out"

call :combine data_pack isomorphic_data.zip
set rc=%ERRORLEVEL%
if %rc% neq 0 (
  exit /B %rc%
)

call :combine resource_pack isomorphic_resc.zip
set rc=%ERRORLEVEL%
if %rc% neq 0 (
  exit /B %rc%
)

echo "Build Successful!"
echo.
goto :end

:usage
echo "usage: build.bat"
echo "Builds the datapack and resource pack into %OUT_DIR%."
exit /B

:combine
set "target=%1"
set "output=%2"
pushd "%SCRIPT_DIR%/%target%/"
if %ERRORLEVEL% neq 0 (
  echo.
  echo "ERROR: Failed to find combine target %target%"
  echo.
  call :usage
  exit /B 2
)
tar -acf %output% *
mv "./%output%" "%OUT_DIR%/"
popd
exit /B

:end