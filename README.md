# dotfiles

Personal configuration files.

## Contents

- `.gitconfig` - Git configuration with aliases

## Git Aliases

| Alias | Description |
|-------|-------------|
| `prune-local` | Remove local branches whose remote tracking branch is gone |

## Installation

```bash
git clone git@github.com:yungweng/dotfiles.git ~/repos/dotfiles

# Symlink configs
ln -sf ~/repos/dotfiles/.gitconfig ~/.gitconfig
```

## Usage

```bash
# Clean up local branches after merging PRs
git prune-local
```
