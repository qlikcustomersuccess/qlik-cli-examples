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

#This ps1 is used to remove multiple users from QMC based on the condition. Useful especially when accidently sync unneccessry large amount of users/attributes into QMC. 
#Note, This only applies to the newly synchronized users meaning the user has not accessed Qlik Sense and created any app/objects yet. 

#Connect to Qlik Sense server

Connect-Qlik <QLIK SENSE SERVER HOSTNAME OR DNS NAME>

#Set the filter to fetch the users from QMC.  Firstly verify the filter and user amount to make sure it is correct result. Here 2019-03-19 10:48:00 is the example

(Get-QlikUser -filter "createdDate gt '2019-03-19 10:48:00' " | measure).count

#Remove Qlik Sense User

(Get-QlikUser -filter "createdDate gt '2019-03-19 10:48:00' " -full).id | ForEach-Object { Remove-QlikUser -id $_ }
