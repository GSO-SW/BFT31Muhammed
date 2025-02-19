@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Benennt das Projekt initial um
:parse
set /p name="Bitte Projektnamen eingeben: "

IF "%name%"=="" GOTO errorParam

echo neuer name ist %name%

REM Dateien umbenennen
git mv MyProject %name%
git mv %name%\MyProject.csproj %name%\%name%.csproj
git mv MyProject.sln %name%.sln

REM In dateien den Namen ersetzen
for /F "tokens=* delims=?" %%a in (%name%.sln) do (  
  SET xxx=%%a
  ECHO !xxx:MyProject=%name%! >> tmp.txt
)
del %name%.sln
rename tmp.txt %name%.sln

for /F "tokens=* delims=?" %%a in (%name%\Program.cs) do (  
  SET xxx=%%a
  ECHO !xxx:MyProject=%name%! >> %name%\tmp.cs
)
del %name%\Program.cs
rename %name%\tmp.cs Program.cs

REM und committen
git commit -a -m "Renamed"

REM Umbenennungsscript auch entfernen
git rm Rename.bat

GOTO end

:errorParam
echo Bitte Projektnamen eingeben
GOTO parse

:end
pause