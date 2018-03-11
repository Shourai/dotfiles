# Simple script to copy userChrome and userContent to the profile folder with latest updates.
# userContent.css does not support symlinking see https://bugzilla.mozilla.org/show_bug.cgi?id=1427206

# echo "Enter <profileID>.default: "
# read profileID

# Define profileID
profileID="h30x2e04"

# Define paths
shadowfox="$HOME/Documents/github/ShadowFox"
source="$HOME/Documents/github/dotfiles/firefox"
target="$HOME/Library/Application Support/Firefox/Profiles/$profileID.default/chrome/"

# Check existence ShadowFox repo else clone it and add upstream repo
if [ ! -d "$shadowfox" ]; then
  # Control will enter here if $dir doesn't exist.
  git clone git@github.com:Shourai/ShadowFox.git $shadowfox
  git -C $shadowfox remote add upstream git@github.com:overdodactyl/ShadowFox.git
fi

# Get the latest updates and assign stdout to output
git -C $shadowfox pull

# Check the existence of chrome folder, mkdir if non existent
if [ ! -d "$target" ]; then
  # Control will enter here if $dir doesn't exist.
    mkdir -v "$target"
fi

# Copy files to chrome folder
cp  $source/userChrome.css "$target"
cp  $source/userContent.css "$target"
cp  $shadowfox/color_variables.css "$target"
cp -R $shadowfox/userChrome-files "$target"
cp -R $shadowfox/userContent-files "$target"
cp -R $shadowfox/common-files "$target"

echo "userChrome and userContent files succesfully copied!"

# Insert any UUIDs defined in internal_UUIDs.txt into userContent.css
while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS='=' read -r -a array <<< "$line"
    webextension_name=${array[0]%_UUID}
    sed -i '' "s/${array[0]}/${array[1]}/" "$target/userContent-files/webextension-tweaks/${webextension_name}.css"
done < "internal_UUIDs.txt"

echo "UUIDs succesfully applied!"