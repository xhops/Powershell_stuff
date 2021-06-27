$processes = Get-Process *

ForEach($process in $processes){
    Write-Host $process Select-Object 
}


