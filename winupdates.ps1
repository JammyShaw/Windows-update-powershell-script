    # This part of the command will check to see if TLS 1.2 is being used by powershell and if not it will active it with the Set-ItemProperty cmdlet.

    if ($tls -eq $true) {
        -ScriptBlock {}
    }
    
    
    #[Net.ServicePointManager]::SecurityProtocol
    #[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 
    #Set strong cryptography on 64 bit .Net Framework (version 4 and above)
    #Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

    #set strong cryptography on 32 bit .Net Framework (version 4 and above)
    #Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

    # These will install required modules and update services to be able to update windows via power 
    # and also be able to pull in Microsoft updates, PSWindowsUpdate pulls in windows updates, but not Microsoft updates.
    # What is the difference? Well, Windows updates components such as Internet Explorer, DirectX, .net etc. Where as Microsoft updates
    # Do things like SQL, Office, IIS as well as Windows updates.

    invoke-command -ScriptBlock {Install-Module PSWindowsUpdate -force}
    invoke-command -ScriptBlock {Add-WUServiceManager -ServiceID "7971f918-a847-4430-9279-4a52d1efe18d" -Confirm:$false}

    # This command will list all the currently available Windows/Microsoft updates and output them to a .txt file, 

    invoke-command -ScriptBlock {Get-WUList -MicrosoftUpdate | Out-File C:\winupdatelist.log}

    # This list will create a hide list for specific KBs

    #$hidelist = ("KB4592440", "KB4588962")
    #invoke-command -ScriptBlock {Get-WindowsUpdate -MicrosoftUpdate -KBArticleID $hidelist -Hide}

    # This will show the hide list as well as out put it to a .txt file.

    #invoke-command -ScriptBlock {Get-WindowsUpdate -MicrosoftUpdate -IsHidden | Out-File C:\winhiddenlist.log}

    # This command will install all updates for everything except hidden updates which will then out put the results to a log file.

    invoke-command -ScriptBlock {Install-WindowsUpdate -MicrosoftUpdate -AcceptAll | Out-File C:\winupdatesexcludeiis.log -Confirm:$false}
