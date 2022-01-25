[ScriptBlock]$Prompt = {
    #store if the last command was successful
    $lastCommandSuccess = $?

	$global:testLastCommandSuccess = $lastCommandSuccess
	$global:testLastExitCode = $LASTEXITCODE
	[Environment]::SetEnvironmentVariable('testLastCommandSuccessEnv', "$lastCommandSuccess")
	[Environment]::SetEnvironmentVariable('testLastExitCodeEnv', "$LASTEXITCODE")

    #store the last exit code for restore
    $realLASTEXITCODE = $global:LASTEXITCODE
    $omp = "C:/Users/ondra-pragmax/AppData/Local/Programs/oh-my-posh/bin/oh-my-posh.exe"
    $config, $cleanPWD, $cleanPSWD = Get-PoshContext
    if ($env:POSH_TRANSIENT -eq $true) {
        $standardOut = @(&$omp --pwd="$cleanPWD" --pswd="$cleanPSWD" --config="$config" --print-transient 2>&1)
        $standardOut -join "`n"
        $env:POSH_TRANSIENT = $false
        return
    }
    $errorCode = 0
    Initialize-ModuleSupport
    Set-PoshContext
    if ($lastCommandSuccess -eq $false) {
        #native app exit code
        if ($realLASTEXITCODE -is [int] -and $realLASTEXITCODE -gt 0) {
            $errorCode = $realLASTEXITCODE
        }
        else {
            $errorCode = 1
        }
    }

    # read stack count from current stack(if invoked from profile=right value,otherwise use the global variable set in Set-PoshPrompt(stack scoped to module))
    $stackCount = (Get-Location -stack).Count
    try {
        if ($global:omp_global_sessionstate -ne $null) {
            $stackCount = ($global:omp_global_sessionstate).path.locationstack('').count
        }
    }
    catch {}

    $executionTime = -1
    $history = Get-History -ErrorAction Ignore -Count 1
    if ($null -ne $history -and $null -ne $history.EndExecutionTime -and $null -ne $history.StartExecutionTime -and $global:omp_lastHistoryId -ne $history.Id) {
        $executionTime = ($history.EndExecutionTime - $history.StartExecutionTime).TotalMilliseconds
        $global:omp_lastHistoryId = $history.Id
    }
    $standardOut = @(&$omp --error="$errorCode" --pwd="$cleanPWD" --pswd="$cleanPSWD" --execution-time="$executionTime" --stack-count="$stackCount" --config="$config" 2>&1)
    # make sure PSReadLine knows we have a multiline prompt
    $extraLines = $standardOut.Count - 1
    if ($extraLines -gt 0) {
        Set-PSReadlineOption -ExtraPromptLineCount $extraLines
    }
    # the output can be multiline, joining these ensures proper rendering by adding line breaks with `n
    $standardOut -join "`n"
    $global:LASTEXITCODE = $realLASTEXITCODE
    #remove temp variables
    Remove-Variable realLASTEXITCODE -Confirm:$false
    Remove-Variable lastCommandSuccess -Confirm:$false
}
