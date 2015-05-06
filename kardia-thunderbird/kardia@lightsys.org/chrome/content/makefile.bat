tasklist | find "thunderbird.exe" >nul
if not errorlevel 1 (
   taskkill /IM thunderbird.exe
)

set FILETOZIP=\\192.168.145.128\kardia\kardia-thunderbird\kardia@lightsys.org
set FINALDEST=C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\versions\WIP\kardia@lightsys.org.xpi.zip
set TEMPDIR=C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\KardiaBatch\temp738

   rd /s /q %TEMPDIR%\files
   mkdir %TEMPDIR%\files
   xcopy /sY /EXCLUDE:C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\KardiaExtension.\excludelist.txt %FILETOZIP% %TEMPDIR%\files
   
   echo Set objArgs = WScript.Arguments > %TEMPDIR%\_zipIt.vbs
   echo InputFolder = objArgs(0) >> %TEMPDIR%\_zipIt.vbs
   echo ZipFile = objArgs(1) >> %TEMPDIR%\_zipIt.vbs
   
   echo CreateObject("Scripting.FileSystemObject").CreateTextFile(ZipFile, True).Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, vbNullChar) >> %TEMPDIR%\_zipIt.vbs

   echo Set objShell = CreateObject("Shell.Application") >> %TEMPDIR%\_zipIt.vbs

   echo Set source = objShell.NameSpace(InputFolder).Items >> %TEMPDIR%\_zipIt.vbs

   echo objShell.NameSpace(ZipFile).CopyHere(source) >> %TEMPDIR%\_zipIt.vbs

   echo wScript.Sleep 2000 >> %TEMPDIR%\_zipIt.vbs
   
   CScript  %TEMPDIR%\_zipIt.vbs  %TEMPDIR%\files  %FINALDEST%

   tasklist | find "thunderbird.exe" >nul
   if not errorlevel 1 (
         timeout /t 10 >nul
         goto :stillAliveLoop
   )

del C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\versions\WIP\kardia@lightsys.org.xpi
ren C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\versions\WIP\kardia@lightsys.org.xpi.zip kardia@lightsys.org.xpi
copy C:\Users\Warren\Documents\LightSys\CentralixAndKardia\Thunderbird\versions\WIP\kardia@lightsys.org.xpi C:\Users\Warren\AppData\Roaming\Thunderbird\Profiles\pnmcsncy.default\extensions

start /d "C:\Program Files (x86)\Mozilla Thunderbird\" thunderbird.exe
