"""Run with: python3 -m unittest discover -s tests. All writes stay in temporary directories."""

import os
from pathlib import Path
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
