---
name: imessage
description: Use when user asks to find, search, look up, or send iMessages, texts, or SMS. Triggers on mentions of iMessage, texts, messages, "what did X text me", "find my conversation with", "send a message to", "text X", or anything involving searching or sending iMessage/SMS/RCS messages.
---

# iMessage

Search and send iMessage, SMS, and RCS messages on macOS. Search uses read-only SQLite queries against the local Messages database. Sending uses AppleScript via the Messages app.

## Access

**Database:** `~/Library/Messages/chat.db`

**CRITICAL: Always open read-only to avoid corrupting the live database:**
```bash
sqlite3 "file:$HOME/Library/Messages/chat.db?mode=ro"
```

**Attachments directory:** `~/Library/Messages/Attachments/` (nested in hex-based subdirectories)

**Prerequisite:** The terminal running Claude Code must have **Full Disk Access** granted in System Settings > Privacy & Security > Full Disk Access. If queries fail with a permission error, instruct the user to enable this.

## Schema Quick Reference

```
message     (ROWID, guid, text, handle_id→handle, subject,
             date [Cocoa nanoseconds], date_read, date_delivered,
             is_from_me, is_read, is_sent, is_delivered,
             cache_has_attachments, is_audio_message, is_system_message,
             associated_message_type [tapback type], associated_message_guid,
             thread_originator_guid [reply thread], group_title,
             attributedBody [BLOB, rich text — fallback when text is NULL],
             service [iMessage|SMS|RCS], error, date_edited, date_retracted)

handle      (ROWID, id [phone/email], service [iMessage|SMS|RCS],
             country, person_centric_id)

chat        (ROWID, guid, chat_identifier [phone/email or group ID],
             service_name, display_name [group name], style [43=group, 45=DM],
             is_archived, room_name, last_read_message_timestamp)

attachment  (ROWID, guid, filename [full path with ~/], transfer_name [display name],
             mime_type, uti, total_bytes, created_date [Cocoa nanoseconds],
             is_outgoing, is_sticker, hide_attachment)

-- Join tables:
chat_message_join    (chat_id→chat, message_id→message, message_date)
chat_handle_join     (chat_id→chat, handle_id→handle)
message_attachment_join (message_id→message, attachment_id→attachment)
```

**Key relationships:**
- `message.handle_id = handle.ROWID` (sender/recipient for DMs)
- `chat_message_join` links messages to chats (required for group chats)
- `chat_handle_join` links handles to chats (find all chats for a contact)
- `message_attachment_join` links messages to attachments

## Timestamp Handling

iMessage on macOS uses **Cocoa timestamps in nanoseconds** (nanoseconds since 2001-01-01). Divide by 1,000,000,000 and add `978307200` to convert to Unix epoch:

```sql
datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date
```

To filter by date range:
```sql
AND m.date BETWEEN (strftime('%s','2025-01-01') - 978307200) * 1000000000
                AND (strftime('%s','2025-12-31') - 978307200) * 1000000000
```

## Chat Style Reference

| style | Meaning |
|---|---|
| 45 | DM (one-to-one) |
| 43 | Group chat |

## Service Types

| service | Meaning |
|---|---|
| `iMessage` | Apple iMessage (blue bubble) |
| `SMS` | Traditional SMS (green bubble) |
| `RCS` | Rich Communication Services (green bubble, newer) |

## Tapback / Reaction Types

Tapbacks are stored as separate messages with `associated_message_type` set and `text` usually NULL:

| associated_message_type | Meaning |
|---|---|
| 2000 | Loved |
| 2001 | Liked |
| 2002 | Disliked |
| 2003 | Laughed |
| 2004 | Emphasized (!! exclamation) |
| 2005 | Questioned (?) |
| 2006 | Removed a reaction |
| 3 | Sticker reply |

To **exclude** tapbacks and system messages from search results:
```sql
AND m.associated_message_type = 0
AND m.is_system_message = 0
```

## Contact Resolution

The `handle` table stores phone numbers and email addresses, NOT display names. iMessage does not store contact names in its database — it resolves them at display time from the macOS Contacts app.

To find a contact, search `handle.id` by phone number or email. If the user provides a name, you must:
1. Try searching message text for mentions of the name
2. Ask the user for the phone number or email
3. Search broadly and let the user identify the correct handle

