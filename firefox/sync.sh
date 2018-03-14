#!/usr/bin/env bash

# Simple script to copy userChrome and userContent to the profile folder with latest updates.
# userContent.css does not support symlinking see https://bugzilla.mozilla.org/show_bug.cgi?id=1427206

# Test for bash version, we need at least version 4.
if [ $(bash -c 'echo ${BASH_VERSINFO[0]}') -lt 4 ]; then
    echo "Needs bash version >4"
    exit 1
fi

# Define paths
# Only works when there is only one profile
profile=$(find "$HOME/Library/Application Support/Firefox/Profiles"/* -maxdepth 0)
shadowfox="$HOME/Documents/github/ShadowFox"
source="$HOME/Documents/github/dotfiles/firefox"
target="$profile/chrome"

# Check the existence of chrome folder, mkdir if non existent
if [ ! -d "$target" ]; then
  # Control will enter here if $dir doesn't exist.
    mkdir -v "$target"
fi

# Copy files to chrome folder
read -p "Copy userChrome.css and userContent.css Y/N? " -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then
cp  $source/userChrome.css "$target"
cp  $source/userContent.css "$target"
echo "userChrome.css and userContent.css succesfully copied!"
fi

# Get the latest updates and assign uuids
read -p "Pull the latest commits from repo Y/N? " -n 1 -r
echo -e "\n"
if [[ $REPLY =~ ^[Yy]$ ]]; then

    # Check existence ShadowFox repo else clone it and add upstream repo
    if [ ! -d "$shadowfox" ]; then
    # Control will enter here if $dir doesn't exist.
    git clone git@github.com:Shourai/ShadowFox.git $shadowfox
    git -C $shadowfox remote add upstream git@github.com:overdodactyl/ShadowFox.git
    fi

    # Get the latest changes upstream
    git -C $shadowfox fetch upstream
    git -C $shadowfox merge upstream/master
    git -C $shadowfox push
    
    cp -R $shadowfox/css "$target"
    echo "Updated to latest version!"

    # Retrieve and set internal UUIDs
    declare -A styled=( 
                        ["{174b2d58-b983-4501-ab4b-07e71203cb43}"]="dark_mode"
                        ["@testpilot-containers"]="multi_account_containers"
                        ["uBlock0@raymondhill.net"]="ublock_origin"
                        ["uMatrix@raymondhill.net"]="umatrix"
                    )

    line=$(sed -n -e 's/^user_pref("extensions.webextensions.uuids", "{\(.*\).*}");/\1/p' "$profile/prefs.js")


    IFS=',' read -ra EXTS <<< "$line"
    for i in "${EXTS[@]}"; do
        id=$(echo $i | sed -n 's/.*"\(.*\)\\":.*/\1/p')
        uuid=$(echo $i | sed -n 's/.*"\(.*\)\\".*/\1/p')
        if [[ -n "${styled[$id]}" ]]
        then
            sed -i '' "s/${styled[$id]}_UUID/$uuid/" "$target/css/userContent-files/webextension-tweaks/${styled[$id]}.css"
        fi;
    done
    echo "UUIDs applied!"
fi
