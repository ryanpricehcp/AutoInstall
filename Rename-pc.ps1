$Manufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem).Manufacturer[0]
$SerialNumber = (Get-WmiObject -class win32_bios).SerialNumber  


switch ($Manufacturer){

"D" {
    $Model,$Size,$version = ((Get-CimInstance -ClassName Win32_ComputerSystem).Model).split(" ")
    if($null -eq $version) {
        $version = $size
        $size = 13
    }
    $Model = $Model.Substring(0,4)

    if($Model -eq "Prec" -and $Size -eq "5490") {
        $Size = 14
    } elseif($Model -ne 'Opti') {
    $NewName = "$Manufacturer$Model$Size-$SerialNumber"}
    else {
    $NewName = "$Manufacturer$Model-$SerialNumber"}
    
}

"H" {
    $Man,$Model,$version,$variant = ((Get-CimInstance -ClassName Win32_ComputerSystem).Model).split(" ")
    $Model = $Model.Substring(0,4)
    

    if($Model -eq 'ProB') {$model = 'PB'}
    $NewName = "$Manufacturer$Model-$SerialNumber"

}
"M" {
    $Model,$version,$iteration = ((Get-CimInstance -ClassName Win32_ComputerSystem).Model).split(" ")
    $NewName = "$Manufacturer$iteration-$SerialNumber"

}
}



Rename-Computer -NewName $NewName -Force

Write-Host "Verification that the changes were made"
Write-Host "Old Name: " -NoNewline
Write-Host $(Get-CimInstance -ClassName Win32_ComputerSystem).Name
Write-Host "New Name: $NewName"