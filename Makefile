# ============================================================================
# Dotfiles Management
# Usage: make help
# ============================================================================

STOW := stow
STOW_FLAGS := --verbose

# All stow-managed packages (order doesn't matter)
PACKAGES := bash btop claude codex fish gh ghostty git htop npm starship tmux topgrade vim zed

# macOS-only packages (skipped on Linux)
MACOS_PACKAGES := ghostty zed btop htop gh

# Packages safe for headless Linux
LINUX_PACKAGES := bash fish starship git vim tmux

.PHONY: help install uninstall restow brew brew-dump hooks macos linux clean list lint

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Stow all packages into ~
	@for pkg in $(PACKAGES); do \
		echo "Stowing $$pkg ..."; \
		$(STOW) $(STOW_FLAGS) $$pkg; \
	done
	@echo ""
	@echo "Done. Run 'make hooks' to enable gitleaks pre-commit."

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

brew: ## Install Homebrew packages from Brewfile
	brew bundle --file=Brewfile

brew-dump: ## Update Brewfile from currently installed packages
	brew bundle dump --file=Brewfile --force
	@echo "Brewfile updated. Review changes with: git diff Brewfile"

hooks: ## Set up git hooks (gitleaks pre-commit)
	git config core.hooksPath hooks
	@echo "Pre-commit hook active (gitleaks secret scanning)."

macos: brew install hooks ## Full macOS setup (brew + stow + hooks)
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