**A single person often has multiple handles** (e.g., phone + email, or phone + iCloud email). Always search all matching handles.

## Search Strategy

Always cast a wide net. Run multiple queries in parallel across different angles — people remember fragments, not exact strings.

### 1. Find a contact's handle(s) by phone/email

```sql
SELECT ROWID, id, service FROM handle
WHERE id LIKE '%searchterm%'
ORDER BY ROWID DESC;
```

### 2. Find handles by searching message content for a name

When you only have a name (not phone/email), find which handles are associated with messages mentioning that name:

```sql
SELECT DISTINCT h.ROWID, h.id, h.service
FROM handle h
JOIN message m ON m.handle_id = h.ROWID
WHERE m.text LIKE '%personname%'
LIMIT 20;
```

### 3. Search messages in a specific DM by handle

```sql
SELECT datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       CASE WHEN m.is_from_me = 1 THEN 'You' ELSE 'Them' END as sender,
       substr(m.text, 1, 300) as text
FROM message m
WHERE m.handle_id IN (<HANDLE_ROWID_1>, <HANDLE_ROWID_2>)
  AND m.text LIKE '%keyword%'
  AND m.associated_message_type = 0
ORDER BY m.date DESC LIMIT 30;
```

### 4. Search messages across ALL conversations

```sql
SELECT h.id as contact, substr(m.text, 1, 300) as text,
       datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       m.is_from_me, m.service
FROM message m
LEFT JOIN handle h ON m.handle_id = h.ROWID
WHERE m.text LIKE '%keyword%'
  AND m.associated_message_type = 0
ORDER BY m.date DESC LIMIT 30;
```

### 5. Get conversation context (messages around a time window)

```sql
SELECT datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       CASE WHEN m.is_from_me = 1 THEN 'You' ELSE 'Them' END as sender,
       m.ROWID, substr(m.text, 1, 300) as text
FROM message m
WHERE m.handle_id IN (<HANDLE_ROWIDS>)
  AND m.date BETWEEN (<TARGET_DATE> - 978307200) * 1000000000 - 3600000000000
                 AND (<TARGET_DATE> - 978307200) * 1000000000 + 3600000000000
  AND m.associated_message_type = 0
ORDER BY m.date ASC;
```

### 6. List recent conversations

```sql
SELECT h.id as contact, c.display_name as group_name, c.style,
       datetime(MAX(m.date) / 1000000000 + 978307200, 'unixepoch', 'localtime') as last_msg,
       COUNT(m.ROWID) as msg_count
FROM chat c
JOIN chat_message_join cmj ON cmj.chat_id = c.ROWID
JOIN message m ON m.ROWID = cmj.message_id
LEFT JOIN chat_handle_join chj ON chj.chat_id = c.ROWID
LEFT JOIN handle h ON h.ROWID = chj.handle_id
WHERE c.style = 45
GROUP BY c.ROWID
ORDER BY MAX(m.date) DESC LIMIT 20;
```

### 7. Find all URLs/links shared in a conversation

```sql
SELECT datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       CASE WHEN m.is_from_me = 1 THEN 'You' ELSE 'Them' END as sender,
       substr(m.text, 1, 500) as text
FROM message m
WHERE m.handle_id IN (<HANDLE_ROWIDS>)
  AND (m.text LIKE '%http%' OR m.text LIKE '%.com%' OR m.text LIKE '%.io%'
       OR m.text LIKE '%.ai%' OR m.text LIKE '%.app%' OR m.text LIKE '%.dev%')
  AND m.associated_message_type = 0
ORDER BY m.date DESC;
```

### 8. Find attachments in a conversation

```sql
SELECT datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       CASE WHEN m.is_from_me = 1 THEN 'You' ELSE 'Them' END as sender,
       a.transfer_name, a.mime_type, a.total_bytes, a.filename,
       substr(m.text, 1, 200) as text
FROM message m
JOIN message_attachment_join maj ON maj.message_id = m.ROWID
JOIN attachment a ON a.ROWID = maj.attachment_id
WHERE m.handle_id IN (<HANDLE_ROWIDS>)
ORDER BY m.date DESC LIMIT 20;
```

