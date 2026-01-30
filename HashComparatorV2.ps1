#Calvin's script for comparing hashes V2
#automatically pulls SHA256 hash values for a file and checks it against another file or manual input.

#May need to run following command to allow scripts to run
#Get-ExecutionPolicy -list
#Set-ExecutionPolicy RemoteSigned
#Unblock-File -Path .\HashComparatorV2.ps1

#include windows forms assembly
Add-Type -AssemblyName System.Windows.Forms

#prompt for first file to check hash
$dialog = [System.Windows.Forms.OpenFileDialog]::new()
$dialog.InitialDirectory = $PSScriptRoot
$result = $dialog.ShowDialog()
if ($result -eq [System.Windows.Forms.DialogResult]::OK) 
{
    $filePath1 = $dialog.FileName
    $fileHash1 = (Get-FileHash -Path $filePath1 -Algorithm SHA256).Hash
}
else
{
    Write-Error "File selection cancelled by user."
    return $null
}


#ask to select a file or hash string to compare
$result = [System.Windows.Forms.MessageBox]::Show('Select a second file? No for manual hash input', 'Confirmation', 'YesNo')
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) 
{
    $dialog = [System.Windows.Forms.OpenFileDialog]::new()
    $dialog.InitialDirectory = $PSScriptRoot
    $result = $dialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK) 
    {
        $filePath2 = $dialog.FileName
        $fileHash2 = (Get-FileHash -Path $filePath2 -Algorithm SHA256).Hash
    }
    else
    {
        Write-Error "File selection cancelled by user."
        return $null
    }
} elseif ($result -eq [System.Windows.Forms.DialogResult]::No) 
{
    $fileHash2 = Read-Host -Prompt "Input manual Hash info"
}

#report the hashes
Write-Host "Hash1: " $fileHash1
Write-Host "Hash2: " $fileHash2

#checks if the hash values are equal
if ($fileHash1 -eq $fileHash2)
{
    Write-Host "The hashes match"
}
else
{
    Write-Host "The hashes do NOT match"
}

#May need to run following command to return security settings to default
#Set-ExecutionPolicy Undefined
