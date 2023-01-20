$vcenter_creds = Get-Credential -UserName 'ChangeMe' -Message 'Provide vCenter credentials'
$esxi_creds = Get-Credential -UserName 'ChangeMe' -Message 'Provide ESXi credentials'
$vms = "ChangeMe","ChangeMe"


Connect-VIServer ChangeMe -Credential $vcenter_creds

$prd_esxi_hosts = Get-VM $vms | Get-VMHost

Disconnect-VIServer ChangeMe -Confirm:$false


Connect-VIServer -Server $prd_esxi_hosts -Credential $esxi_creds

Get-VM $vms | Shutdown-VMGuest

do { $vmstatus = (get-vm $vms).PowerState ; Start-Sleep -Seconds 5} while ($vmstatus -eq "PoweredOn")

Start-Sleep 180

Get-VM $vms | New-Snapshot -Name "Change #"-Description "Offline vCenter snapshot before change #"

Get-VM $vms | Get-snapshot | Select VM,Name,Description,PowerState | fl

Get-VM $vms | Start-VM -Confirm:$false

Disconnect-VIServer * -Confirm:$false