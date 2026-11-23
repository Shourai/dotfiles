"""Integration checks for tmux.conf. Skipped when tmux 3.8+ is not installed."""

import fcntl
import os
from pathlib import Path
import pty
import re
import select
import shutil
import struct
import subprocess
import tempfile
import termios
import time
import unittest

REPO = Path(__file__).resolve().parents[1]
TMUX = shutil.which("tmux")


def supported_tmux():
    if not TMUX:
        return False
    version = subprocess.run([TMUX, "-V"], text=True, capture_output=True).stdout
    match = re.search(r"tmux (\d+)\.(\d+)", version)
    return version.startswith("tmux next") or bool(match and tuple(map(int, match.groups())) >= (3, 8))


@unittest.skipUnless(supported_tmux(), "tmux 3.8+ is required")
class TmuxTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="tmux-test-")
        self.addCleanup(self.temp.cleanup)
        self.home = Path(self.temp.name) / "home with spaces"
        self.home.mkdir()
        config = self.home / ".config/tmux"
        config.mkdir(parents=True)
        (config / "tmux.conf").symlink_to(REPO / "tmux/tmux.conf")
        tpm = config / "plugins/tpm/tpm"
        tpm.parent.mkdir(parents=True)
        tpm.write_text('#!/bin/sh\nprintf loaded > "$HOME/tpm-loaded"\n')
        tpm.chmod(0o755)
        bin_dir = self.home / "bin"
        bin_dir.mkdir()
        (bin_dir / "tmux").symlink_to(TMUX)
        ps = bin_dir / "ps"
        ps.write_text('#!/bin/sh\nprintf called >> "$HOME/ps-calls"\nexit 1\n')
        ps.chmod(0o755)
        for name, content in {
            "zoxide": '#!/bin/sh\ncat "$HOME/dirs"\n',
            "fzf": '#!/bin/sh\ncat > "$HOME/input"\n[ ! -f "$HOME/cancel" ] || exit 130\ncat "$HOME/choice"\n',
        }.items():
            path = bin_dir / name
            path.write_text(content)
            path.chmod(0o755)
        self.env = dict(os.environ, HOME=str(self.home), TERM="xterm-256color",
                        TMUX_TMPDIR=self.temp.name, PATH=str(bin_dir) + os.pathsep + os.environ["PATH"])
        self.env.pop("TMUX", None)
        self.env.pop("TMUX_PANE", None)
        self.tmux("new-session", "-d", "-s", "api")
        self.tmux("new-session", "-d", "-s", "main")
        self.assertTrue((self.home / "tpm-loaded").exists())
        self.addCleanup(lambda: self.tmux("kill-server", check=False))
        self.pid, self.fd = pty.fork()
        if self.pid == 0:
            os.execve(TMUX, [TMUX, "attach-session", "-t", "main"], self.env)
        self.addCleanup(self.close_client)
        fcntl.ioctl(self.fd, termios.TIOCSWINSZ, struct.pack("HHHH", 30, 120, 0, 0))
        self.wait_for(lambda: self.tmux("list-clients").strip())

    def tmux(self, *args, check=True):
        result = subprocess.run([TMUX, *args], env=self.env, text=True, capture_output=True)
        if check and result.returncode:
            self.fail(f"tmux {args}: {result.stderr}")
        return result.stdout.strip()

    def close_client(self):
        os.close(self.fd)
        os.waitpid(self.pid, 0)

    def wait_for(self, predicate):
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            while select.select([self.fd], [], [], 0)[0]:
                try:
                    os.read(self.fd, 65536)
                except OSError:
                    break
            if predicate():
                return
            time.sleep(0.02)
        self.fail("timed out waiting for tmux")

    def pick(self, value, expected_session):
        (self.home / "choice").write_text(value + "\n")
        os.write(self.fd, b"\x02f")
        self.wait_for(lambda: self.tmux("list-clients", "-F", "#{session_name}") == expected_session)

    def test_project_picker_uses_paths_and_session_ids(self):
        first = self.home / "work 'quoted'/api"
        second = self.home / "personal/api"
        first.mkdir(parents=True)
        second.mkdir(parents=True)
        (self.home / "dirs").write_text(f"{first}\n{second}\n")

        self.pick(f"folder {first}", "api-2")  # existing unrelated api is not reused
        self.pick(f"folder {second}", "api-3")
        self.tmux("rename-session", "-t", "=api-2", "renamed")
        self.pick(f"folder {first}", "renamed")  # saved path survives a rename
        self.pick("session $0 api", "api")
        self.assertEqual(self.tmux("show-option", "-t", "api-3", "-qv", "@project-dir"), str(second))
        self.assertEqual(len(self.tmux("list-sessions").splitlines()), 4)

    @unittest.skipUnless(shutil.which("nvim"), "nvim is required")
    def test_vim_navigation_and_shell_navigation_avoid_process_scan(self):
        self.tmux("split-window", "-h")
        self.tmux("select-pane", "-t", ":.1")
        self.tmux("send-keys", "-t", ":.1", "nvim -u NONE", "Enter")
        self.wait_for(lambda: self.tmux("display-message", "-p", "-t", ":.1", "#{pane_current_command}") == "nvim")
        os.write(self.fd, b"\x0c")  # C-l is passed to Neovim without running ps.
        time.sleep(0.2)
        self.assertFalse((self.home / "ps-calls").exists())
        self.assertEqual(self.tmux("display-message", "-p", "#{pane_index}"), "1")
        self.tmux("send-keys", "-t", ":.1", "Escape", ":qa!", "Enter")
        self.wait_for(lambda: self.tmux("display-message", "-p", "-t", ":.1", "#{pane_current_command}") != "nvim")
        os.write(self.fd, b"\x0c")
        self.wait_for(lambda: self.tmux("display-message", "-p", "#{pane_index}") == "2")
        self.assertFalse((self.home / "ps-calls").exists())

    def test_osc52_copy_is_allowed_but_read_is_blocked(self):
        program = '''
import os, select, sys, tty
tty.setraw(0)
os.write(1, b"\\x1b]52;c;aGFybWxlc3M=\\x07")
os.write(1, b"\\x1b]52;c;?\\x07")
ready, _, _ = select.select([0], [], [], 0.3)
with open(os.environ["HOME"] + "/reply", "wb") as output:
    output.write(os.read(0, 1024) if ready else b"")
'''
        self.tmux("new-window", "-d", "-n", "osc", "python3", "-c", program)
        reply = self.home / "reply"
        self.wait_for(reply.exists)
        self.assertEqual(reply.read_bytes(), b"")
        self.assertEqual(self.tmux("show-buffer"), "harmless")

    def test_swap_panes_exits_pane_display_mode(self):
        self.tmux("split-window", "-h")
        self.tmux("select-pane", "-t", ":.1")
        before = self.tmux("list-panes", "-F", "#{pane_id}").splitlines()
        os.write(self.fd, b"\x02u")
        self.wait_for(lambda: "panes-mode" in self.tmux("list-panes", "-F", "#{pane_mode}"))
        os.write(self.fd, b"2")
        self.wait_for(lambda: self.tmux("list-panes", "-F", "#{pane_id}").splitlines() == before[::-1])
        self.assertNotIn("panes-mode", self.tmux("list-panes", "-F", "#{pane_mode}"))
        self.assertEqual(self.tmux("show-options", "-s", "-v", "get-clipboard"), "off")
        self.assertEqual(self.tmux("show-options", "-s", "-v", "set-clipboard"), "on")
