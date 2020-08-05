#Requires -RunAsAdministrator

<#
    .SYNOPSIS
    Automated installation of Qlik CLI for Windows
    
    .DESCRIPTION
    Download Qlik CLI for Windows (https://github.com/ahaydon/Qlik-Cli-Windows) from either NuGet or manually from GitHub. 

    The logic follows instrucitons on GitHub page. Qlik CLI module requires PowerShell 4.0 or later. 
    For PowerShell 4.0 the module is downloaded fron GitHub, and for all greater version NuGet is attempted.
   
​    .PARAMETER  ForceGitHub
    For GitHub download for any version. This will get module files from GitHub ratehr than NuGet. 
​
    .EXAMPLE
    C:\PS> .\install-qlik-cli.ps1
​   
    .EXAMPLE
    C:\PS> .\install-qlik-cli.ps1 -ForceGitHub
​
    .NOTES
    This script is provided "AS IS", without any warranty, under the MIT License. 
    Copyright (c) 2020 
#>


param (
    [Parameter(Mandatory=$false)]
    [switch] $ForceGitHub 
)

$PSVersion = $PSVersionTable.PSVersion.Major

if($PSVersion -lt 4) {
    Write-Host -ForegroundColor Red "Qlik CLI requires PowerShell 4 or greater"
    Break   

}elseif ($PSVersion -eq 4 -or $ForceGitHub) {

    $downloads_folder = "$env:HOMEDRIVE$env:HOMEPATH\Downloads"
    $module_folder = "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli"

    Write-Host -ForegroundColor Green "Downloading Qlik CLI files from GitHub to $downloads_folder..."
 
    try {
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psd1" -OutFile "$downloads_folder\Qlik-Cli.psd1"
        Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psm1" -OutFile "$downloads_folder\Qlik-Cli.psm1"            
    }
    catch {
        Write-Host "Download failed!" -ForegroundColor Red
        Exit
    }

    New-Item "$module_folder" -ItemType directory -Force | Out-Null

    Write-Host -ForegroundColor Green "Copying Qlik CLI files to $module_folder..."

    New-Item "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli" -ItemType directory -Force

    Copy-Item -Path "$downloads_folder\Qlik-Cli.psd1" -Destination "$module_folder\Qlik-Cli.psd1"
    Copy-Item -Path "$downloads_folder\Qlik-Cli.psd1" -Destination "$module_folder\Qlik-Cli.psd1"

}else {

    Write-Host -ForegroundColor Green "Qlik CLI installation from NuGet repository..."
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Install-Module -Name Qlik-CLI -Force  | Out-Null
}

Import-Module Qlik-Cli

Write-Host -ForegroundColor Green "$((Get-Module Qlik-Cli).Name) ($((Get-Module Qlik-Cli).Version.Major).$((Get-Module Qlik-Cli).Version.Minor)) has been successfully installed"
