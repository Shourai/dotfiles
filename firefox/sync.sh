# Simple script to copy userChrome and userContent to the profile folder.
# userConten.css does not support symlinking see https://bugzilla.mozilla.org/show_bug.cgi?id=1427206

# echo "Enter <profileID>.default: "
# read profileID

profileID="h30x2e04"

source="$HOME/Documents/github/dotfiles/firefox"
target="$HOME/Library/Application Support/Firefox/Profiles/$profileID.default/chrome/"


if [ ! -d "$target" ]; then
  # Control will enter here if $dir doesn't exist.
    mkdir -v "$target"
fi

cp -f $source/userChrome.css "$target"
cp -f $source/userContent.css "$target"
cp -f $source/color_variables.css "$target"
cp -rf $source/userChrome-files "$target"
cp -rf $source/userContent-files "$target"
cp -rf $source/common-files "$target"