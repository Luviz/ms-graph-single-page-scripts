param (
    [Parameter(Mandatory)]
    [string]
    $CsvPath,
    [char]
    $CsvDelimiter = ',',
    [switch]
    $PermanentDelete
)

## Environment variables
$tenantId = "<tenantId>"
$clientId = "<clientId>"
$secret = "<secret>"

## Uncomment below to load from Env Variables

$tenantId = $env:TENANT_ID
$clientId = $env:CLIENT_ID
$secret = $env:SECRET

function Get-AccessToken {
    $body = @{
        grant_type    = "client_credentials"
        client_id     = $clientId
        client_secret = $secret
        scope         = "https://graph.microsoft.com/.default"
    }
    $tokenUrl = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"

    $response = Invoke-WebRequest -Uri $tokenUrl -Method Post -ContentType "application/x-www-form-urlencoded" -Body $body
    $responseData = $response.Content | ConvertFrom-Json
    return $responseData.access_token
}

function Remove-DriveItem {
    [CmdletBinding()]
    param (
        # User id
        [Parameter(Mandatory)]
        [string]
        $UserId,
        # Folder id
        [Parameter(Mandatory)]
        [string]
        $FileId
    )
    $msGraph = "https://graph.microsoft.com/v1.0"

    if ($PermanentDelete) {
        $url = "$msGraph/users/$UserId/drive/items/$FileId/permanentDelete"
        Invoke-WebRequest -Uri $url -Method Post -Headers $headers
    }
    else {
        $url = "$msGraph/users/$UserId/drive/items/$FileId/"
        Invoke-WebRequest -Uri $url -Method Delete -Headers $headers
    }
}

function Read-DriveItemsFromCSV {
    [Cmdletbinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        $path
    )

    return Get-Content $path | ConvertFrom-Csv -Delimiter $CsvDelimiter | Select-Object id, userId, name
}

$filesToBeRemove = Read-DriveItemsFromCSV -path $CsvPath
$filesToBeRemove | Select-Object -First 20 | Format-Table
if ($PermanentDelete){
    Write-Host -BackgroundColor Magenta -ForegroundColor Black " Waring the files will be removed permanently!! "
}
Write-Host "There are $($filesToBeRemove.Length) file(s) to removed, do you want to continue (y,N)"
$conform = Read-Host

if ($conform.ToLower() -ne "y") {
    write-host "Exiting..."
    Exit-PSSession
    return 1
}

$token = Get-AccessToken 
$headers = @{
    Authorization = "Bearer $token"
}

Write-Progress -Activity "Removing files..." -PercentComplete 0 
$count = 1
foreach ($item in $filesToBeRemove) {
    Write-Progress -Activity "Removing files..." -Status "($count/$($filesToBeRemove.count)) $($item.id) | $($item.name)" -PercentComplete $(100 * $count / $filesToBeRemove.count)
    Remove-DriveItem -UserId $item.userId -FileId $item.id | Out-Null
    $count++
}
