# Get the id for which button was pressed
if($args.Count -ge 1){
    $param0=$args[0]
} else {
    
}
# Fully qualified path to location of all screipt files
# This requires an Environment Variable to be created that has a value of the required Path
$Folder = $Env:S16

# Import all of the associated modules for expanded functions
Import-Module -Force $Folder\ProcessSwitcher.psm1


# The following are the applications that this script will envoke. The name of the application should be exactly as shown in Task Manager
# Some applications can be started but they cannot be switched to because the container window has no Title. The windows 10 Calculator is one example
$appname = @(
    "encompass",        # 0 - Encompass
    "",          # 1 - 
    "firefox",          # 2 - FireFox Web Browser
    "",                 # 3 - ...
    "outlook",          # 4 - Outlook
    "word",             # 5 - Word
    "excel",            # 6 - Excel
    "powerpoint"<#,     # 7 - PowerPoint
    "",                 # 8 - ...
    "",                 # 9 - ...
    "",                 # 10 - ...
    "",                 # 11 - ...
    "",                 # 12 - ...
    "",                 # 13 - ...
    "",                 # 14 - ...
    ""                  # 15 - ...#>
)
# The following are the actual commands that if run from the "Win + R" Run screen, would cause the application to launch. Include the full path and filename
$launcher = @(
    "C:\SmartClientCache\Apps\Ellie Mae\Encompass\Encompass.exe",
    "C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE",
    "C:\Program Files\Mozilla Firefox\firefox.exe",
    "",
    "outlook",
    "winword",
    "excel",
    "powerpnt"<#,
    "",
    "",
    "",
    "",
    "",
    "",
    ""#>
)

if ( $appname[$param0] -ne "" -and $appname.Count -ge $param0 ) {
    $Running = Get-Process $appname[$param0] -ErrorAction SilentlyContinue
    if($null -eq ($Running).Id){
        Start-Process $launcher[$param0] -WindowStyle Normal -PassThru
    }else{
        Show-Window $appname[$param0]
    }
} else {
    # Display this message when there is no definition for the button that was activated
    "Button has not yet been defined"
    Pause
}