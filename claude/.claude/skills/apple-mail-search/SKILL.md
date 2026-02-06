---
name: apple-mail-search
description: Use when user asks to find, search, or look up emails in Apple Mail. Triggers on mentions of emails, inbox, messages, senders, or anything involving searching mail history.
---

# Apple Mail Search

Search the user's Apple Mail database directly via read-only SQLite queries and EMLX file parsing.

## Access

**Database:** `~/Library/Mail/V10/MailData/Envelope Index`

**CRITICAL: Always open read-only:**
```bash
sqlite3 -readonly "file:$HOME/Library/Mail/V10/MailData/Envelope Index?mode=ro"
```

**EMLX files:** `~/Library/Mail/V10/` (nested deep in account/mailbox subdirectories)

## Schema Quick Reference

```
messages (ROWID, sender→addresses, subject→subjects, mailbox→mailboxes,
          date_received [unix], date_sent [unix], read, flagged, deleted,
          conversation_id, summary→summaries)
addresses (ROWID, address [email], comment [display name])
subjects  (ROWID, subject [text])
mailboxes (ROWID, url, total_count, unread_count)
recipients (ROWID, message→messages, address→addresses, type, position)
summaries (ROWID, summary [full body text!])
```

**Key joins:**
- `messages.sender = addresses.ROWID`
- `messages.subject = subjects.ROWID`
- `messages.mailbox = mailboxes.ROWID`
- `recipients.message = messages.ROWID`, `recipients.address = addresses.ROWID`
- `summaries.ROWID = messages.summary` (body text — not always populated)

## Search Strategy

Always cast a wide net. Run multiple queries in parallel across different fields:

### 1. By sender display name (most overlooked)
```sql
SELECT m.ROWID, a.address, a.comment, s.subject,
       datetime(m.date_received, 'unixepoch') as date
FROM messages m
JOIN addresses a ON m.sender = a.ROWID
JOIN subjects s ON m.subject = s.ROWID
WHERE m.deleted = 0
AND (a.comment LIKE '%searchterm%' OR a.address LIKE '%searchterm%')
ORDER BY m.date_received DESC LIMIT 30;
```

### 2. By subject keywords
```sql
AND s.subject LIKE '%keyword%'
```

### 3. By email body (via summaries table)
```sql
SELECT m.ROWID, a.address, a.comment, s.subject,
       datetime(m.date_received, 'unixepoch') as date
FROM messages m
JOIN addresses a ON m.sender = a.ROWID
JOIN subjects s ON m.subject = s.ROWID
JOIN summaries su ON m.summary = su.ROWID
WHERE m.deleted = 0
AND su.summary LIKE '%searchterm%'
ORDER BY m.date_received DESC LIMIT 30;
```

### 4. By recipient (TO/CC)
```sql
SELECT m.ROWID, a_sender.address as from_addr, s.subject,
       a_recip.address as to_addr,
       datetime(m.date_received, 'unixepoch') as date
FROM messages m
JOIN addresses a_sender ON m.sender = a_sender.ROWID
JOIN subjects s ON m.subject = s.ROWID
JOIN recipients r ON r.message = m.ROWID
JOIN addresses a_recip ON r.address = a_recip.ROWID
WHERE m.deleted = 0
AND a_recip.address LIKE '%searchterm%'
ORDER BY m.date_received DESC LIMIT 30;
```

### 5. By sender domain
```sql
AND a.address LIKE '%.cn'       -- Chinese domains
AND a.address LIKE '%@company%' -- Company name in domain
```

### 6. By date range
```sql
AND m.date_received BETWEEN strftime('%s','2025-01-01') AND strftime('%s','2025-12-31')
```

### 7. Combined multi-field (most effective)
Run all relevant angles in parallel Bash calls. Don't rely on a single query.

## Reading Full Email Bodies

The `summaries` table often has body text, but not always. For full content, read the EMLX file:

### Find the EMLX file
```bash
find ~/Library/Mail/V10 -name "ROWID.emlx" -type f 2>/dev/null
```

### Parse via email-helper (if installed in the project)
```python
python3 -c "
from src.email_helper.emlx_parser import EmlxParser
parser = EmlxParser()
body = parser.get_body(ROWID)
if body:
    print(body[:3000])
"
```

### Parse raw EMLX manually
EMLX format: first line = byte count, then RFC 2822 email, then XML plist at end. Use python `email` module to parse.

## CLI Tool (if email-helper-cc is installed)

```bash
email-helper search --sender "term" --subject "term" --limit 50
email-helper sample ROWID --body    # metadata + first 500 chars of body
email-helper info                   # stats and top senders
```

**Limitation:** CLI search only matches `addresses.address`, NOT `addresses.comment` (display name). For name-based searches, use direct SQL.

## Common Mistakes

- **Searching only email address, not display name:** The `addresses.comment` field holds "Michelle | HUAYUAN" — always search both `address` and `comment`
- **Truncating body at 500 chars:** CLI `--body` flag truncates. Use EMLX parser or `summaries` table for full text
- **Forgetting deleted filter:** Always include `WHERE m.deleted = 0`
- **Single-query approach:** People remember fragments. Run 4-5 parallel queries: name, subject keywords, domain, body text, date range
- **Case sensitivity:** `address` column is `COLLATE NOCASE`, but `comment` is `COLLATE BINARY` — use `LIKE` which is case-insensitive for ASCII in SQLite
