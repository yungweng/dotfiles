function cheat --description "Show all personal shortcuts, abbreviations, aliases & functions"
    # Colors
    set -l header (set_color --bold bryellow)
    set -l key (set_color --bold brgreen)
    set -l arrow (set_color brblack)
    set -l val (set_color normal)
    set -l dim (set_color brblack)
    set -l reset (set_color normal)

    echo
    echo $header"══════════════════════════════════════════"$reset
    echo $header"  Fish Shell Cheat Sheet"$reset
    echo $header"══════════════════════════════════════════"$reset

    # --- Abbreviations (dynamic from abbr --show) ---
    echo
    echo $header"  Abbreviations"$reset
    echo $dim"  (expand in-place on Space/Enter)"$reset
    echo $header"  ──────────────────────────────────"$reset
    for entry in (abbr --show)
        # abbr --show format: "abbr -a -- name 'expansion'"
        # Extract name and value
        set -l parts (string match -r -- '^abbr -a\b.*?-- (\S+)\s+(.+)$' $entry)
        if test (count $parts) -ge 3
            set -l name $parts[2]
            set -l value (string trim -c "'" -- $parts[3])
            printf "  %s%-14s %s→  %s%s%s\n" $key $name $arrow $val $value $reset
        end
    end

    # --- Aliases (dynamic from alias) ---
    echo
    echo $header"  Aliases"$reset
    echo $dim"  (transparent command replacements)"$reset
    echo $header"  ──────────────────────────────────"$reset
    for entry in (alias)
        # alias output format: "alias name 'command'"
        set -l parts (string match -r -- '^alias (\S+)\s+(.+)$' $entry)
        if test (count $parts) -ge 3
            set -l name $parts[2]
            set -l value (string trim -c "'" -- $parts[3])
            printf "  %s%-14s %s→  %s%s%s\n" $key $name $arrow $val $value $reset
        end
    end

    # --- Custom Functions (from functions dir + inline with descriptions) ---
    echo
    echo $header"  Functions"$reset
    echo $dim"  (custom commands)"$reset
    echo $header"  ──────────────────────────────────"$reset

    # Only show functions defined in user's dotfiles or config dir
    # `functions -D -v` returns 5 lines: path, autoload, line, scope, description
    set -l user_paths "$HOME/.config/fish" "$DOTFILES_DIR"
    set -l alias_names
    for entry in (alias)
        set -l aname (string match -r -- '^alias (\S+)' $entry)
        test (count $aname) -ge 2; and set -a alias_names $aname[2]
    end

    for fn in (functions --names)
        # Skip fish internals, private functions, and cheat itself
        string match -qr '^(fish_|_)' -- $fn; and continue
        test "$fn" = cheat; and continue
        # Skip alias-generated functions (already shown above)
        contains -- $fn $alias_names; and continue
        # Get verbose details: line 1 = path, line 5 = description
        set -l details (functions -D -v $fn 2>/dev/null)
        test (count $details) -lt 5; and continue
        set -l src $details[1]
        set -l desc $details[5]
        # Only show if defined in user config paths
        set -l is_user 0
        for p in $user_paths
            string match -q "$p*" -- $src; and set is_user 1; and break
        end
        test $is_user -eq 0; and continue
        # Print with description
        if test -n "$desc" -a "$desc" != "N/A" -a "$desc" != "-"
            printf "  %s%-14s %s→  %s%s%s\n" $key $fn $arrow $val $desc $reset
        else
            printf "  %s%-14s %s→  %s%s%s\n" $key $fn $arrow $dim "(no description)" $reset
        end
    end

    # --- Keybindings (fzf) ---
    echo
    echo $header"  Keybindings"$reset
    echo $dim"  (keyboard shortcuts)"$reset
    echo $header"  ──────────────────────────────────"$reset
    printf "  %s%-14s %s→  %s%s%s\n" $key "Ctrl+R" $arrow $val "Search command history (fzf)" $reset
    printf "  %s%-14s %s→  %s%s%s\n" $key "Ctrl+T" $arrow $val "Search files (fzf)" $reset
    printf "  %s%-14s %s→  %s%s%s\n" $key "Alt+C" $arrow $val "cd into directory (fzf)" $reset

    echo
    echo $header"══════════════════════════════════════════"$reset
    echo $dim"  Auto-generated from your Fish config"$reset
    echo $dim"  Add --description to functions to show them here"$reset
    echo $header"══════════════════════════════════════════"$reset
    echo
end
