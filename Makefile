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

# macOS-only packages (skipped on Linux)
MACOS_PACKAGES := ghostty zed btop htop gh

# Packages safe for headless Linux
LINUX_PACKAGES := bash fish starship git vim tmux

.PHONY: help setup install uninstall restow brew brew-all brew-dump hooks macos linux clean list lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## Interactive setup (name, email, GPG, usernames)
	@$(BREW_PATH_EVAL); ./setup.sh

install: ## Stow all packages into ~
	@$(BREW_PATH_EVAL); echo "Pre-creating directories to prevent stow tree folding ..."
	@for pkg in $(PACKAGES); do \
		find $$pkg -mindepth 1 -type d | while read -r d; do \
			target="$$HOME/$${d#$$pkg/}"; \
			mkdir -p "$$target" 2>/dev/null || true; \
		done; \
	done
	@# Back up existing (non-symlink) files that would conflict with stow
	@echo "Checking for conflicting files ..."
	@for pkg in $(PACKAGES); do \
		$(STOW) -n $$pkg 2>&1 | \
			grep "over existing target" | \
			sed 's/.*over existing target //' | \
			sed 's/ since .*//' | while read -r rel; do \
				target="$$HOME/$$rel"; \
				if [ -f "$$target" ] && [ ! -L "$$target" ]; then \
					mv "$$target" "$$target.bak"; \
					echo "  Backed up $$rel → $$rel.bak"; \
				fi; \
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
		errs=$$($(STOW) -n $$pkg 2>&1); \
		echo "$$errs" | grep -i "cannot\|existing\|not owned" || true; \
		printf "  ⚠  $$pkg has conflicts. Back up existing files and stow? [Y/n] "; \
		read ans; \
		case "$$ans" in \
			[nN]*) \
				echo "  Skipped $$pkg"; \
				skipped="$$skipped $$pkg";; \
			*) \
				echo "$$errs" | grep "not owned by stow:" | \
					sed 's/.*not owned by stow: //' | while read -r f; do \
					target="$$HOME/$$f"; \
					if [ -e "$$target" ]; then \
						mv "$$target" "$$target.bak" && \
						echo "  Backed up $$f → $$f.bak"; \
					fi; \
				done; \
				if $(STOW) --adopt $(STOW_FLAGS) $$pkg && \
				git checkout -- $$pkg; then \
				echo "  ✔ $$pkg stowed successfully"; \
				stowed="$$stowed $$pkg"; \
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

restow: ## Re-stow all packages (fix stale symlinks)
	@for pkg in $(PACKAGES); do \
		echo "Restowing $$pkg ..."; \
		$(STOW) -R $(STOW_FLAGS) $$pkg; \
	done

brew: ## Install Homebrew packages (interactive, skips already installed)
	@./brew-interactive.sh Brewfile

brew-all: ## Install ALL Homebrew packages from Brewfile (non-interactive)
	brew bundle --file=Brewfile || echo "⚠ brew bundle had failures (see above)"

brew-dump: ## Update Brewfile from currently installed packages
	brew bundle dump --file=Brewfile --force
	@echo "Brewfile updated. Review changes with: git diff Brewfile"

hooks: ## Set up git hooks (gitleaks pre-commit)
	git config core.hooksPath hooks
	@echo "Pre-commit hook active (gitleaks secret scanning)."

macos: brew setup install hooks ## Full macOS setup (brew + setup + stow + hooks)
	@echo ""
	@echo "── Shell ────────────────────────────────"
	@$(BREW_PATH_EVAL); \
	FISH_PATH=$$(command -v fish 2>/dev/null); \
	if [ -n "$$FISH_PATH" ] && [ "$$SHELL" != "$$FISH_PATH" ]; then \
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
	else \
		echo "  Default shell is already fish. ✔"; \
	fi
	@echo ""
	@echo "  NOTE: If your terminal still opens zsh, check your terminal"
	@echo "  app settings — it may override the login shell."
	@if [ -f macos/setup-touchid-sudo.sh ]; then \
		echo ""; \
		echo "Optional: enable Touch ID for sudo:"; \
		echo "  sudo bash macos/setup-touchid-sudo.sh"; \
	fi

linux: ## Full Linux setup (no root required)
	./setup-linux.sh

list: ## List all stow packages
	@echo "Packages: $(PACKAGES)"

lint: ## Run shellcheck on all shell scripts
	@echo "Shellcheck ..."
	@shellcheck setup-linux.sh hooks/pre-commit macos/setup-touchid-sudo.sh
	@echo "Fish syntax ..."
	@find . -name '*.fish' -not -path './codex/*' -exec fish --no-execute {} +
	@echo "All clean."

clean: ## Remove broken symlinks in ~ pointing to this repo
	@echo "Scanning for broken symlinks ..."
	@find ~ -maxdepth 4 -type l ! -exec test -e {} \; -print 2>/dev/null | \
		grep "$(shell pwd)" || echo "No broken symlinks found."
