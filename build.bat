@echo off
rem Build cmdtab.exe with MSVC. Run from any folder; output goes next to this file.
setlocal
set "HERE=%~dp0"
set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
for /f "usebackq delims=" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSDIR=%%i"
if not defined VSDIR (echo Visual Studio C++ build tools not found & exit /b 1)
call "%VSDIR%\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
pushd "%HERE%"
rc /nologo /fo cmdtab.res cmdtab.rc || goto fail
cl /nologo /std:c11 /O1 /W3 /DNDEBUG cmdtab.c cmdtab.res /Fe:cmdtab.exe /link /SUBSYSTEM:WINDOWS /MANIFEST:NO user32.lib gdi32.lib shell32.lib ole32.lib comctl32.lib advapi32.lib || goto fail
del /q cmdtab.obj cmdtab.res 2>nul
popd
echo Built %HERE%cmdtab.exe
exit /b 0
:fail
popd
exit /b 1
