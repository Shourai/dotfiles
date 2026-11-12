"""Run with: python3 -m unittest discover -s tests. All writes stay in temporary directories."""

import os
from pathlib import Path
import re
import shutil
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class DotfilesTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        self.env = dict(os.environ, HOME=str(self.home))

    def bash(self, script):
        return subprocess.run(
            ["bash", "-c", script], cwd=REPO, env=self.env,
            text=True, capture_output=True,
        )

    def setup_script(self, name, mocks, *flags):
        tree = self.home / "Documents/github/dotfiles"
        shutil.copytree(REPO / "setup", tree / "setup")
        shutil.copytree(REPO / "packages", tree / "packages")
        (tree / "macos").mkdir()
        shutil.copy2(REPO / "macos/com.local.KeyRemapping.plist", tree / "macos")
        with (tree / "setup/lib.sh").open("a") as lib:
            lib.write("\n" + mocks + "\n")
        return subprocess.run(
            ["bash", str(tree / "setup" / name), *flags], env=self.env,
            text=True, capture_output=True,
        )

    def test_failed_arch_upgrade_stops_dependent_operations(self):
        result = self.setup_script("arch.sh", r'''
is_arch() { return 0; }
run() { printf '%s\n' "$*" >> "$HOME/actions"; return 1; }
''')
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("system upgrade failed", result.stderr)
        self.assertEqual(
            (self.home / "actions").read_text().splitlines(),
            ["sudo pacman -Syu --needed --noconfirm base-devel git"],
        )

    def test_arch_dry_run_does_not_create_yay_directory(self):
        result = self.setup_script("arch.sh", r'''
is_arch() { return 0; }
has() { [ "$1" != yay ]; }
mktemp() { printf 'unexpected mktemp\n' >&2; return 1; }
''', "--dry-run")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertNotIn("unexpected mktemp", result.stderr)
        self.assertIn("<temporary-directory>", result.stdout)

    def test_arch_package_list_paths_with_spaces(self):
        result = self.setup_script("arch.sh", r'''
is_arch() { return 0; }
has() { return 0; }
run() { printf '%s\n' "$@" >> "$HOME/actions"; }
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        args = (self.home / "actions").read_text().splitlines()
        for package in ("bat", "fzf", "hyprland", "firefox-developer-edition", "man-db"):
            self.assertIn(package, args)
        for package in ("chromium", "brave-bin", "1password", "buku"):
            self.assertNotIn(package, args)

    def test_macos_package_list_paths_with_spaces(self):
        result = self.setup_script("macos.sh", r'''
is_macos() { return 0; }
has() { return 0; }
run() { printf '%s\n' "$@" >> "$HOME/actions"; }
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        args = (self.home / "actions").read_text().splitlines()
        for package in ("bat", "fzf", "shellcheck", "coreutils", "ghostty"):
            self.assertIn(package, args)

    def test_keyremap_only_copies_launch_agent(self):
        result = self.setup_script("macos.sh", r'''
is_macos() { return 0; }
load_brew() { printf 'unexpected Homebrew initialization\n' >&2; exit 99; }
has() { printf 'unexpected tool check\n' >&2; exit 99; }
''', "--keyremap")
        self.assertEqual(result.returncode, 0, result.stderr)
        tree = self.home / "Documents/github/dotfiles"
        agent = self.home / "Library/LaunchAgents/com.local.KeyRemapping.plist"
        expected = (REPO / "macos/com.local.KeyRemapping.plist").read_bytes()
        self.assertEqual(agent.read_bytes(), expected)

        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        (bin_dir / "uname").write_text('#!/bin/sh\nprintf "Darwin\\n"\n')
        for tool in ("sudo", "brew", "git", "curl"):
            (bin_dir / tool).write_text('#!/bin/sh\nprintf "unexpected command: %s\\n" "$0" >&2\nexit 99\n')
        for tool in bin_dir.iterdir():
            tool.chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]
        for entrypoint in (REPO / "install", tree / "setup/macos.sh"):
            with self.subTest(entrypoint=entrypoint):
                agent.unlink()
                result = subprocess.run(
                    ["bash", str(entrypoint), "--keyremap"], env=self.env,
                    text=True, capture_output=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(agent.read_bytes(), expected)
                shutil.rmtree(agent.parent)
                result = subprocess.run(
                    ["bash", str(entrypoint), "--keyremap", "--dry-run"], env=self.env,
                    text=True, capture_output=True,
                )
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertFalse(agent.parent.exists())
                self.assertIn("[dry-run]", result.stdout)
                agent.parent.mkdir(parents=True)
                agent.write_bytes(expected)
        self.assertFalse((self.home / ".config").exists())
        self.assertFalse((self.home / "Documents/github/nvim").exists())

    def test_keyremap_requires_existing_checkout(self):
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        uname = bin_dir / "uname"
        uname.write_text('#!/bin/sh\nprintf "Darwin\\n"\n')
        uname.chmod(0o755)
        for tool in ("sudo", "brew", "git", "curl"):
            blocker = bin_dir / tool
            blocker.write_text('#!/bin/sh\nexit 99\n')
            blocker.chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]
        result = subprocess.run(
            ["bash", str(REPO / "install"), "--keyremap"], env=self.env,
            text=True, capture_output=True,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("existing checkout", result.stderr)
        self.assertFalse((self.home / "Library").exists())
        self.assertFalse((self.home / "Documents").exists())

    def test_other_setup_scripts_reject_keyremap(self):
        result = self.setup_script("link.sh", r'''
load_brew() { printf 'unexpected Homebrew initialization\n' >&2; exit 99; }
''', "--keyremap")
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("only supported", result.stderr)
        self.assertFalse((self.home / ".config").exists())

    def test_zdotdir_is_idempotent_and_refuses_conflicts(self):
        function = re.search(
            r"(?ms)^set_zdotdir\(\) \{.*?^\}",
            (REPO / "setup/zsh.sh").read_text(),
        ).group()
        script = 'source setup/lib.sh\nrun() { shift; "$@"; }\n' + function
        script += '\nset_zdotdir "$HOME/zshenv"\n'
        target = self.home / "zshenv"
        expected = 'export ZDOTDIR="$HOME/.config/zsh"\n'
        for _ in range(2):
            result = self.bash(script)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(target.read_text(), expected)
        for conflict in ('export ZDOTDIR="$HOME/.old-zsh"\n', '  ZDOTDIR=/other\n'):
            with self.subTest(conflict=conflict):
                target.write_text(conflict)
                result = self.bash(script)
                self.assertNotEqual(result.returncode, 0)
                self.assertIn("conflicting ZDOTDIR", result.stderr)
                self.assertEqual(target.read_text(), conflict)

    def test_screenshot_preserves_clipboard_on_failure(self):
        command = re.search(
            r'hl.bind\("ALT \+ CTRL \+ S", hl.dsp.exec_cmd\(\[\[(.*?)\]\]\)\)',
            (REPO / "arch/wayland/hypr/hyprland.lua").read_text(), re.S,
        ).group(1)
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        writer = bin_dir / "wl-copy"
        writer.write_text('#!/bin/sh\ncat > "$HOME/clipboard"\n')
        writer.chmod(0o755)
        self.env["PATH"] = str(bin_dir) + os.pathsep + self.env["PATH"]
        mocks = r'''
slurp() { printf '0,0 10x10\n'; }
mktemp() { command mktemp "$HOME/image.XXXXXX"; }
grim() { printf 'PNG fixture' > "$3"; }
'''
        cases = (
            ("cancel", 'slurp() { return 1; }', 0, "previous"),
            ("capture failure", 'grim() { printf partial > "$3"; return 1; }', 1, "previous"),
            ("allocation failure", 'mktemp() { return 1; }', 1, "previous"),
            ("success", "", 0, "PNG fixture"),
        )
        for name, override, status, expected in cases:
            with self.subTest(case=name):
                clipboard = self.home / "clipboard"
                clipboard.write_text("previous")
                result = subprocess.run(
                    ["sh", "-c", mocks + override + "\n" + command],
                    env=self.env, text=True, capture_output=True,
                )
                self.assertEqual(result.returncode, status, result.stderr)
                self.assertEqual(clipboard.read_text(), expected)
                self.assertEqual(list(self.home.glob("image.*")), [])

    def test_backup_collisions_preserve_files_and_broken_links(self):
        result = self.bash(r'''
set -euo pipefail
source setup/lib.sh
date() { printf '20260101-000000\n'; }
printf 'first\n' > "$HOME/config"
backup "$HOME/config"
ln -s missing "$HOME/config.bak-20260101-000000-1"
printf 'second\n' > "$HOME/config"
backup "$HOME/config"
DRY_RUN=1
printf 'third\n' > "$HOME/config"
backup "$HOME/config"
''')
        self.assertEqual(result.returncode, 0, result.stderr)
        base = self.home / "config.bak-20260101-000000"
        self.assertEqual(base.read_text(), "first\n")
        self.assertTrue(Path(str(base) + "-1").is_symlink())
        self.assertEqual(Path(str(base) + "-2").read_text(), "second\n")
        self.assertEqual((self.home / "config").read_text(), "third\n")
        self.assertFalse(Path(str(base) + "-3").exists())


if __name__ == "__main__":
    unittest.main()
