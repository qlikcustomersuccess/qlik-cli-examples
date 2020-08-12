<#
    .SYNOPSIS
    Add users from CSV file to Qlik Sense Enterprise
    
    .DESCRIPTION
    This example utilizes Qlik CLI for Qlik Sense on Windows to add new users 
    to Qlik Sense user list. The added users are extracted from a CSV file, 
    containing userdomain and username for each user to be added.    
        
​    .PARAMETER  HostName
    Hostname to Qlik Sense central node. This is where Qlik Sense Repository 
    Servcie (QRS) API will be called to add new users to Qlik Sense. 
    Default value is localhost. 
​
    .EXAMPLE
    C:\PS> .\Add-QlikUsersFromCSV.ps1 -PathCSV "c:\users.csv"
    
    Load users from ​'c:\users.csv' and add to Qlik Sense accessed on localhost. 

    .EXAMPLE
    C:\PS> .\Add-QlikUsersFromCSV.ps1 -PathCSV "c:\users.csv" -HostName "qlikserver1.domain.local"

    Load users from ​'c:\users.csv' and add to Qlik Sense on qlikserver1.domain.local. 
    ​
    .NOTES
    Qlik CLI for Qlik Sense on Windows is not supported by Qlik Support. 
    See https://github.com/ahaydon/Qlik-Cli-Windows for more details.
    This script is provided "AS IS", without any warranty, under the MIT License. 
    Copyright (c) 2020 
#>

param (
    [Parameter(Mandatory=$true)]
    [string] $HostName = "localhost",
    [Parameter(Mandatory=$true)]
    [String] $PathCSV
)

if(!(Get-Module -ListAvailable -Name Qlik-CLI)) {
    throw "ERROR: Qlik CLI is not installed." 
}

try {
    Connect-Qlik $HostName -TrustAllCerts -UseDefaultCredentials | Out-Null
} catch {
    throw "ERROR: Failed to connect to $HostName. Check hostname spelling and confirm that certificates are availabel for the user. "
}

If(Test-Path -Path "$PathCSV") {

    $headers = (Get-Content $PathCSV -TotalCount 1).Split(",") | ForEach-Object {$_.Trim()}

    if($headers[0] -like "domain" -and $headers[1] -like "userid" -and $headers.Length -eq 2) {

        Import-csv -path "$PathCSV" -Header 'Domain', 'UserId' | `
        ForEach-Object { New-QlikUser  -userId "$($_.$UserId)" -userDirectory "$($_.$Domain)" }
    
    } else {
        throw "ERROR: CSV file does not have expected format of TWO columns named DOMAIN and USERID. "
    }

} else {
    throw "ERROR: Path to CSV file is invalid; $PathCSV "
}

