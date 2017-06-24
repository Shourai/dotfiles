# macOS changes 

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
defaults write com.apple.dock persistent-apps -array

# Set the dock's orientation to the right
defaults write com.apple.dock orientation -string right

# Change the icon size to 30
defaults write com.apple.dock tilesize -float 30

# Enable dock autohide
defaults write com.apple.dock autohide -bool true

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable Bluetooth
sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

# Remove airplay icon in menubar
defaults write com.apple.airplay showInMenuBarIfPresent -bool false

# Hide recent tags in finder
defaults write com.apple.finder ShowRecentTags -bool false

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

# Four finger vertical swipe enable
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2

# Three finger horizontal swipe disable
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0

# Enable three finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Enable expose and mission control
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

# Set tracking speed
defaults write -g com.apple.trackpad.scaling -float 2.5

# Set keyboard delay until repeat to short
defaults write -g InitialKeyRepeat -int 15

# Set keyboard keyrepeat to fast
defaults write -g KeyRepeat -int 1

# Disable reopen windows when logging back in
defaults write com.apple.loginwindow TALLogoutSavesState -bool false

# Disable the sound effects on boot
#sudo nvram SystemAudioVolume=" "

# Enable trim
# Only needed if you have a mac without an official Apple SSD
# sudo trimforce enable
