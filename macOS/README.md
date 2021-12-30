# MacOS

### Key remap
Remapping a mac keyboard which is not in US layout

Move `com.local.KeyRemapping.plist` to `~/Library/LaunchAgents/com.local.KeyRemapping.plist`.


| From                   | Keycode     | To                     | Keycode     |
|------------------------|-------------|------------------------|-------------|
| backslash              | 0x700000031 | return_or_enter        | 0x700000028 |
| grave_accent_and_tilde | 0x700000035 | backslash (\)          | 0x700000031 |
| non_us_backslash (§/±) | 0x700000064 | grave_accent_and_tilde | 0x700000035 |
