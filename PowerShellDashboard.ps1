# Better in ISE?
# Get Services
$NewServiceCollection = @() 
$Services = Get-Service
foreach($Service in $Services){
    $NewObject = [PSCustomObject]@{
        Name = $Service.displayname
        Status = $Service.Status    
    }
    if($Service.Status -eq "Running"){
        Add-Member -InputObject $NewObject -MemberType NoteProperty -Name ActualStatus -Value "Fuck Yeah"
    }
    else {
           Add-Member -InputObject $NewObject -MemberType NoteProperty -Name ActualStatus -Value "Cunt"
    }
    $NewServiceCollection += $NewObject
}

# Get Processes
$NewProcessCollection = @() 
$ActiveProcesses = Get-Process
foreach($ActiveProcess in $ActiveProcesses){
    if($ActiveProcess.Path -ne $Null) { 
        $NewObject = [PSCustomObject]@{
            Name = $ActiveProcess.ProcessName
            Path = $ActiveProcess.Path    
        }
    }
    else {
        $NewObject = [PSCustomObject]@{
            Name = $ActiveProcess.ProcessName
            Path = "No Process Path"
        }
    }
    $NewProcessCollection += $NewObject
}


# Dashboard Bits
Get-UDDashboard | Stop-UDDashboard
$MyDashboard = New-UDDashboard -Title "EQCloud Dashboard" -FontColor Black -NavBarColor White -BackgroundColor red -NavBarLogo (New-UDImage -Path "C:\Users\Peter\Desktop\EQCloud-Logo.png") -Content {
    New-UDLayout -Columns 3 {

        New-UDCard -Title 'EQCloud Checks' -Content {
            New-UDParagraph -Text 'Basic info on Daily Checks.'
        } -Links @(
            New-UDLink -Text 'SharePoint' -Url 'https:\\sharepoint.1cl.oud.tech'
            New-UDLink -Text 'OneView' -Url 'https:\\OneView.1cl.oud.tech'
            New-UDLink -Text 'Wap Admin' -Url 'https:\\Wap-Admin.1cl.oud.tech'
            New-UDLink -Text 'Grafana' -Url 'https:\\Grafana:3000'
            ) -Size 'small'
        
        New-UDElement -Tag "Tag" -Content {
            New-UDCard -Title 'F5 Status' -Text 'F5 Currently in Aspect'
            New-UDCard -Title 'VPN ASA Status' -Text 'ASA is currently in Aspect'
        }
    
        New-UDCard -Title 'EQCloud Useful Links' -Content {
            New-UDParagraph -Text 'Regularly Used Links.'
        } -Links @(
            New-UDLink -Text 'Aspect F5' -Url 'https:\\sharepoint.1cl.oud.tech'
            New-UDLink -Text 'Highdown F5' -Url 'https:\\OneView.1cl.oud.tech'
            New-UDLink -Text 'TFS' -Url 'https:\\Wap-Admin.1cl.oud.tech'
            ) -Size 'small'
    }

    New-UDLayout -Columns 2 {
        # Call Function outside of script?
        New-UdGrid -Title "Local Services" -Headers @("Service Display Name", "Service Status","Actual Status") -Properties @("Name","CurrentStatus","ActualStatus") -PageSize 5 -Endpoint {
                $NewServiceCollection | select Name, @{Name="CurrentStatus";Expression={$_.Status}},actualstatus | Out-UDGridData
        }
        # Call Function outside of script?
        New-UdGrid -Title "Local Processes" -Headers @("Process Display Name", "Process Path") -Properties @("Name","Path") -PageSize 5 -Endpoint {
                $NewProcessCollection | select Name, Path | Out-UDGridData  
        }
    }
}
Start-UDDashboard -Port 1000 -Dashboard $MyDashboard -AutoReload





    
            