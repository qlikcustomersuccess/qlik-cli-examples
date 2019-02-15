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
# 

param (
    [string] $HostName        = $null,
    [string] $AppName         = $null,
    [string] $RemoveOlderThan = $null,
    [switch] $SkipConnect     = $false
)

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
    break
}

# Connect to the Qlik Sense
if($HostName -and -not $SkipConnect) { 
    Write-Host "Qlik Sense hostname: $HostName"
} else {
    $HostName = Read-Host -Prompt "Qlik Sense hostname" 
}

if ($WaitForInstall) {
    Write-Host "Waiting for Qlik CLI to finish installing..."
    do{
        Start-Sleep -Seconds 10
        Import-Module Qlik-CLI -ErrorAction SilentlyContinue
    } While(!(Get-Module -ListAvailable -Name Qlik-CLI))    
}

Connect-Qlik $HostName -TrustAllCerts -UseDefaultCredentials | Out-Null

# Set license variable values
if($AppName)         { Write-Host "Full app name: $AppName"                         } else { $AppName         = Read-Host -Prompt "Full app name"                               }
if($RemoveOlderThan) { Write-Host "Remove sheets modified before: $RemoveOlderThan" } else { $RemoveOlderThan = Read-Host -Prompt "Remove sheets modified before (YYY/MM/DD)"   }


$app_id = (Get-QlikApp -filter "$AppName").id
# TBA: Fail if no ID is found

(Get-QlikObject -filter "objectType eq 'sheet' and app.id eq $($app_id) and modifiedDate lt '$RemoveOlderThan'" -full) | ForEach-Object { Remove-QlikObject -id $_ }