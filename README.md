# close_apps_mac

## Purpose

The `close_apps_mac` script makes multitasking on macOS more efficient by automatically closing applications that no longer have active windows. macOS apps generally need to be quit manually by navigating to **App Name > Quit App Name** in the top menu bar or by using the keyboard shortcut **⌘Q**. While this is the default behaviour, it can become tedious when managing multiple applications. This script streamlines the process by identifying and quitting such apps automatically.

---

## Features

1. **Automated App Closing**:
   - Detects apps with no active windows and attempts to quit them.

2. **Graceful and Force Quit Logic**:
   - Attempts to quit apps gracefully first, then force-quits them if necessary.

3. **System App Exclusion**:
   - Excludes critical system apps (e.g., Finder, Dock, System Settings, Terminal) from being closed.

4. **Detailed Logging**:
   - Logs information about:
     - Apps closed gracefully.
     - Apps closed forcefully.
     - Apps that failed to close.
     - Remaining open non-system apps.

5. **Electron App Handling**:
   - Identifies Electron-based apps (e.g., Visual Studio Code) for improved logging and behaviour.

6. **User Alerts**:
   - Notifies the user when the script starts and completes execution.

7. **Error Handling**:
   - Basic error handling ensures smooth execution without unexpected crashes.

8. **Comprehensive Reporting**:
   - Provides a summary of actions, including total apps closed and apps that remain running.

---

## How to Use

### Prerequisites

1. **Terminal App Permissions**:
   - Ensure Terminal has permission to control your Mac:
     1. Open **System Settings**.
     2. Navigate to **Privacy & Security > Accessibility**.
     3. Add Terminal to the list and enable it.

2. **Executable Script**:
   - Save the script with a `.sh` extension (e.g., `close_apps_mac.sh`).

---

### Running the Script

1. **Open Terminal**:
   - Navigate to the directory where the script is saved.

2. **Make the Script Executable**:
   - Run the following command:
     ```bash
     chmod +x close_apps_mac.sh
     ```

3. **Execute the Script**:
   - Run the script by typing:
     ```bash
     ./close_apps_mac.sh
     ```

4. **Review the Output**:
   - The script will log its progress and provide a summary in the Terminal.

---

## Additional Notes

- **Security Warning**:
  - The script interacts with system processes and may require admin privileges to execute certain commands. Use it responsibly and only run scripts from trusted sources.

- **Electron Apps**:
  - Apps like Visual Studio Code, which often persist in the background, are handled effectively by the script but may require force-quitting if a graceful shutdown isn't possible.

---

## Troubleshooting

1. **Script Fails to Close Apps**:
   - Ensure Terminal has the necessary permissions as outlined in the prerequisites.

2. **Error Messages**:
   - Review the logs in the Terminal. The script provides detailed feedback on failures, which can guide troubleshooting.

---

This script is a robust tool for macOS users looking to streamline their workflow by managing app lifecycles automatically. It’s especially useful for developers and power users frequently switching between multiple tasks.
