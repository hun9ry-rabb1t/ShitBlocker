
#Requirments:
#Admin rights: (start powershell as admin)
#Unrestricted execution policy: 
#'Get-ExecutionPolicy' -  unquoted, to show your current status of execution policy, if it returns 'Restricted', you would need to set the policy to 'Unrestricted' in order to run the script
#'Set-ExecutionPolicy Unrestricted' - unquoted, to set your execution policy to unrestricted




param(
    [switch]$Elevated
)


$logo = @"
                                                                      
 @@@@@@   @@@  @@@  @@@  @@@@@@@                                      
@@@@@@@   @@@  @@@  @@@  @@@@@@@                                      
!@@       @@!  @@@  @@!    @@!                                        
!@!       !@!  @!@  !@!    !@!                                        
!!@@!!    @!@!@!@!  !!@    @!!                                        
 !!@!!!   !!!@!!!!  !!!    !!!                                        
     !:!  !!:  !!!  !!:    !!:                                        
    !:!   :!:  !:!  :!:    :!:                                        
:::: ::   ::   :::   ::     ::                                        
:: : :     :   : :  :       :                                         
@@@@@@@   @@@        @@@@@@    @@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@   
@@@@@@@@  @@@       @@@@@@@@  @@@@@@@@  @@@  @@@  @@@@@@@@  @@@@@@@@  
@@!  @@@  @@!       @@!  @@@  !@@       @@!  !@@  @@!       @@!  @@@  
!@   @!@  !@!       !@!  @!@  !@!       !@!  @!!  !@!       !@!  @!@  
@!@!@!@   @!!       @!@  !@!  !@!       @!@@!@!   @!!!:!    @!@!!@!   
!!!@!!!!  !!!       !@!  !!!  !!!       !!@!!!    !!!!!:    !!@!@!    
!!:  !!!  !!:       !!:  !!!  :!!       !!: :!!   !!:       !!: :!!   
:!:  !:!   :!:      :!:  !:!  :!:       :!:  !:!  :!:       :!:  !:!  
 :: ::::   :: ::::  ::::: ::   ::: :::   ::  :::   :: ::::  ::   :::  
:: : ::   : :: : :   : :  :    :: :: :   :   :::  : :: ::    :   : :  

Usage:
Simply provide path of desired folder to be blocked, script recursively go through nested folders within provided path
and created inbound and outbound block rules for each executive file in entire directory.
Example: C:\Program Files\example 
p.s: Make sure path its unquoted if you copy dir with rigth click                                                                                                                                                                                                  
"@


Write-Host $logo -ForegroundColor Cyan


Write-Host "Enter the dir path of desired shit to be blocked:" -ForegroundColor Cyan -NoNewline
$ShitPath = Read-Host


if (-not (Test-Path $ShitPath)) {
    Write-Host "The entered path is not valid. Please run the script again with a valid path." -ForegroundColor Red
    exit
}

# Function to test if the script is running as admin
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Restart the script as admin if not already
if (-NOT $Elevated -AND -NOT (Test-Admin)) {
    Start-Process PowerShell -ArgumentList "-File `"$($MyInvocation.MyCommand.Definition)`" -Elevated" -Verb RunAs
    exit
}

$ruleNamePrefix = "BlockedShit_"

Get-ChildItem -Path $ShitPath -Filter *.exe -Recurse | ForEach-Object {
    $exePath = $_.FullName
    $ruleNameOutbound = $ruleNamePrefix + $_.BaseName + "_Outbound"
    $ruleNameInbound = $ruleNamePrefix + $_.BaseName + "_Inbound"

    Try {
        # Create outbound rule
        New-NetFirewallRule -DisplayName $ruleNameOutbound -Direction Outbound -Program $exePath -Action Block
        Write-Host "Outbound rule created for shit - ${exePath}: $ruleNameOutbound" -ForegroundColor Green

        # Create inbound rule
        New-NetFirewallRule -DisplayName $ruleNameInbound -Direction Inbound -Program $exePath -Action Block
        Write-Host "Inbound rule created for shit - ${exePath}: $ruleNameInbound" -ForegroundColor Green
    }
    Catch {
        Write-Host "Error creating firewall rules for shit :-( : ${exePath}" -ForegroundColor Red
        Write-Host $_.Exception.Message
    }
}


