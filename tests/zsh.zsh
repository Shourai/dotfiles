#!/usr/bin/env zsh
# Run with zsh -f tests/zsh.zsh; tools and HOME are isolated in a temporary directory.
setopt ERR_EXIT PIPE_FAIL
repo=${0:A:h:h}
tmp=$(mktemp -d)
trap 'rm -rf -- "$tmp"' EXIT
export HOME="$tmp/home" XDG_DATA_HOME="$tmp/home/.local/share"
export TEST_BREW_CALLS="$tmp/brew-calls"
original_path=($path)
original_fpath=($fpath)

# Exercise the actual PATH block with executable Homebrew stand-ins at all three locations.
path_code=$(awk '/^# --- PATH ---/{copy=1; next} /^# --- ALIASES ---/{copy=0} copy' "$repo/zsh/.zshrc")
path_code=${path_code//\/opt\/homebrew\/bin\/brew/$tmp/apple/bin/brew}
path_code=${path_code//\/usr\/local\/bin\/brew/$tmp/intel/bin/brew}
path_code=${path_code//\/home\/linuxbrew\/.linuxbrew\/bin\/brew/$tmp/linux/bin/brew}
for platform in apple intel linux; do
  mkdir -p "$tmp/$platform/bin"
  cat > "$tmp/$platform/bin/brew" <<'EOF'
#!/bin/sh
printf '%s\n' "$0" >> "$TEST_BREW_CALLS"
prefix=${0%/bin/brew}
printf 'export HOMEBREW_PREFIX="%s"\n' "$prefix"
printf 'export HOMEBREW_CELLAR="%s/Cellar"\n' "$prefix"
printf 'export HOMEBREW_REPOSITORY="%s"\n' "$prefix"
printf 'path=("%s/bin" "%s/sbin" $path)\n' "$prefix" "$prefix"
printf 'fpath=("%s/share/zsh/site-functions" $fpath)\n' "$prefix"
EOF
  chmod +x "$tmp/$platform/bin/brew"
done
unset HOMEBREW_PREFIX HOMEBREW_CELLAR HOMEBREW_REPOSITORY
eval "$path_code"
[[ "$HOMEBREW_PREFIX" == "$tmp/apple" ]]
[[ "$path[1]" == "$HOME/.local/bin" && "$path[2]" == "$tmp/apple/bin" ]]
[[ "$fpath[1]" == "$tmp/apple/share/zsh/site-functions" ]]

# A child shell inherits environment but starts with a fresh completion path.
fpath=($original_fpath)
eval "$path_code"
[[ $(wc -l < "$TEST_BREW_CALLS") -eq 1 ]]
[[ "$fpath[1]" == "$tmp/apple/share/zsh/site-functions" ]]
[[ ${#${(M)path:#$tmp/apple/bin}} -eq 1 ]]
[[ ${#${(M)fpath:#$tmp/apple/share/zsh/site-functions}} -eq 1 ]]

chmod -x "$tmp/apple/bin/brew"
eval "$path_code"
[[ "$HOMEBREW_PREFIX" == "$tmp/intel" ]]
chmod -x "$tmp/intel/bin/brew"
eval "$path_code"
[[ "$HOMEBREW_PREFIX" == "$tmp/linux" ]]
[[ $(wc -l < "$TEST_BREW_CALLS") -eq 3 ]]
print 'Homebrew initialization checks passed.'

path=($original_path)
fpath=($original_fpath)
export GIT_CONFIG_GLOBAL=/dev/null GIT_CONFIG_NOSYSTEM=1
mkdir -p "$tmp/git"
cd "$tmp/git"
git init -q -b main

# The picker mock preserves its delimiter and selects an exact requested input record.
fzf() {
  [[ "${TEST_FZF_CANCEL:-0}" == 1 ]] && return 130
  python3 -c '
import os, sys
delimiter = b"\0" if "--read0" in sys.argv else b"\n"
records = sys.stdin.buffer.read().split(delimiter)
wanted = os.fsencode(os.environ["TEST_FZF_SELECT"])
if wanted not in records:
    sys.exit(1)
sys.stdout.buffer.write(wanted + delimiter)
' "$@"
}
test_editor() { printf '%s\0' "$@" > "$tmp/editor-args"; }
EDITOR=test_editor
eval "$(awk '/^  gf\(\)/{copy=1} /^  # gb:/{copy=0} copy' "$repo/zsh/.zshrc")"
for name in 'café notes.txt' '-option.txt' $'line\nbreak\n'; do
  touch -- "$name"
  git add -- "$name"
  export TEST_FZF_SELECT="$name"
  gf
  cmp "$tmp/editor-args" <(printf '%s\0' -- "$name")
done
rm "$tmp/editor-args"
export TEST_FZF_CANCEL=1
if gf; then
  print -u2 'gf unexpectedly succeeded after cancellation'
  exit 1
fi
[[ ! -e "$tmp/editor-args" ]]
unset TEST_FZF_CANCEL
print 'Git file-picker checks passed.'
