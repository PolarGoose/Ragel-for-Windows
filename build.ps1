Function Info($msg) {
  Write-Host -ForegroundColor DarkGreen "`nINFO: $msg`n"
}

Function Error($msg) {
  Write-Host `n`n
  Write-Error $msg
  exit 1
}

Function CheckReturnCodeOfPreviousCommand($msg) {
  if(-Not $?) {
    Error "${msg}. Error code: $LastExitCode"
  }
}

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = $PSScriptRoot
$buildDir = "$root/build"

Info "Find Visual Studio installation path"
$vswhereCommand = Get-Command -Name "${Env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$installationPath = & $vswhereCommand -prerelease -latest -property installationPath

Info "Open Visual Studio 2022 Developer PowerShell"
& "$installationPath\Common7\Tools\Launch-VsDevShell.ps1" -Arch amd64

Info "Remove '$buildDir' folder if it exists"
Remove-Item $buildDir -Force -Recurse -ErrorAction SilentlyContinue
New-Item $buildDir -Force -ItemType "directory" > $null

Info "Download Ragel source code"
Invoke-WebRequest -Uri https://codeload.github.com/adrian-thurston/ragel/zip/refs/tags/ragel-6.10 -OutFile $buildDir/ragel.zip

Info "Extract the source code"
[System.IO.Compression.ZipFile]::ExtractToDirectory("$buildDir/ragel.zip", "$buildDir")

Info "Copy patch files to the Ragel sources"
Copy-Item -Path $root/patch_files/* -Destination $buildDir/ragel-ragel-6.10 -Recurse -Force

Info "Cmake generate cache"
cmake `
  -S $buildDir/ragel-ragel-6.10 `
  -B $buildDir/out `
  -G Ninja `
  -DCMAKE_BUILD_TYPE=Release
CheckReturnCodeOfPreviousCommand "cmake cache failed"

Info "Cmake build"
cmake --build $buildDir/out
CheckReturnCodeOfPreviousCommand "cmake build failed"

Info "Copy the executable to the publish directory and archive it"
New-Item $buildDir/publish -Force -ItemType "directory" > $null
Copy-Item -Path $buildDir/out/Ragel.exe -Destination $buildDir/publish
Compress-Archive -Path "$buildDir/publish/*.exe" -DestinationPath $buildDir/publish/Ragel.zip
