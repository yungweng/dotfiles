---
name: pr-screenshots
description: Add or update screenshots in a GitHub PR comment when the user asks to post them.
---

# Screenshots in einen PR posten

Bei öffentlichen Repos: Bilder auf einen separaten Branch pushen und im
PR-Kommentar per Commit-SHA verlinken. Bei privaten Repos keine öffentlichen
Raw-URLs verwenden; Bilder über die authentifizierte GitHub-Oberfläche hochladen.

## Ablauf

1. Screenshots erzeugen und ansehen. Nur die gewünschten Ansichten veröffentlichen;
   Zugangsdaten und private Nutzerdaten vorher aus den Bildern entfernen.
2. In einem separaten Worktree einen normalen Screenshot-Branch anlegen. So bleiben
   die Arbeitskopie des Nutzers und die versionierten Prüfskripte erhalten.

```bash
# PR und SOURCE auf die konkrete PR-Nummer und den Screenshot-Ordner setzen.
WORKTREE_PARENT=$(mktemp -d)
WORKTREE="$WORKTREE_PARENT/worktree"
git worktree add -b "pr-$PR-screenshots" "$WORKTREE" HEAD
mkdir -p "$WORKTREE/screenshots-pr$PR"
cp "$SOURCE/01-overview.png" "$WORKTREE/screenshots-pr$PR/"
git -C "$WORKTREE" add -- "screenshots-pr$PR/01-overview.png"
git -C "$WORKTREE" diff --cached --stat
```

3. Die Prüfungen des Repos im Worktree ausführen. Hooks aktiv lassen; absolute
   Hook-Pfade müssen auch dort erreichbar sein. Bei einem Fehler dessen Ursache
   beheben, nicht die Prüfung umgehen. Nur die ausgewählten Bilder committen:

```bash
git -C "$WORKTREE" commit -m "docs: Screenshots für PR #$PR"
git -C "$WORKTREE" push -u origin "pr-$PR-screenshots"
SHA=$(git -C "$WORKTREE" rev-parse HEAD)
```

4. Einen Kommentar als Markdown-Datei vorbereiten. Bild-URLs haben die Form
   `https://raw.githubusercontent.com/<owner>/<repo>/<SHA>/screenshots-pr<NR>/01-overview.png`.
   Vor jedem Bild kurz beschreiben, was es zeigt. Mit `gh pr comment "$PR" --body-file
   <datei>` posten und den veröffentlichten Kommentar prüfen.
5. Den sauberen Worktree mit `git worktree remove "$WORKTREE"` entfernen, danach
   `rmdir "$WORKTREE_PARENT"`. Den Remote-Branch behalten, solange die Bilder gebraucht werden.

## Aktualisieren

Den vorhandenen Screenshot-Branch in einem separaten Worktree öffnen, nur die
geänderten Bilder committen und normal pushen. Die URLs im bestehenden Kommentar
auf den neuen SHA ändern; den Kommentar über seine ID aktualisieren. Keine
Force-Pushes und keine zusätzlichen Kommentare für dieselbe Bildserie.
