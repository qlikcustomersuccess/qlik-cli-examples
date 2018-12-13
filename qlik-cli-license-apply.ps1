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

param (
    [string] $HostName       = $null,
    [string] $LicenseKey     = $null,
    [string] $ControlNumber  = $null,
    [string] $LicenseeName   = $null,
    [string] $LicenseeOrg    = $null,
    [switch] $WaitForInstall = $false
)

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
    break
}

if ($WaitForInstall) {
    Write-Host "Waiting for Qlik CLI to finish installing..."
    do{
        Start-Sleep -Seconds 10
        Import-Module Qlik-CLI -ErrorAction SilentlyContinue
    } While(!(Get-Module -ListAvailable -Name Qlik-CLI))    
}

# Connect to the Qlik Sense, when installation has finished
if($HostName) { 
    Write-Host "Qlik Sense hostname: $HostName"
} else {
    $HostName = Read-Host -Prompt "Qlik Sense hostname" 
}

Connect-Qlik $HostName -TrustAllCerts -UseDefaultCredentials | Out-Null

# Set license variable values
if($LicenseKey)    { Write-Host "License key (16 digits): $HostName"        } else { $HostName      = Read-Host -Prompt "License key (16 digits)"   }
if($ControlNumber) { Write-Host "Control number (5 digits): $ControlNumber" } else { $ControlNumber = Read-Host -Prompt "Control number (5 digits)" }
if($LicenseeName)  { Write-Host "Licensee name: $LicenseeName"              } else { $LicenseeName  = Read-Host -Prompt "Licensee name"             }
if($LicenseeOrg)   { Write-Host "Licensee Organisation: $LicenseeOrg"       } else { $LicenseeOrg   = Read-Host -Prompt "Licensee Organisation"     }

Set-QlikLicense -serial "$LicenseKey" -control "$ControlNumber" -name "$LicenseeName" -organization "$LicenseeOrg"