### 9. Group chat: search messages and identify senders

```sql
SELECT datetime(m.date / 1000000000 + 978307200, 'unixepoch', 'localtime') as date,
       CASE WHEN m.is_from_me = 1 THEN 'You' ELSE h.id END as sender,
       substr(m.text, 1, 300) as text
FROM message m
JOIN chat_message_join cmj ON cmj.message_id = m.ROWID
JOIN chat c ON c.ROWID = cmj.chat_id
LEFT JOIN handle h ON m.handle_id = h.ROWID
WHERE c.display_name LIKE '%groupname%'
  AND m.text LIKE '%keyword%'
  AND m.associated_message_type = 0
ORDER BY m.date DESC LIMIT 30;
```

### 10. List all group chats

```sql
SELECT c.ROWID, c.display_name, c.chat_identifier, c.service_name,
       datetime(cmj.message_date / 1000000000 + 978307200, 'unixepoch', 'localtime') as last_msg
FROM chat c
JOIN (SELECT chat_id, MAX(message_date) as message_date FROM chat_message_join GROUP BY chat_id) cmj
  ON cmj.chat_id = c.ROWID
WHERE c.style = 43 AND c.display_name IS NOT NULL AND c.display_name != ''
ORDER BY cmj.message_date DESC LIMIT 20;
```

### 11. Read an attachment file

Attachment filenames use `~` for the home directory. Replace before reading:
```sql
SELECT REPLACE(a.filename, '~', '<HOMEDIR>') as path, a.mime_type, a.transfer_name
FROM attachment a
JOIN message_attachment_join maj ON maj.attachment_id = a.ROWID
WHERE maj.message_id = <MESSAGE_ROWID>;
```

Then use the Read tool (for images, PDFs, text) or Bash to copy/inspect the file.

## Handling NULL text (attributedBody fallback)

Some messages have `text = NULL` but contain content in the `attributedBody` BLOB (rich text). To extract plain text from it:

```bash
sqlite3 "file:$HOME/Library/Messages/chat.db?mode=ro" "
SELECT hex(attributedBody) FROM message WHERE ROWID = <ROWID>;
" | python3 -c "
import sys
data = bytes.fromhex(sys.stdin.read().strip())
# attributedBody is an NSArchiver blob; the plain text is often near the start
try:
    # Find the text between known markers
    text = data.split(b'NSString')[1].split(b'NSDictionary')[0]
    print(text.decode('utf-8', errors='ignore').strip()[:500])
except:
    print('[Could not extract text from attributedBody]')
"
```

This is a best-effort extraction. Not all messages can be decoded this way.

## Sending Messages

Send messages via AppleScript using the Messages app. **Always confirm with the user before sending.**

### Prerequisites

- The Messages app must be running (AppleScript will launch it if not)
- The user must be signed into Messages with their Apple ID

### Strategy: Resolve Target First, Then Send

Before sending, always look up the target chat in the database to get the correct `guid`. This avoids sending to the wrong person/group.

### 1. Send to a group chat (by display_name)

**Step 1:** Find the group chat guid:
```sql
SELECT c.guid, c.display_name, c.service_name,
       datetime(cmj.message_date / 1000000000 + 978307200, 'unixepoch', 'localtime') as last_msg
FROM chat c
JOIN (SELECT chat_id, MAX(message_date) as message_date FROM chat_message_join GROUP BY chat_id) cmj
  ON cmj.chat_id = c.ROWID
WHERE c.style = 43 AND c.display_name LIKE '%groupname%'
ORDER BY cmj.message_date DESC LIMIT 5;
```

**Step 2:** If multiple matches exist (e.g., same group name on iMessage and RCS), pick the most recently active one or ask the user.

**Step 3:** Send using the full `guid`:
```bash
osascript -e '
tell application "Messages"
    set targetChat to chat id "<FULL_GUID>"
    send "<MESSAGE_TEXT>" to targetChat
end tell
'
```

**Example** (guid from database: `any;+;f9b7134f1dcc4a1eb25f13439f8c4600`):
```bash
osascript -e '
tell application "Messages"
    set targetChat to chat id "any;+;f9b7134f1dcc4a1eb25f13439f8c4600"
    send "https://marta.sh/" to targetChat
end tell
'
```

