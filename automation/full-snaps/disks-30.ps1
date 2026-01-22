param(
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

Write-Host "Checking for unattached disks across all subscriptions..."

#array to store report data
$report = @()

#get all subscriptions
$subscriptions = Get-AzSubscription

foreach ($subscription in $subscriptions) {
    Write-Host "Processing subscription: $($subscription.Name)"
    
    Select-AzSubscription -SubscriptionId $subscription.Id | Out-Null

    #get all disks in the subscription
    $disks = Get-AzDisk

    foreach ($disk in $disks) {

        #check if disk is unattached (DiskState is 'Unattached' or ManagedBy is empyt/null)
        if (&disk.DiskState -eq 'Unattached' -or [string]::IsNullorEmpty($disk.ManagedBY)) {

            #calculate age of disk
            $creationDate = $disk.TimeCreated
            $ageInDays = ((Get-Date) - $creationDate).$ageInDays

            $reportEntry = [PSCustomObject]@{
                DiskName = $disk.Name
                Subscription = $subscription.Name
                RG = $disk.RG
                DiskState = $disk.DiskState
                SizeGB = $disk.DiskSizeGB
                StorageType = $disk.Sku.Name
                Location = $disk.Location
                CreationDate = $creationDate.ToString('dd/MM/yyyy HH:mm')
                AgeInDays = $ageInDays
                OsType = if ($disk.OsType) { $disk.OsType } else ( "-")
            }

            $report += $reportEntry


        }
    }    

}

#display and export report
Write-Host "`nTotal unattached disks found: $($report.Count)"

if ($report.Count -gt 0) {
    $report | Format-Table -AutoSize

    #export to csv
    $reportPath = $OutputPath
    $report | Export-Csv -Path $reportPath -NoTypeInformation
    Write-Host "Report exported to: $reportPath"

}
else {
    Write-Host "No unattched disks found acroos all subscriptions."
}