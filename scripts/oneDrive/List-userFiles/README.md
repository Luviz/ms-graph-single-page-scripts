# List-UserFiles

This tool will crawl through a users OneDrive Extracting all file metadata. 
The results can be pushed in to a CSV for other needs.

## Permissions

- User.ReadBasic.All
- File.Read.All

## Use cases

Create csv rapport 
```powershell
.\List-UserFiles.ps1 -userId <userId> | ConvertTo-Csv -NoTypeInformation > .\raport.csv
```

