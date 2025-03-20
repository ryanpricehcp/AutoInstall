$Manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer[0]
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber  

switch ($Manufacturer){
"D" {
    $Model,$Size,$version = ((Get-CimInstance -ClassName Win32_ComputerSystem).Model).split(" ")
    if($null -eq $version) {
        $version = $Size
        $Size = 13
    }
    $Model = $Model.Substring(0,3)
    if($Model -eq "Precision" -and $Model -eq "5490") {
        $Size = 14
    }
    $NewName = "$Manufacturer$Model$Size-$SerialNumber"
}

"H" {
    $Man,$Model,$version,$variant = ((Get-CimInstance -ClassName Win32_ComputerSystem).Model).split(" ")
    $NewName = "$Manufacturer$Model$variant-$SerialNumber"
}
"M" {
    $NewName = $Manufacturer-$SerialNumber

}
}



Rename-Computer -NewName $NewName -Force

Write-Host "Verification that the changes were made"
Write-Host "Old Name: " -NoNewline
Write-Host $(Get-CimInstance -ClassName Win32_ComputerSystem).Name
Write-Host "New Name: $NewName" -ForegroundColor Green