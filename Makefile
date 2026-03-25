# ============================================================================
# Dotfiles Management
# Usage: make help
# ============================================================================

STOW := stow
STOW_FLAGS := --verbose

# Ensure brew binaries are in PATH for targets that run after a fresh brew install.
# Each Make recipe line runs in its own shell, so we prepend this where needed.
BREW_PATH_EVAL := if [ -x /opt/homebrew/bin/brew ]; then eval "$$(/opt/homebrew/bin/brew shellenv)"; elif [ -x /usr/local/bin/brew ]; then eval "$$(/usr/local/bin/brew shellenv)"; fi

# All stow-managed packages (order doesn't matter)
PACKAGES := bash btop claude codex direnv fish gh ghostty git gitmux htop npm starship tmux topgrade vim zed

# macOS-only packages (skipped on Linux): ghostty zed btop htop gh gitmux
# Packages safe for headless Linux: bash fish starship git vim tmux
# (see setup-linux.sh LINUX_PACKAGES for the authoritative list)

.PHONY: help preflight setup install uninstall restow brew brew-all brew-dump hooks macos linux clean list lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

preflight: ## Check prerequisites (Xcode CLI Tools, Homebrew)
	@echo "── Pre-flight checks ──────────────────────"
	@failed=0; \
	if xcode-select -p &>/dev/null; then \
		echo "  ✔ Xcode CLI Tools"; \
	else \
		echo "  ✘ Xcode CLI Tools not found"; \
		echo "    Installing (this may take a few minutes) ..."; \
		xcode-select --install 2>/dev/null || true; \
		echo ""; \
		echo "  ⚠  Complete the Xcode CLI Tools install, then re-run make macos."; \
		exit 1; \
	fi; \
	if command -v brew &>/dev/null; then \
		echo "  ✔ Homebrew ($$(brew --version | head -1))"; \
	elif [ -x /opt/homebrew/bin/brew ] || [ -x /usr/local/bin/brew ]; then \
		echo "  ✔ Homebrew (found but not in PATH — will be added)"; \
	else \
		echo "  ✘ Homebrew not found"; \
		echo "    Installing Homebrew ..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		$(BREW_PATH_EVAL); \
		if command -v brew &>/dev/null; then \
			echo "  ✔ Homebrew installed"; \
		else \
			echo "  ✘ Homebrew installation failed"; \
			failed=1; \
		fi; \
	fi; \
	if command -v git &>/dev/null; then \
		echo "  ✔ Git ($$(git --version))"; \
	else \
		echo "  ✘ Git not found (should come with Xcode CLI Tools)"; \
		failed=1; \
	fi; \
	if [ "$$failed" -eq 1 ]; then \
		echo ""; \
		echo "  ✘ Fix the issues above, then re-run."; \
		exit 1; \
	fi; \
	echo "  All checks passed."
	@echo ""

setup: ## Interactive setup (name, email, GPG, usernames)
	@$(BREW_PATH_EVAL); ./setup.sh

install: ## Stow all packages into ~
	@# Clean up stale symlinks from removed package files
	@for f in ~/.config/fish/functions/kaffee.fish; do \
		if [ -L "$$f" ] && [ ! -e "$$f" ]; then \
			rm "$$f"; \
			echo "  Removed stale symlink: $$f"; \
		fi; \
	done
	@$(BREW_PATH_EVAL); echo "Pre-creating directories to prevent stow tree folding ..."
	@for pkg in $(PACKAGES); do \
		find $$pkg -mindepth 1 -type d | while read -r d; do \
			target="$$HOME/$${d#$$pkg/}"; \
			mkdir -p "$$target" 2>/dev/null || true; \
		done; \
	done
	@$(BREW_PATH_EVAL); \
	stowed=""; skipped=""; \
	for pkg in $(PACKAGES); do \
		echo "Stowing $$pkg ..."; \
		if $(STOW) $(STOW_FLAGS) $$pkg 2>/dev/null; then \
			stowed="$$stowed $$pkg"; \
			continue; \
		fi; \
		echo "  $$pkg has conflicts with existing files."; \
		printf "  ⚠  Adopt existing files and stow? [Y/n] "; \
		read ans; \
		case "$$ans" in \
			[nN]*) \
				echo "  Skipped $$pkg"; \
				skipped="$$skipped $$pkg";; \
			*) \
				if $(STOW) --adopt $(STOW_FLAGS) $$pkg; then \
					ts=$$(date +%Y%m%d-%H%M%S); \
					{ git diff --name-only -- $$pkg; git ls-files --others -- $$pkg; } | sort -u | while read -r f; do \
						cp "$$f" "$$HOME/$${f#$$pkg/}.bak-$$ts" 2>/dev/null && \
						echo "  Saved original: ~/$${f#$$pkg/}.bak-$$ts"; \
					done; \
					git checkout -- $$pkg; \
					git ls-files --others -- $$pkg | xargs rm -f 2>/dev/null; \
					if git diff --quiet -- $$pkg 2>/dev/null; then \
						echo "  ✔ $$pkg stowed (originals saved as .bak-$$ts)"; \
						stowed="$$stowed $$pkg"; \
					else \
						echo "  ✘ $$pkg: failed to restore repo versions"; \
						skipped="$$skipped $$pkg"; \
					fi; \
				else \
					echo "  ✘ $$pkg failed"; \
					skipped="$$skipped $$pkg"; \
				fi;; \
		esac; \
	done; \
	echo ""; \
	echo "── Summary ──────────────────────────────"; \
	echo "  Stowed:$$stowed"; \
	if [ -n "$$skipped" ]; then \
		echo "  Skipped:$$skipped"; \
		echo "  Re-run 'make install' to retry skipped packages."; \
	fi; \
	echo ""; \
	echo "Run 'make hooks' to enable gitleaks pre-commit."

