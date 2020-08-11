#Requires -RunAsAdministrator

# MIT License
# 
# Copyright (c) 2018 Qlik Support
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Qlik-CLI is a PowerShell module that provides a command line interface for 
# managing a Qlik Sense environment. The module provides a set of commands for 
# viewing and editing configuration settings, as well as managing tasks and other 
# features available through the Qlik Sense Repository APIs.
# 
# See https://github.com/ahaydon/Qlik-Cli for more details

$PSVersion = $PSVersionTable.PSVersion.Major

if($PSVersion -lt 4) {
    Write-Host -ForegroundColor Red "Qlik CLI requires PowerShell 4 or greater"
    Break   

}elseif ($PSVersion -eq 4) {

    Write-Host -ForegroundColor Green "Downloading Qlik CLI files from GitHub..."

    New-Item "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli" -ItemType directory -Force

    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psd1" -OutFile "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli\Qlik-Cli.psd1"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ahaydon/Qlik-Cli/master/Qlik-Cli.psm1" -OutFile "$Env:Programfiles\WindowsPowerShell\Modules\Qlik-Cli\Qlik-Cli.psm1"

}else {

    Write-Host -ForegroundColor Green "Qlik CLI installation from NuGet repository..."
    Set-ExecutionPolicy Bypass -Scope Process -Force

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Install-Module -Name Qlik-CLI -Force  | Out-Null
}

Import-Module Qlik-Cli

Write-Host -ForegroundColor Green "$((Get-Module Qlik-Cli).Name) ($((Get-Module Qlik-Cli).Version.Major).$((Get-Module Qlik-Cli).Version.Minor)) has been successfully installed"

