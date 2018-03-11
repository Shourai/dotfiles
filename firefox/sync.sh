#!/usr/bin/env bash

# Simple script to copy userChrome and userContent to the profile folder with latest updates.
# userContent.css does not support symlinking see https://bugzilla.mozilla.org/show_bug.cgi?id=1427206

# Test for bash version, we need at least version 4.
if [ $(bash -c 'echo ${BASH_VERSINFO[0]}') -lt 4 ]; then
    echo "Needs bash version >4"
    exit 1
fi

# echo "Enter <profileID>.default: "
# read profileID

# Define profileID
profileID="h30x2e04"

# Define paths
shadowfox="$HOME/Documents/github/ShadowFox"
source="$HOME/Documents/github/dotfiles/firefox"
target="$HOME/Library/Application Support/Firefox/Profiles/$profileID.default/chrome"
profile="$HOME/Library/Application Support/Firefox/Profiles/$profileID.default"

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

git -C $shadowfox pull

cp  $shadowfox/color_variables.css "$target"
cp -R $shadowfox/userChrome-files "$target"
cp -R $shadowfox/userContent-files "$target"
cp -R $shadowfox/common-files "$target"
echo "Updated to latest version!"

# Retrieve and set internal UUIDs
declare -A styled=( 
                    ["{174b2d58-b983-4501-ab4b-07e71203cb43}"]="dark_mode"
                    ["@testpilot-containers"]="multi_account_containers"
                    ["uBlock0@raymondhill.net"]="ublock_origin"
                    ["uMatrix@raymondhill.net"]="umatrix"
                  )

line=$(sed -n -e '/^user_pref("extensions.webextensions.uuids"/p' "$profile/prefs.js")

## Remove prefix and suffix
prefix='user_pref("extensions.webextensions.uuids", "{'
suffix='}");'
line=${line#$prefix}
line=${line%$suffix}
prefix='\\"'
suffix='\\"'

IFS=',' read -ra EXTS <<< "$line"
for i in "${EXTS[@]}"; do
    id=${i%:*}
    uuid=${i#*:}
    id=${id#$prefix}
    id=${id%$suffix}
    uuid=${uuid#$prefix}
    uuid=${uuid%$suffix}
    if test "${styled[$id]+isset}"
    then
        sed -i '' "s/${styled[$id]}_UUID/$uuid/" "$target/userContent-files/webextension-tweaks/${styled[$id]}.css"
    fi;
done

fi