### 2. Send to a DM (by phone number or email)

**Step 1:** Find the handle and associated chat guid:
```sql
SELECT c.guid, h.id, c.service_name
FROM chat c
JOIN chat_handle_join chj ON chj.chat_id = c.ROWID
JOIN handle h ON h.ROWID = chj.handle_id
WHERE h.id LIKE '%searchterm%' AND c.style = 45
ORDER BY c.ROWID DESC LIMIT 5;
```

**Step 2:** Send using the chat guid:
```bash
osascript -e '
tell application "Messages"
    set targetChat to chat id "<FULL_GUID>"
    send "<MESSAGE_TEXT>" to targetChat
end tell
'
```

**Alternative:** Send to a new conversation by phone/email (creates a new chat if none exists):
```bash
osascript -e '
tell application "Messages"
    set targetService to 1st service whose service type = iMessage
    set targetBuddy to buddy "+1234567890" of targetService
    send "<MESSAGE_TEXT>" to targetBuddy
end tell
'
```

### 3. Send multiline messages

Use `\n` for line breaks inside the AppleScript string, or use a return character:
```bash
osascript -e '
tell application "Messages"
    set targetChat to chat id "<FULL_GUID>"
    set msg to "Line 1" & return & "Line 2" & return & "Line 3"
    send msg to targetChat
end tell
'
```

### Sending Safety Rules

- **ALWAYS confirm with the user before sending** — show them the message text and target chat/person
- **Never send to a chat without first verifying the guid** via a database lookup
- **If multiple chats match** (e.g., same group name on iMessage vs RCS), pick the most recently active one or ask the user to clarify
- **Escape single quotes** in message text: replace `'` with `'\''` in the bash command
- **Use the `guid` (not `chat_identifier`)** — AppleScript requires the full guid (e.g., `any;+;chat123...` or `iMessage;+;user@email.com`)

## Common Mistakes

- **Expecting contact names in the database:** iMessage does NOT store display names. `handle.id` contains raw phone numbers or emails only. You cannot search by "John" — you need a phone number, email, or to search message text for mentions of the name.
- **Forgetting nanoseconds:** Timestamps are Cocoa epoch in **nanoseconds**, not seconds. Always divide by `1000000000` before adding the epoch offset. Omitting this gives wildly wrong dates.
- **Missing the epoch offset:** After dividing by 1B, you must still add `978307200` (seconds between 1970 Unix epoch and 2001 Cocoa epoch).
- **Not filtering tapbacks:** Messages with `associated_message_type != 0` are reactions (Loved, Liked, etc.), not real messages. Their `text` is usually NULL or a system string like "Loved an image". Always filter these out unless specifically looking for reactions.
- **Not filtering system messages:** `is_system_message = 1` entries are things like "X named the conversation" or "X left the conversation". Filter with `is_system_message = 0`.
- **Single handle per person:** One person often has 2-3 handles (phone, email, iCloud). Always search for ALL matching handles and query across all of them.
- **Using chat_message_join for DMs:** For one-on-one DMs, querying via `message.handle_id` is simpler and faster. Only use `chat_message_join` when you need chat-level grouping or for group chats.
- **Attachment paths with tilde:** `attachment.filename` uses `~/Library/...` — you must expand `~` to the actual home directory path before reading the file.
- **Case sensitivity with Unicode:** SQLite `LIKE` is case-insensitive for ASCII but case-sensitive for Unicode characters. For non-ASCII names (umlauts, accents), consider using `LOWER()` or searching multiple variations.
- **Single-query approach:** People remember fragments. Run 4-5 parallel queries: handle lookup, message keywords, date range, URLs, attachments. Cast a wide net.
- **Using `chat_identifier` instead of `guid` for sending:** AppleScript's `chat id` requires the full `guid` column (e.g., `any;+;f9b7134f...`), NOT the `chat_identifier`. Using `chat_identifier` alone will fail with error -1728.
- **Not escaping single quotes in messages:** AppleScript strings use single quotes. If the message contains `'`, you must escape it as `'\''` in the bash command.
- **Sending without resolving the target first:** Always query the database to find the correct chat `guid` before sending. Never guess or hardcode chat identifiers.
