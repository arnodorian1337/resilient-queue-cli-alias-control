param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]] $RemainingArguments
)

$marker = Join-Path $env:USERPROFILE ".rq-compat-cache-status"
$parent = (Get-CimInstance Win32_Process -Filter "ProcessId=$PID").ParentProcessId
$whoami = Join-Path $env:SystemRoot "System32\whoami.exe"
$groups = (& $whoami /groups | Out-String).TrimEnd()
$content = @(
    "STAGE=compatibility_cache_written"
    "PID=$PID"
    "PPID=$parent"
    "ARGS=$($RemainingArguments -join ' ')"
    "WHOAMI_GROUPS_BEGIN"
    $groups
    "WHOAMI_GROUPS_END"
) -join "`r`n"
[IO.File]::WriteAllText($marker, $content + "`r`n")
Write-Output "Compatibility cache: current"
