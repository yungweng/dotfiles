#!/usr/bin/env bash
# Interactive Brewfile installer — only shows what's missing, lets you pick.
set -euo pipefail

BREWFILE="${1:-Brewfile}"

if [ ! -f "$BREWFILE" ]; then
  echo "Error: $BREWFILE not found." >&2
  exit 1
fi

if ! command -v brew &>/dev/null; then
  echo "Error: Homebrew not found. Install it first: https://brew.sh" >&2
  exit 1
fi

# ── Gather missing packages ─────────────────────────────────────────
echo "Checking installed packages against $BREWFILE ..."
missing_output=$(brew bundle check --file="$BREWFILE" --verbose 2>&1 || true)

# Extract missing formula/cask names
missing_names=()
while IFS= read -r line; do
  # Lines look like: "→ Formula act needs to be installed or updated."
  #                   "→ Cask ghostty needs to be installed or updated."
  if [[ "$line" =~ ^→\ (Formula|Cask)\ (.+)\ needs\ to\ be ]]; then
    missing_names+=("${BASH_REMATCH[2]}")
  fi
done <<< "$missing_output"

# ── Parse Brewfile into categories ──────────────────────────────────
declare -A missing_set  # quick lookup for missing names

for name in "${missing_names[@]}"; do
  missing_set["$name"]=1
done

# Categories we handle
categories=("tap" "brew" "cask" "vscode" "go" "cargo" "uv")
declare -A cat_missing  # category -> newline-separated "name|||line" pairs

while IFS= read -r line; do
  # Skip blank lines and comments
  [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

  # Parse: type "name" [, extras]
  if [[ "$line" =~ ^([a-z]+)\ +\"([^\"]+)\" ]]; then
    entry_type="${BASH_REMATCH[1]}"
    entry_name="${BASH_REMATCH[2]}"
  else
    continue
  fi

  # Taps are always needed as dependencies — install them silently later
  [[ "$entry_type" == "tap" ]] && continue

  # For brew/cask, check against missing list
  if [[ "$entry_type" == "brew" || "$entry_type" == "cask" ]]; then
    [[ -z "${missing_set[$entry_name]+x}" ]] && continue
  fi

  # For vscode/go/cargo/uv — brew bundle doesn't report these in --check,
  # so we check them ourselves
  case "$entry_type" in
    vscode)
      if command -v code &>/dev/null && code --list-extensions 2>/dev/null | grep -qix "$entry_name"; then
        continue
      fi
      ;;
    go)
      # go packages: check if binary exists in GOPATH/bin
      bin_name=$(basename "$entry_name")
      if [ -x "${GOPATH:-$HOME/go}/bin/$bin_name" ]; then
        continue
      fi
      ;;
    cargo)
      if command -v cargo &>/dev/null && cargo install --list 2>/dev/null | grep -q "^${entry_name} "; then
        continue
      fi
      ;;
    uv)
      # uv entries with "-" are placeholders, skip
      [[ "$entry_name" == "-" ]] && continue
      if command -v uvx &>/dev/null && uvx --version &>/dev/null 2>&1; then
        # No reliable way to check uv-managed tools; always offer
        :
      fi
      ;;
  esac

  cat_missing["$entry_type"]+="${entry_name}|||${line}"$'\n'

done < "$BREWFILE"

# ── Check if anything is missing at all ─────────────────────────────
total_missing=0
for cat in "${categories[@]}"; do
  [[ -z "${cat_missing[$cat]+x}" ]] && continue
  count=$(echo -n "${cat_missing[$cat]}" | grep -c '|||' || true)
  total_missing=$((total_missing + count))
done

if [ "$total_missing" -eq 0 ]; then
  echo ""
  echo "✔ Everything in $BREWFILE is already installed!"
  exit 0
fi

echo ""
echo "Found $total_missing missing package(s). Choose what to install:"
echo ""

# ── Pretty category names ───────────────────────────────────────────
declare -A cat_labels=(
  [brew]="Homebrew formulae"
  [cask]="Homebrew casks (GUI apps)"
  [vscode]="VS Code extensions"
  [go]="Go packages"
  [cargo]="Cargo (Rust) packages"
  [uv]="uv (Python) packages"
)

# ── Interactive selection ───────────────────────────────────────────
selected_lines=()

for cat in "${categories[@]}"; do
  [[ -z "${cat_missing[$cat]+x}" ]] && continue
  data="${cat_missing[$cat]}"
  [[ -z "$data" ]] && continue

  # Parse into arrays
  names=()
  lines=()
  while IFS= read -r entry; do
    [[ -z "$entry" ]] && continue
    names+=("${entry%%|||*}")
    lines+=("${entry#*|||}")
  done <<< "$data"

  count=${#names[@]}
  label="${cat_labels[$cat]:-$cat}"

  echo "── $label ($count missing) ──"
  for i in "${!names[@]}"; do
    echo "  $(( i + 1 )). ${names[$i]}"
  done
  echo ""

  if [ "$count" -eq 1 ]; then
    printf "  Install %s? [Y/n] " "${names[0]}"
    read -r ans </dev/tty
    case "$ans" in
      [nN]*) echo "  Skipped." ;;
      *) selected_lines+=("${lines[0]}") ;;
    esac
  else
    printf "  Install: [A]ll / [s]ome / [n]one? "
    read -r ans </dev/tty
    case "$ans" in
      [nN]*)
        echo "  Skipped all."
        ;;
      [sS]*)
        for i in "${!names[@]}"; do
          printf "    Install %s? [Y/n] " "${names[$i]}"
          read -r ans </dev/tty
          case "$ans" in
            [nN]*) ;;
            *) selected_lines+=("${lines[$i]}") ;;
          esac
        done
        ;;
      *)
        for i in "${!lines[@]}"; do
          selected_lines+=("${lines[$i]}")
        done
        ;;
    esac
  fi
  echo ""
done

# ── Install selected packages ──────────────────────────────────────
if [ ${#selected_lines[@]} -eq 0 ]; then
  echo "Nothing selected. Done."
  exit 0
fi

echo "── Installing ${#selected_lines[@]} package(s) ──"
echo ""

# Build a temp Brewfile with required taps + selected entries
tmpfile=$(mktemp /tmp/Brewfile.XXXXXX)
trap 'rm -f "$tmpfile"' EXIT

# Include all taps (they're lightweight and needed as dependencies)
grep -E '^tap ' "$BREWFILE" >> "$tmpfile" 2>/dev/null || true

for line in "${selected_lines[@]}"; do
  echo "$line" >> "$tmpfile"
done

brew bundle --file="$tmpfile"

echo ""
echo "✔ Done!"
