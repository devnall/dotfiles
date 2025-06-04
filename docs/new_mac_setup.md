# New Mac Setup

Notes for setting up a new MacOS machine.

- [TinkerTool](http://www.bresink.com/osx/0TinkerTool/download.php) - GUI wrapper for a bunch of "hidden" MacOS options. Some of the best are making the Dock snap in and out instantly, setting Finder to show path in window title, sending screenshots to a user-definied directory, disabling a Time Machine any time you plug in a new drive, and disabling creation of .DS_Store files on network drives.


## launchctl changes

- Disable Apple Music from auto-opening (when you press Play/Pause, connect bluetooth headphones, etc)
```
# Disables it immediately
launchctl bootout "gui/$(id -u "${USER}")/com.apple.rcd"
# Prevent from reactivating on reboot
launchctl disable "gui/$(id -u "${USER}")/com.apple.rcd"
```
To revert to the default behavior:
```
launchctl bootstrap "gui/$(id -u "${USER}")/com.apple.rcd"
launchctl enable "gui/$(id -u "${USER}")/com.apple.rcd"
```
