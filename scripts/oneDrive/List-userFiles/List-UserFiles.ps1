param (
    [Parameter(Mandatory)]
    [string]
    $userId
)

## Comment above and uncomment below to hard code userId 

# $userId = "<userId>"

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

$msGraph = "https://graph.microsoft.com/v1.0"

function Get-FolderItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $UserId,
        [Parameter(Mandatory)]
        [string]
        $FolderId
    )
    $url = "$msGraph/users/$userId/drive/items/$folderId/children"
    $res = Invoke-WebRequest -Uri $url -Headers $headers
    if ($res.StatusCode -eq 200) {
        return $($res.Content | ConvertFrom-Json).value
    }
    Write-Error "Something went wrong!!"
}

function Get-UserFiles {
    param (
        [Parameter(Mandatory)]
        [string]
        $UserId
    )
    [collections.arraylist] $folders = @("root")
    [collections.arraylist] $files = @()
    Write-Progress -Activity "Crawling" -Status "folders left $($folders.Count)"
    while ($folders.Length -gt 1) {
        $folder = $folders[0]
        $folders.RemoveAt(0)
        if ($null -eq $folder ) { continue }
        $objects = Get-FolderItems -UserId $userId -FolderId $folder
        $files += $objects | Where-Object { $null -eq $_.PSObject.Properties["folder"] }
        $newFolders = $objects | Where-Object { $null -ne $_.PSObject.Properties["folder"] -and $_.folder.childCount -gt 0 }
        $folders += $newFolders.id
        Write-Progress -Activity "Crawling" -Status "folders left: $($folders.Count) | files collected: $($files.Count)"
    }
    return $files | ForEach-Object { $_ | Add-Member -MemberType NoteProperty -Name userId -Value $userId -PassThru }
}

if ($null -eq $headers) {
    $token = Get-AccessToken 
    $headers = @{
        Authorization = "Bearer $token"
    }
}

return Get-UserFiles -UserId $userId | Select-Object -Property "id", "name", "size", "webUrl", "userId"