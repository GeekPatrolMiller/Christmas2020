###
### Modified by Gregory Miller, Dec 2020
### Function Collections have attribution added within each code block
###

function Show-Process($Process, [Switch]$Maximize)
{
    ### Borrowed from : https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/bringing-window-in-the-foreground
    ### Takes a Process object as a parameter and 
    $sig = '
        [DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
        [DllImport("user32.dll")] public static extern int SetForegroundWindow(IntPtr hWnd);
    '
    if ($Maximize) { $Mode = 3 } else { $Mode = 4 }
    $type = Add-Type -MemberDefinition @$sig -Name WindowAPI -PassThru
    $hWnd = $process.MainWindowHandle
    $null = $type::ShowWindowAsync($hWnd, $Mode)
    $null = $type::SetForegroundWindow($hWnd) 
}

function Show-Window {
    ### Borrowed From : https://stackoverflow.com/questions/42566799/how-to-bring-focus-to-window-by-process-name
    param(
        [Parameter(Mandatory)]
        [string] $ProcessName
    )

    # As a courtesy, strip '.exe' from the name, if present.
    $ProcessName = $ProcessName -replace '\.exe$'

    # Get the PID of the first instance of a process with the given name
    # that has a non-empty window title.
    # NOTE: If multiple instances have visible windows, it is undefined
    #       which one is returned.
    $hWnd = (Get-Process -ErrorAction Ignore $ProcessName).Where({ $_.MainWindowTitle }, 'First').MainWindowHandle

    if (-not $hWnd) { Throw "No $ProcessName process with a non-empty window title found." }

    $type = Add-Type -PassThru -NameSpace Util -Name SetFgWin -MemberDefinition @'
        [DllImport("user32.dll", SetLastError=true)] public static extern bool SetForegroundWindow(IntPtr hWnd);
        [DllImport("user32.dll", SetLastError=true)] public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);    
        [DllImport("user32.dll", SetLastError=true)] public static extern bool IsIconic(IntPtr hWnd);    // Is the window minimized?
'@ 

    # Note: 
    #  * This can still fail, because the window could have bee closed since
    #    the title was obtained.
    #  * If the target window is currently minimized, it gets the *focus*, but its
    #    *not restored*.
    $null = $type::SetForegroundWindow($hWnd)
    # If the window is minimized, restore it.
    # Note: We don't call ShowWindow() *unconditionally*, because doing so would
    #       restore a currently *maximized* window instead of activating it in its current state.
    if ($type::IsIconic($hwnd)) {
        $type::ShowWindow($hwnd, 9) # SW_RESTORE
    }

}