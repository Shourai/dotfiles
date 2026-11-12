"""Run with: python3 -m unittest discover -s tests. All writes stay in temporary directories."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest

REPO = Path(__file__).resolve().parents[1]


class DotfilesTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="dotfiles-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name)
        self.env = dict(os.environ, HOME=str(self.home))

    def bash(self, script):
        return subprocess.run(
            ["bash", "-c", script], cwd=REPO, env=self.env,
            text=True, capture_output=True,
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
