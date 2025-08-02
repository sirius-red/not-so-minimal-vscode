<##
.SYNOPSIS
    Installs the not-so-minimal-vscode customizations for Windows.

.DESCRIPTION
    This script automates the process of applying custom styles and scripts to Visual Studio Code on Windows.
    It finds the VS Code installation, creates symbolic links to the customization files, and patches the
    workbench.html file to load them.

    WARNING: This script modifies VS Code's installation files. It must be run with Administrator privileges.
    Use at your own risk.

.NOTES
    Author: Cline
    Version: 1.0
##>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [Alias('u', '-uninstall', 'r', '-remove')]
    [switch]$Uninstall
)

# Stop script on any error
$ErrorActionPreference = 'Stop'

# --- Configuration ---
$SourceDir = $PSScriptRoot
$CustomDirName = 'not-so-minimal-vscode'
$HtmlInject = "<!-- NSMVSC --><link rel=`"stylesheet`" href=`"$CustomDirName/styles.css`" /><script src=`"$CustomDirName/script.js`"></script><!-- NSMVSC -->"

#
# Finds the VS Code workbench directory on Windows.
#
function Search-WorkbenchDir
{
    $possiblePaths = @(
        # System-wide installation
        (Join-Path $env:ProgramFiles 'Microsoft VS Code\resources\app\out\vs\code\electron-browser\workbench'),
        # User-specific installation
        (Join-Path $env:LOCALAPPDATA 'Programs\Microsoft VS Code\resources\app\out\vs\code\electron-browser\workbench')
    )

    foreach ($path in $possiblePaths)
    {
        if (Test-Path -Path $path -PathType Container)
        {
            return $path
        }
    }

    Write-Host "ERROR: Could not find VS Code's installation directory automatically." -ForegroundColor Red
    while (-not $true)
    {
        $userInput = Read-Host "Please enter the full path to VS Code's workbench directory and press Enter (or leave blank to cancel)"
        if ([string]::IsNullOrWhiteSpace($userInput))
        {
            Write-Host 'Installation cancelled by user.'
            exit
        }
        if (Test-Path -Path $userInput -PathType Container)
        {
            return $userInput
        }
        else
        {
            Write-Host "The provided path '$userInput' is not a valid directory. Please try again." -ForegroundColor Yellow
        }
    }

    return $null
}

#
# Creates symbolic links for the customization files.
#
function Copy-Files
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkbenchDir
    )

    $targetDir = Join-Path -Path $WorkbenchDir -ChildPath $CustomDirName
    Write-Host "Copying files to $targetDir..."

    if (Test-Path -Path $targetDir)
    {
        Write-Host 'Removing existing configuration...'
        Remove-Item -Path $targetDir -Recurse -Force
    }

    New-Item -Path $targetDir -ItemType Directory -Force | Out-Null

    foreach ($file in @('styles.css', '..\script.js'))
    {
        Copy-Item -Path (Join-Path $SourceDir $file) -Destination (Join-Path $targetDir $file) | Out-Null
    }

    Write-Host 'Files copied successfully.'
}

#
# Patches the workbench.html file to include the styles and scripts.
#
function Update-WorkbenchHtml
{
    param(
        [Parameter(Mandatory = $true)]
        [string]$WorkbenchDir
    )

    $workbenchHtmlPath = Join-Path -Path $WorkbenchDir -ChildPath 'workbench.html'
    Write-Host "Patching $workbenchHtmlPath..."

    if (Select-String -Path $workbenchHtmlPath -Pattern 'NSMVSC' -Quiet)
    {
        Write-Host 'WARNING: workbench.html already seems to be patched. Skipping.' -ForegroundColor Yellow
        return
    }

    # Backup the original file and its permissions (ACL)
    $backupPath = "$workbenchHtmlPath.bak"
    Copy-Item -Path $workbenchHtmlPath -Destination $backupPath -Force
    $originalAcl = Get-Acl -Path $workbenchHtmlPath
    Write-Host "Backup created at: $backupPath"

    # Read, modify, and write the content back
    $content = Get-Content -Path $workbenchHtmlPath -Raw
    $newContent = $content -replace '</html>', "$HtmlInject`n</html>"
    Set-Content -Path $workbenchHtmlPath -Value $newContent -Force

    # Restore the original permissions
    Set-Acl -Path $workbenchHtmlPath -AclObject $originalAcl

    Write-Host 'workbench.html patched successfully.'
}

#
# Install the not So Minimal VSCode
#
function Invoke-Install
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$WorkbenchDir
    )

    Write-Host 'Starting not-so-minimal-vscode installation...' -ForegroundColor Green
    Write-Host "VS Code directory found at: $WorkbenchDir"

    Copy-Files -WorkbenchDir $WorkbenchDir
    Update-WorkbenchHtml -WorkbenchDir $WorkbenchDir

    Write-Host ''
    Write-Host 'Installation complete!' -ForegroundColor Green
    Write-Host 'Please restart VS Code for the changes to take effect.'
    Write-Host ''
    Write-Host 'IMPORTANT: VS Code updates will overwrite these changes. If this happens, please run this script again.' -ForegroundColor Yellow
}

#
# Uninstall the not So Minimal VSCode
#
function Invoke-Uninstall
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$WorkbenchDir
    )

    $workbenchFile = "$WorkbenchDir\workbench.html"
    $workbenchFileBackup = "${workbenchFile}.bak"

    Write-Host 'Uninstalling Not So Minimal VSCode...'
    Write-Host "VS Code directory found at: $WorkbenchDir"

    Remove-Item -Path "$WorkbenchDir\$CustomDirName" -Recurse -Force
    Move-Item -Path "$workbenchFileBackup" -Destination "$workbenchFile" -Force

    Write-Host ''
    Write-Host 'Uninstallation complete!' -ForegroundColor Green
    Write-Host 'Please restart VS Code for the changes to take effect.'
}

#
# Main script execution block
#
function Main
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [switch]$IsUninstallCmd
    )

    # Check for Administrator privileges
    $currentUser = New-Object Security.Principal.WindowsPrincipal ([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        Write-Error 'This script must be run with Administrator privileges. Please restart your terminal as an Administrator and try again.'
        exit 1
    }

    $workbenchDir = Search-WorkbenchDir

    if ($IsUninstallCmd)
    {
        Invoke-Uninstall $workbenchDir
    }
    else
    {
        Invoke-Install $workbenchDir
    }
}

# Run the main function
Main -IsUninstallCmd:$Uninstall
