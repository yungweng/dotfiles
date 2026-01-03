function coy-review --description "Run Codex code review N times in parallel"
    argparse 'n/count=' 'b/branch=' -- $argv
    or return 1

    set -q _flag_count; or set _flag_count 2
    set -q _flag_branch; or set _flag_branch development

    set prompt "Review code changes between HEAD and '$_flag_branch'. Find bugs [P0-P3], security issues, logic errors. State file:line for each finding."

    set tmpdir (mktemp -d)
    set combined "$tmpdir/combined.txt"

    echo "Running $_flag_count reviews against '$_flag_branch' in parallel..."

    for i in (seq $_flag_count)
        codex exec --enable web_search_request --dangerously-bypass-approvals-and-sandbox "$prompt" > "$tmpdir/review_$i.txt" 2>&1 &
    end

    wait
    echo "Reviews complete. Combining results..."

    # Extract just the review content (from ## Summary to before "tokens used")
    for i in (seq $_flag_count)
        echo "" >> "$combined"
        echo "════════════════════════════════════════════════════════════" >> "$combined"
        echo "  REVIEW PASS $i / $_flag_count" >> "$combined"
        echo "════════════════════════════════════════════════════════════" >> "$combined"
        echo "" >> "$combined"
        # Filter: keep from first "## " to end, remove "tokens used" line
        sed -n '/^## /,$p' "$tmpdir/review_$i.txt" | grep -v "^tokens used" >> "$combined"
    end

    # Print and copy
    cat "$combined"
    cat "$combined" | pbcopy

    echo ""
    echo "✓ Copied to clipboard ($_flag_count reviews)"

    rm -rf "$tmpdir"
end
