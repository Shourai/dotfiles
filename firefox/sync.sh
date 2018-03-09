# Simple script to copy userChrome and userContent to the profile folder with latest updates.
# userContent.css does not support symlinking see https://bugzilla.mozilla.org/show_bug.cgi?id=1427206

# echo "Enter <profileID>.default: "
# read profileID

# Define profileID
profileID="h30x2e04"

shadowfox="$HOME/Documents/github/ShadowFox"
source="$HOME/Documents/github/dotfiles/firefox"
target="$HOME/Library/Application Support/Firefox/Profiles/$profileID.default/chrome/"

# Check existence ShadowFox repo
if [ ! -d "$shadowfox" ]; then
  # Control will enter here if $dir doesn't exist.
  git pull git@github.com:Shourai/ShadowFox.git
fi

# Get the latest updates
git -C $shadowfox pull

# Check the existence of chrome folder
if [ ! -d "$target" ]; then
  # Control will enter here if $dir doesn't exist.
    mkdir -v "$target"
fi

# Copy files to chrome folder
cp -f $source/userChrome.css "$target"
cp -f $source/userContent.css "$target"
cp -f $shadowfox/color_variables.css "$target"
cp -rf $shadowfox/userChrome-files "$target"
cp -rf $shadowfox/userContent-files "$target"
cp -rf $shadowfox/common-files "$target"

# Insert any UUIDs defined in internal_UUIDs.txt into userContent.css
while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS='=' read -r -a array <<< "$line"
    webextension_name=${array[0]%_UUID}
    sed -i '' "s/${array[0]}/${array[1]}/" "$target/userContent-files/webextension-tweaks/${webextension_name}.css"
done < "internal_UUIDs.txt"