#RUN AS ADMINISTRATOR

#Search for recently written files

Write-Host "`r`nRecently Written Files: `r`n"
Write-Host "++++++++++++++++++++++++++`r`n"

$recentFiles = Get-ChildItem -Path C:\ -Filter =.exe -Recurse -ErrorAction SilentlyContinue -Force|? {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}|select -exp FullName

ForEach($file in $recentFiles){
    Write-Host $file
    }



#Check for Alternate Data Streams:

Write-Host "`r`nFiles with ADS: `r`n"
Write-Host "+++++++++++++++++++++++++++`r`n"

ForEach ($file in $recentFiles){
    Get-Item $file -Stream * | Where-Object stream -NE ':$Data'
    }