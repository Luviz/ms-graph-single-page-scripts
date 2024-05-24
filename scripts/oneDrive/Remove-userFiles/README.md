# Remove-UserFiles

Given a CSV containing files with properties of `id`, `name` and `userId` the script will remove each item one by on.
Work well with `List-UsersFiles`

## Permissions

- User.ReadBasic.All
- File.ReadWrite.All

## Use case

```powershell
.\Remove-UserFiles.ps1 -CsvPath .\rapport.csv 
```

```powershell
.\Remove-UserFiles.ps1 -CsvPath .\rapport.csv -CsvDelimiter '|' 
```

```powershell
.\Remove-UserFiles.ps1 -CsvPath .\rapport.csv -PermanentDelete
```