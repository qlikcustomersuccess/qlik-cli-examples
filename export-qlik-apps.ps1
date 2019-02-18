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

<#
.SYNOPSIS
    Export all Qlik Sense apps including unpublished
.DESCRIPTION
    This script will export all Qlik Sense apps including unpublished apps from QMC.
    This script will also generate the text file with qvf name and id. 
.NOTES
    To run this script, Qlik-Cli needs to be installed firstly.  Otherwise please run below files firstly before running this script:
    1. qlik-cli-install
    2. Connect-cli
    3. set-qlik-license  
#>

# Break if Qlik CLI is not available
if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
  Write-Host -ForegroundColor Red "Error: Qlik CLI has not yet been installed. "
  break
}

$directory = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)

Set-content -Force -path .\ExportApp.txt -value (Get-date)

Foreach($qvf in $(get-qlikapp)) {

 Export-QlikApp -id $qvf.id
 Add-Content -Force -path .\ExportApp.txt -Value ($qvf.id+'  '+$qvf.name)
 
  }  