#This script queries scheduled tasks and Searches the content in the tasks for any commands being run to indentify persistence.

$tasks = Get-ChildItem "C:\Windows\System32\Tasks" -Recurse

ForEach ($task in $tasks) {
    Write-Host "`r`n[+] Task: $task"
    Write-Host "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++`r`n"
    Get-Content $task -ErrorAction SilentlyContinue | Select-String -Pattern '<command>' -SimpleMatch
}