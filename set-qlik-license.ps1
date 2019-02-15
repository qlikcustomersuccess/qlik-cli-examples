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

<#
.SYNOPSIS 
    Applies license to Qlik Sense site. 
.DESCRIPTION
    Applies Qlik Sense site license through Qlik Sense Repository Service (QRS) API, by utilizing Qlik CLI (https://github.com/ahaydon/Qlik-Cli).
.PARAMETER  LicenseKey
    16 digit Qlik product license key
.PARAMETER  ControlNumber
    5 digit Qlik product license control number
.PARAMETER  LicenseeName
    Name of the licensee
.PARAMETER  LicenseeOrg
    Name of licensee organisation
.INPUTS
    N/A
.OUTPUTS
    N/A
.NOTES
    Distributed under MIT license. 
    https://github.com/qliksupport/qlik-cli-examples/LICENSE
.LINK
    https://github.com/qliksupport/qlik-cli-examples
.COMPONENT
    This script depends on Qlik CLI for PowerShell
    https://github.com/ahaydon/Qlik-Cli
.EXAMPLE
    set-qlik-license.ps1 
    Call the cmdlet without parameters, and it will prompt for input values.
.EXAMPLE
    set-qlik-license.ps1 -LicenseKey "0123456789012345" -ControlNumber "01234" -LicenseeName "John Doe" -LicenseeOrg "Acme Corp"
    Define all license details as parameters.
#>


param (
    [string] $LicenseKey     = $null,
    [string] $ControlNumber  = $null,
    [string] $LicenseeName   = $null,
    [string] $LicenseeOrg    = $null
)

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
    break
}

# Set license variable values
if($LicenseKey)    { Write-Host "License key (16 digits): $HostName"        } else { $HostName      = Read-Host -Prompt "License key (16 digits)"   }
if($ControlNumber) { Write-Host "Control number (5 digits): $ControlNumber" } else { $ControlNumber = Read-Host -Prompt "Control number (5 digits)" }
if($LicenseeName)  { Write-Host "Licensee name: $LicenseeName"              } else { $LicenseeName  = Read-Host -Prompt "Licensee name"             }
if($LicenseeOrg)   { Write-Host "Licensee Organisation: $LicenseeOrg"       } else { $LicenseeOrg   = Read-Host -Prompt "Licensee Organisation"     }

Set-QlikLicense -serial "$LicenseKey" -control "$ControlNumber" -name "$LicenseeName" -organization "$LicenseeOrg"