#!/bin/bash
echo "Starting script to close apps without windows..."

osascript <<'EOF'
use framework "Foundation"
use framework "AppKit"
use scripting additions

-- Variables
set gracefullyClosedApps to {}
set forciblyClosedApps to {}
set failedToCloseApps to {}
set systemApps to {"Finder", "Dock", "System Settings", "System Events", "loginwindow", "Terminal", "iTerm2", "iTerm"}

-- Get detailed info about running apps using NSWorkspace
set runningAppsInfo to {}
set nsRunningApps to current application's NSWorkspace's sharedWorkspace()'s runningApplications() as list
repeat with rApp in nsRunningApps
    set nsName to (rApp's localizedName()) as text
    if nsName is missing value then
        set nsName to "UnknownAppName"
    end if

    set nsBundleID to rApp's bundleIdentifier()
    if nsBundleID is missing value then
        set nsBundleID to "UnknownBundleID"
    else
        set nsBundleID to nsBundleID as text
    end if

    set end of runningAppsInfo to {appName:nsName, bundleID:nsBundleID}
end repeat

-- Lookup app info by name
on lookupAppInfo(appName, appList)
    repeat with itemRecord in appList
        if appName is (itemRecord's appName) then
            return itemRecord
        end if
    end repeat
    return {appName:appName, bundleID:"UnknownBundleID"}
end lookupAppInfo

-- Process running processes
tell application "System Events"
    set runningProcesses to every process whose background only is false
end tell

repeat with proc in runningProcesses
    try
        set appName to name of proc as text
        if systemApps does not contain appName then
            set appInfo to lookupAppInfo(appName, runningAppsInfo)
            set bundleID to (appInfo's bundleID)

            tell application "System Events"
                try
                    set windowCount to count of windows of process appName
                on error
                    set windowCount to 0
                end try
            end tell

            if windowCount is 0 then
                -- Attempt graceful quit
                try
                    tell application appName to quit
                    delay 3
                    tell application "System Events"
                        if not (exists process appName) then
                            set end of gracefullyClosedApps to appName
                        else
                            -- Force quit
                            do shell script "killall '" & appName & "'"
                            delay 1
                            if not (exists process appName) then
                                set end of forciblyClosedApps to appName
                            else
                                set end of failedToCloseApps to appName
                            end if
                        end if
                    end tell
                on error
                    set end of failedToCloseApps to appName
                end try
            end if
        end if
    end try
end repeat

-- Summary
log "
Summary:
---------"
if (count of gracefullyClosedApps) > 0 then
    log "Gracefully closed apps: " & gracefullyClosedApps
else
    log "Gracefully closed apps: None"
end if

if (count of forciblyClosedApps) > 0 then
    log "Force-closed apps: " & forciblyClosedApps
else
    log "Force-closed apps: None"
end if

if (count of failedToCloseApps) > 0 then
    log "Failed to close apps: " & failedToCloseApps
else
    log "Failed to close apps: None"
end if

set totalClosed to (count of gracefullyClosedApps) + (count of forciblyClosedApps)
log "Total apps closed: " & totalClosed

tell application "System Events"
    set remainingApps to name of every process whose background only is false
    set remainingNonSystemApps to {}
    repeat with rApp in remainingApps
        set rAppName to rApp as text
        if systemApps does not contain rAppName then
            set end of remainingNonSystemApps to rAppName
        end if
    end repeat
end tell

if (count of remainingNonSystemApps) > 0 then
    log "Remaining open apps: " & remainingNonSystemApps
else
    log "No non-system apps remaining open"
end if

log "Script completed."
EOF

echo "Script finished execution."
