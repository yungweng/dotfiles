"""Exercise real Git hooks with synthetic data, without touching the working repo."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
TOKEN = "ghp_" + "Ab3dEf6hIj9kLm2nOp5qRs8tUv1wXy4zABCD"


class PrivacyHooks(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.repo = Path(self.temp.name)
        self.env = {k: v for k, v in os.environ.items() if not k.startswith("GIT_")}
        self.env.update(GIT_CONFIG_GLOBAL=os.devnull, GIT_CONFIG_NOSYSTEM="1")
        for name in (".gitleaks.toml", ".gitignore", "hooks/pre-commit", "hooks/pre-push"):
            dest = self.repo / name
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(ROOT / name, dest)
        self.git("init", "-q")
        self.git("config", "user.name", "Privacy Test")
        self.git("config", "user.email", "test@example.com")
        self.git("add", ".")
        self.git("commit", "-qm", "Clean base")
        self.git("config", "core.hooksPath", "hooks")

    def run_command(self, *args):
        return subprocess.run(args, cwd=self.repo, env=self.env, capture_output=True, text=True)

    def git(self, *args):
        result = self.run_command("git", *args)
        self.assertEqual(result.returncode, 0, "Git setup failed: " + " ".join(args))
        return result

    def stage(self, name, content, force=False):
        file = self.repo / name
        file.parent.mkdir(parents=True, exist_ok=True)
        file.write_text(content)
        self.git("add", *( ["-f"] if force else []), "--", name)

    def assert_blocked(self, hook):
        result = self.run_command("bash", "hooks/" + hook)
        self.assertEqual(result.returncode, 1, "Expected privacy block")
        self.assertNotIn(TOKEN, result.stdout + result.stderr)

    def test_clean_commit_and_history_pass(self):
        self.stage("safe file.txt", "Public configuration\n")
        self.git("commit", "-qm", "Safe change")
        self.assertEqual(self.run_command("bash", "hooks/pre-push").returncode, 0)

    def test_default_token_rule_blocks_staged_secret(self):
        self.stage("credentials.txt", f'token = "{TOKEN}"\n')
        self.assert_blocked("pre-commit")

    def test_zed_hostname_blocks_even_in_minified_json(self):
        self.stage("zed/.config/zed/settings.json",
                   '{"theme":"light","ssh_connections":[{"host":"server.example"}]}\n')
        self.assert_blocked("pre-commit")

    def test_force_added_local_settings_block(self):
        self.stage("zed/.config/zed/global_settings.json", "{}\n", force=True)
        self.assert_blocked("pre-commit")

    def test_private_skill_is_local_and_force_add_is_blocked(self):
        self.stage("claude/.claude/skills/private-workflow/SKILL.md",
                   "Private project instructions\n", force=True)
        self.assert_blocked("pre-commit")

    def test_system_skill_is_local_and_force_add_is_blocked(self):
        self.stage("claude/.claude/skills/.system/example/SKILL.md",
                   "Installer-managed instructions\n", force=True)
        self.assert_blocked("pre-commit")

    def test_explicitly_shared_skill_can_be_committed(self):
        self.stage("claude/.claude/skills/pr-screenshots/SKILL.md",
                   "Public screenshot workflow\n")
        self.git("commit", "-qm", "Share reviewed skill")

    def test_existing_zed_connections_block_unrelated_settings_change(self):
        name = "zed/.config/zed/settings.json"
        content = '{\n"ssh_connections": [{"host":"server.example"}],\n"theme":"light"\n}\n'
        self.stage(name, content)
        self.git("-c", "core.hooksPath=/dev/null", "commit", "-qm", "Synthetic server config")
        self.stage(name, content.replace('"light"', '"dark"'))
        self.assert_blocked("pre-commit")

    def test_staged_secret_blocks_even_when_worktree_is_clean(self):
        self.stage("credentials.txt", f'token = "{TOKEN}"\n')
        (self.repo / "credentials.txt").write_text("safe\n")
        self.assert_blocked("pre-commit")

    @unittest.skipUnless(shutil.which("shellcheck"), "ShellCheck not installed")
    def test_staged_shell_error_blocks_even_when_worktree_is_fixed(self):
        self.stage("broken script.sh", "#!/bin/bash\nif then\n")
        (self.repo / "broken script.sh").write_text("#!/bin/bash\ntrue\n")
        self.assert_blocked("pre-commit")

    def test_missing_scanner_blocks_both_hooks(self):
        self.env["PATH"] = str(self.repo / "no-tools")
        for hook in ("pre-commit", "pre-push"):
            result = self.run_command("/bin/bash", "hooks/" + hook)
            self.assertEqual(result.returncode, 1)
            self.assertIn("gitleaks not found", result.stderr)

    def test_unstaged_secret_is_not_part_of_commit(self):
        self.stage("credentials.txt", "safe\n")
        (self.repo / "credentials.txt").write_text(f'token = "{TOKEN}"\n')
        self.git("commit", "-qm", "Only staged safe content")

    def test_deleted_secret_still_blocks_history(self):
        self.stage("credentials.txt", f'token = "{TOKEN}"\n')
        self.git("-c", "core.hooksPath=/dev/null", "commit", "-qm", "Synthetic leak")
        self.git("rm", "credentials.txt")
        self.git("commit", "-qm", "Remove synthetic leak")
        self.assert_blocked("pre-push")


if __name__ == "__main__":
    unittest.main()
