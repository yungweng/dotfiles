# brew wrapper — auto-updates Brewfile after install/uninstall/upgrade
function brew --description "Brew wrapper, auto-updates Brewfile"
    command brew $argv
    set -l exit_code $status

    if test $exit_code -eq 0
        switch "$argv[1]"
            case install uninstall remove reinstall upgrade
                set -l brewfile "$DOTFILES_DIR/Brewfile"
                if test -f "$brewfile"
                    command brew bundle dump --file="$brewfile" --force 2>/dev/null
                    and echo "Brewfile updated."
                end
        end
    end

    return $exit_code
end
