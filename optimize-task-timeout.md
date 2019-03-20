# Optimize Task Timeout Using Qlik CLI

Qlik Sense tasks have a default execution timeout of 1440 minutes (24 hours), which might not be optimal for a production environment. This example shows how Qlik CLI can be used to identofy tasks with extensive timeout setting, which can be subject to re-configuraiton. 

## Find tasks with extensive execution timeout

1. Connect to Qlik Sense Repository Service on central node
    ```
    Connect-Qlik qlikserver.domain.local
    ```
1. Get list of all tasks <br/>
    ```
    Get-QlikReloadTask -full | `
    ```
1. Include tasks that can execute multiple times within current ask timeout <br/> This example filters tasks that can execute five (5) times within the timeout period.
    ```
    Where-Object { $_.taskSessionTimeout / $([Math]::floor($_.operational.lastexecutionresult.duration/(1000))) -gt 5 } | `
    ```
1. Print task details
    ```
    ForEach-Object { "  Start: " + $_.operational.lastexecutionresult.starttime + `
                    "`tStop: " + $_.operational.lastexecutionresult.stoptime + `
                    "`tDuration: " + (New-TimeSpan -seconds $([Math]::floor($_.operational.lastexecutionresult.duration/(1000)))) + `
                    "`tTimeout: " + (New-TimeSpan -minutes $_.taskSessionTimeout) + `
                    "`tApp: " + $_.app.name }
    ```
1. The output shows all the task where latest execution time was significantly than the current task execution timeout. 

## Adjust task execution time out

Note, the is not a specifc recommended timeout value. Task timeout must be set based on the task and local execution expectations. If execution time varies for a specific task, then time out should be based on the longest expected execution time, not _only_ the latest execution as show above. 


## References

- [Qlik CLI](https://github.com/ahaydon/Qlik-Cli)
- [Qlik Sense Repository API](https://help.qlik.com/en-US/sense-developer/Subsystems/RepositoryServiceAPI/Content/Sense_RepositoryServiceAPI/RepositoryServiceAPI-Introduction.htm)

## License
This project is provided "AS IS", without any warranty, under the MIT License - see the [LICENSE](LICENSE) file for details.