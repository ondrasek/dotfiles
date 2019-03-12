###
### https://hodgkins.io/ultimate-powershell-prompt-and-git-setup
###

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Get-ChildItemColor
Import-Module Get-ChildItemColor
 
Set-Alias l Get-ChildItemColor -option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
Set-Alias dir Get-ChildItemColor -option AllScope -Force

# Import module from previous step
Import-Module -Name posh-git

function Test-Administrator {
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

function Prompt {
    $realLASTEXITCODE = $LASTEXITCODE

	$promptString = ""
    # Reset color, which can be messed up by Enable-GitColors
    # $Host.UI.RawUI.ForegroundColor = $GitPromptSettings.DefaultForegroundColor

    if (Test-Administrator) {  # Use different username if elevated
        $promptString += Write-Prompt "(Elevated) " -ForegroundColor White
    }

    $promptString += Write-Prompt "$ENV:USERNAME@"  -ForegroundColor DarkYellow
    $promptString += Write-Prompt "$ENV:COMPUTERNAME"  -ForegroundColor Magenta

    if ($s -ne $null) {  # color for PSSessions
        $promptString += Write-Prompt " (`$s: "  -ForegroundColor DarkGray
        $promptString += Write-Prompt "$($s.Name)"  -ForegroundColor Yellow
        $promptString += Write-Prompt ") "  -ForegroundColor DarkGray
    }

    $promptString += Write-Prompt " : "  -ForegroundColor DarkGray
    $promptString += Write-Prompt $($(Get-Location) -replace ($env:USERPROFILE).Replace('\','\\'), "~")  -ForegroundColor LightGreen
    $promptString += Write-Prompt " : "  -ForegroundColor DarkGray
    $promptString += Write-Prompt (Get-Date -Format G)  -ForegroundColor DarkMagenta
	$vcsStatus = Write-VcsStatus
	if ($vcsStatus) { 
		# There is no need for a trailing space after the colon. VcsStatus already contains spaces.
		$promptString += Write-Prompt " :"  -ForegroundColor DarkGray
		$promptString += Write-VcsStatus
	}

    $global:LASTEXITCODE = $realLASTEXITCODE
	
	if ($global:LASTEXITCODE -ne 0) {
		$promptString += Write-Prompt " : "  -ForegroundColor DarkGray
		$promptString += Write-Prompt "($global:LASTEXITCODE)" -ForegroundColor Yellow
	} 

	$versionString = "`n{0}.{1}.{2}-{3}" -f $PSVersionTable.PSVersion.Major, $PSVersionTable.PSVersion.Minor, $PSVersionTable.PSVersion.Patch, $PSVersionTable.PSEdition
	$promptString += Write-Prompt $versionString -ForegroundColor White
	$promptString += Write-Prompt ">" -ForegroundColor Gray

	return $promptString
}