uninstall: ## Unstow all packages from ~
	@for pkg in $(PACKAGES); do \
		echo "Unstowing $$pkg ..."; \
		$(STOW) -D $(STOW_FLAGS) $$pkg; \
	done
	@backups=$$(find ~ -maxdepth 4 -name "*.bak-*" 2>/dev/null | head -10); \
	if [ -n "$$backups" ]; then \
		echo ""; \
		echo "── Backups ──────────────────────────────"; \
		echo "  Original files were backed up before install."; \
		echo "  To restore, rename them back, e.g.:"; \
		echo "    mv ~/.bashrc.bak-20260325-120000 ~/.bashrc"; \
		echo ""; \
		echo "  Find all backups:"; \
		echo "    find ~ -maxdepth 4 -name '*.bak-*'"; \
	fi

restow: ## Re-stow all packages (fix stale symlinks)
	@for pkg in $(PACKAGES); do \
		echo "Restowing $$pkg ..."; \
		$(STOW) -R $(STOW_FLAGS) $$pkg; \
	done

brew: ## Install Homebrew packages (interactive, skips already installed)
	@$(BREW_PATH_EVAL); ./brew-interactive.sh Brewfile

brew-all: ## Install ALL Homebrew packages from Brewfile (non-interactive)
	@$(BREW_PATH_EVAL); brew bundle --file=Brewfile || echo "⚠ brew bundle had failures (see above)"

brew-dump: ## Update Brewfile from currently installed packages
	@$(BREW_PATH_EVAL); brew bundle dump --file=Brewfile --force
	@echo "Brewfile updated. Review changes with: git diff Brewfile"

hooks: ## Set up git hooks (gitleaks pre-commit)
	git config core.hooksPath hooks
	@echo "Pre-commit hook active (gitleaks secret scanning)."

macos: preflight brew setup install hooks ## Full macOS setup (preflight + brew + setup + stow + hooks)
	@echo ""
	@echo "── Shell ────────────────────────────────"
	@$(BREW_PATH_EVAL); \
	FISH_PATH=$$(command -v fish 2>/dev/null); \
	if [ -z "$$FISH_PATH" ]; then \
		echo "  ⚠ fish not found. Install it (brew install fish) and re-run."; \
	elif [ "$$SHELL" = "$$FISH_PATH" ]; then \
		echo "  Default shell is already fish. ✔"; \
	else \
		printf "  Your shell is $$SHELL. Switch to fish? [Y/n] "; \
		read ans; \
		case "$$ans" in \
			[nN]*) echo "  Keeping current shell ($$SHELL).";; \
			*) \
				if ! grep -qx "$$FISH_PATH" /etc/shells; then \
					echo "  Adding $$FISH_PATH to /etc/shells (requires sudo) ..."; \
					echo "$$FISH_PATH" | sudo tee -a /etc/shells >/dev/null; \
				fi; \
				chsh -s "$$FISH_PATH" && \
				echo "  ✔ Default shell set to fish. Restart your terminal.";; \
		esac; \
	fi
	@echo ""
	@echo "  NOTE: If your terminal still opens zsh, check your terminal"
	@echo "  app settings — it may override the login shell."
	@echo ""
	@echo "── Optional ─────────────────────────────"
	@echo "  bash macos/defaults.sh        Set macOS preferences (Finder, Dock, Trackpad)"
	@echo "  sudo bash macos/setup-touchid-sudo.sh  Enable Touch ID for sudo"

linux: ## Full Linux setup (no root required)
	./setup-linux.sh

list: ## List all stow packages
	@echo "Packages: $(PACKAGES)"

lint: ## Run shellcheck on all shell scripts
	@echo "Shellcheck ..."
	@shellcheck setup.sh setup-linux.sh brew-interactive.sh hooks/pre-commit macos/setup-touchid-sudo.sh macos/defaults.sh
	@echo "Fish syntax ..."
	@find . -name '*.fish' -not -path './codex/*' -exec fish --no-execute {} +
	@echo "All clean."

clean: ## Check for broken symlinks in ~ pointing to this repo
	@echo "Scanning for broken symlinks ..."
	@broken=$$(find ~ -maxdepth 4 -type l ! -exec test -e {} \; -print 2>/dev/null | \
		grep "$(shell pwd)" || true); \
	if [ -n "$$broken" ]; then \
		echo "$$broken"; \
		echo ""; \
		echo "  ✘ Found broken symlinks. Run 'make restow' or remove them manually."; \
		exit 1; \
	else \
		echo "  No broken symlinks found. ✔"; \
	fi
