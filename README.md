# BlockShit PowerShell Script 🚫💻

This PowerShell script allows you to block executables within a given directory using Windows Firewall rules. It recursively goes through the specified folder (and all its subfolders) to create inbound and outbound firewall block rules for each `.exe` file found.

## Features:
- **Automated Firewall Rules**: Automatically creates inbound and outbound block rules for all `.exe` files in a directory.
- **Recursive Search**: Scans the entire directory, including all subdirectories, to find `.exe` files.
- **Admin Privileges Check**: Ensures the script is running with elevated privileges (administrator rights).
- **Easy Usage**: Simple to run, requires only the path to the directory containing the files you want to block.

## Requirements:
1. **Admin Rights**: You need to run this script as an administrator.
2. **Unrestricted Execution Policy**: Make sure your execution policy is set to `Unrestricted`. You can check and change the execution policy with the following commands:
   - To check current execution policy:  
     ```powershell
     Get-ExecutionPolicy
     ```
   - If it's `Restricted`, set it to `Unrestricted` with:  
     ```powershell
     Set-ExecutionPolicy Unrestricted
     ```

## How to Use:

1. **Open PowerShell as Administrator**:  
   Right-click on PowerShell and select "Run as Administrator."
   
2. **Run the Script**:  
   Provide the path of the directory you want to block executables for, and the script will create inbound and outbound rules for each `.exe` file in the directory.
   
   Example:  
   ```powershell
   C:\Program Files\example
   ```

3. **Script Output**:  
   The script will display messages for each created rule. If any errors occur during the process, they will be shown in red.

## Example Usage:
When prompted, enter the directory path you want to block. For example:
```
Enter the dir path of desired shit to be blocked: C:\Program Files\Example
```

The script will automatically create the firewall rules:
```
Outbound rule created for shit - C:\Program Files\Example\app.exe: BlockedShit_app_Outbound
Inbound rule created for shit - C:\Program Files\Example\app.exe: BlockedShit_app_Inbound
```

## Notes:
- **Directory Path**: Ensure the directory path you enter is unquoted, especially when copying it by right-clicking in File Explorer.
- **Error Handling**: If the entered path is invalid, the script will notify you to re-run it with a valid path.
  
---

Enjoy blocking unwanted executables with ease! 🚫