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