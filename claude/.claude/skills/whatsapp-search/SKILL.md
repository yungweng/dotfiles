---
name: whatsapp-search
description: Use when user asks to find, search, or look up WhatsApp messages, chats, or conversations. Triggers on mentions of WhatsApp, messages, chats, "what did X say", "what did X tell me", or anything involving searching WhatsApp message history.
---

# WhatsApp Message Search

Search the user's WhatsApp message history directly via read-only SQLite queries against the local macOS database.

## Access

**Chat database:** `~/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ChatStorage.sqlite`
**Contacts database:** `~/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ContactsV2.sqlite`

**CRITICAL: Always open read-only to avoid corrupting the live database:**
```bash
sqlite3 -readonly "$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ChatStorage.sqlite"
```

For queries that need contact name resolution (especially group chats), attach ContactsV2:
```sql
ATTACH DATABASE 'file:$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ContactsV2.sqlite?mode=ro' AS contacts;
```

## Schema Quick Reference

```
ZWAMESSAGE       (Z_PK, ZMESSAGETYPE, ZISFROMME, ZSTARRED, ZCHATSESSION→ZWACHATSESSION,
                  ZGROUPMEMBER→ZWAGROUPMEMBER, ZMEDIAITEM→ZWAMEDIAITEM,
                  ZMESSAGEDATE [Core Data timestamp], ZSENTDATE [Core Data timestamp],
                  ZFROMJID [sender @lid], ZTOJID [recipient @s.whatsapp.net],
                  ZPUSHNAME [protobuf-encoded!], ZTEXT [plain text message body],
                  ZSTANZAID [unique message ID])

ZWACHATSESSION   (Z_PK, ZSESSIONTYPE [0=DM, 1=group, 2=broadcast, 3=status, 4=community, 5=newsletter],
                  ZREMOVED,
                  ZARCHIVED, ZHIDDEN, ZUNREADCOUNT, ZGROUPINFO→ZWAGROUPINFO,
                  ZLASTMESSAGE→ZWAMESSAGE, ZLASTMESSAGEDATE [Core Data timestamp],
                  ZCONTACTJID [@s.whatsapp.net or @g.us], ZPARTNERNAME [display name],
                  ZLASTMESSAGETEXT [protobuf-encoded! use ZTEXT from ZWAMESSAGE instead])

ZWAMEDIAITEM     (Z_PK, ZMESSAGE→ZWAMESSAGE, ZFILESIZE, ZMOVIEDURATION,
                  ZLATITUDE, ZLONGITUDE, ZMEDIAURLDATE, ZMEDIALOCALPATH,
                  ZMEDIAURL, ZTITLE, ZVCARDNAME, ZVCARDSTRING, ZAUTHORNAME)

ZWAGROUPINFO     (Z_PK, ZCHATSESSION→ZWACHATSESSION, ZSTATE,
                  ZCREATORJID, ZOWNERJID, ZSOURCEJID)

ZWAGROUPMEMBER   (Z_PK, ZCHATSESSION→ZWACHATSESSION, ZMEMBERJID [@lid],
                  ZCONTACTNAME, ZFIRSTNAME, ZISACTIVE, ZISADMIN)

-- ContactsV2.sqlite (attach as 'contacts'):
ZWAADDRESSBOOKCONTACT (Z_PK, ZFULLNAME, ZGIVENNAME, ZLASTNAME,
                       ZWHATSAPPID [@s.whatsapp.net], ZPHONENUMBER,
                       ZLID [@lid], ZBUSINESSNAME, ZABOUTTEXT, ZUSERNAME)
```

## Timestamp Handling

WhatsApp on macOS uses **Core Data timestamps** (seconds since 2001-01-01). Add `978307200` to convert to Unix epoch:

```sql
datetime(ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date
```

To filter by date range:
```sql
AND ZMESSAGEDATE BETWEEN strftime('%s','2025-01-01') - 978307200 AND strftime('%s','2025-12-31') - 978307200
```

## JID Format Reference

| Suffix | Meaning |
|---|---|
| `@s.whatsapp.net` | Individual contact (old format, in ZCONTACTJID/ZTOJID) |
| `@lid` | Individual contact (new format, in ZFROMJID/ZGROUPMEMBER) |
| `@g.us` | Group chat |
| `@broadcast` | Broadcast list |
| `@newsletter` | Newsletter/channel |
| `@status` | Status updates |

## Message Type Reference

| ZMESSAGETYPE | Meaning | Evidence |
|---|---|---|
| 0 | Text | ZTEXT populated, 50k+ messages |
| 1 | Image | .jpg media files |
| 2 | Video | .mp4 files, durations up to 120s |
| 3 | Voice message | .opus audio files with duration |
| 4 | Contact card | No local media, confirmed by forensic sources |
| 5 | Location | Has ZLATITUDE/ZLONGITUDE in ZWAMEDIAITEM |
| 6 | System/group event | ZGROUPEVENTTYPE set, text contains JIDs |
| 7 | URL/Link | ZTEXT contains URLs |
| 8 | Document/file | .pdf, .xlsx, .mp4 (sent as doc) |
| 10 | Call event | No text, ZGROUPEVENTTYPE varies |
| 11 | GIF/animated | Short .mp4 files (0-4s) |
| 14 | Deleted/revoked message | Empty text and minimal media |
| 15 | Sticker | .webp media files |
| 46 | View-once media | Media present, no local path |

## Search Strategy

Always cast a wide net. Run multiple queries in parallel across different angles — people remember fragments, not exact strings.

### 1. Find a chat by contact name (DMs)

```sql
SELECT Z_PK, ZPARTNERNAME, ZCONTACTJID, ZSESSIONTYPE,
       datetime(ZLASTMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as last_msg
FROM ZWACHATSESSION
WHERE ZREMOVED = 0 AND ZPARTNERNAME LIKE '%searchterm%'
ORDER BY ZLASTMESSAGEDATE DESC;
```

### 2. Search messages by text content in a specific chat

```sql
SELECT m.Z_PK, substr(m.ZTEXT, 1, 200) as text_preview,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       m.ZISFROMME
FROM ZWAMESSAGE m
WHERE m.ZCHATSESSION = <CHAT_Z_PK>
  AND m.ZTEXT LIKE '%keyword%'
ORDER BY m.ZMESSAGEDATE DESC LIMIT 30;
```

### 3. Search messages across ALL chats

```sql
SELECT m.Z_PK, cs.ZPARTNERNAME, substr(m.ZTEXT, 1, 200) as text_preview,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       m.ZISFROMME, cs.ZSESSIONTYPE
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
WHERE cs.ZREMOVED = 0 AND m.ZTEXT LIKE '%keyword%'
ORDER BY m.ZMESSAGEDATE DESC LIMIT 30;
```

### 4. Get conversation context (messages around a time window)

```sql
SELECT m.Z_PK, substr(m.ZTEXT, 1, 200) as text_preview,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       m.ZISFROMME, m.ZMESSAGETYPE
FROM ZWAMESSAGE m
WHERE m.ZCHATSESSION = <CHAT_Z_PK>
  AND m.ZMESSAGEDATE BETWEEN <TARGET_TIMESTAMP> - 3600 AND <TARGET_TIMESTAMP> + 3600
ORDER BY m.ZMESSAGEDATE ASC;
```

### 5. List recent chats

```sql
SELECT Z_PK, ZPARTNERNAME, ZSESSIONTYPE, ZUNREADCOUNT,
       datetime(ZLASTMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as last_msg
FROM ZWACHATSESSION
WHERE ZREMOVED = 0
ORDER BY ZLASTMESSAGEDATE DESC LIMIT 20;
```

### 6. Find starred/saved messages

```sql
SELECT m.Z_PK, cs.ZPARTNERNAME, substr(m.ZTEXT, 1, 200) as text_preview,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       m.ZISFROMME
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
WHERE m.ZSTARRED = 1
ORDER BY m.ZMESSAGEDATE DESC;
```

### 7. Find media messages

```sql
SELECT m.Z_PK, cs.ZPARTNERNAME, m.ZMESSAGETYPE,
       mi.ZTITLE, mi.ZMEDIALOCALPATH, mi.ZFILESIZE,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
LEFT JOIN ZWAMEDIAITEM mi ON m.ZMEDIAITEM = mi.Z_PK
WHERE cs.ZREMOVED = 0
  AND m.ZMESSAGETYPE IN (1,2,3,8)  -- image, video, voice, document
  AND m.ZCHATSESSION = <CHAT_Z_PK>
ORDER BY m.ZMESSAGEDATE DESC LIMIT 20;
```

### 8. Group chat: identify who said what

Group messages require joining through ZGROUPMEMBER and cross-referencing ContactsV2 for names:

```sql
ATTACH DATABASE 'file:$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ContactsV2.sqlite?mode=ro' AS contacts;

SELECT c.ZFULLNAME as sender, substr(m.ZTEXT, 1, 200) as text_preview,
       cs.ZPARTNERNAME as group_name,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
LEFT JOIN ZWAGROUPMEMBER gm ON m.ZGROUPMEMBER = gm.Z_PK
LEFT JOIN contacts.ZWAADDRESSBOOKCONTACT c ON gm.ZMEMBERJID = c.ZLID
WHERE cs.ZSESSIONTYPE = 1 AND m.ZISFROMME = 0 AND m.ZTEXT IS NOT NULL
  AND m.ZCHATSESSION = <GROUP_CHAT_Z_PK>
ORDER BY m.ZMESSAGEDATE DESC LIMIT 30;
```

Note: Messages where `ZISFROMME=1` are from the user — these won't have a ZGROUPMEMBER.

### 9. Search for what a specific person said (across all chats)

Combine DM search + group member resolution:

```sql
ATTACH DATABASE 'file:$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ContactsV2.sqlite?mode=ro' AS contacts;

-- DM messages from this person
SELECT cs.ZPARTNERNAME as sender, substr(m.ZTEXT, 1, 200) as msg,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       'DM' as chat_type
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
WHERE cs.ZREMOVED = 0 AND cs.ZSESSIONTYPE = 0
  AND m.ZISFROMME = 0
  AND cs.ZPARTNERNAME LIKE '%personname%'
  AND m.ZTEXT LIKE '%keyword%'

UNION ALL

-- Group messages from this person
SELECT c.ZFULLNAME as sender, substr(m.ZTEXT, 1, 200) as msg,
       datetime(m.ZMESSAGEDATE + 978307200, 'unixepoch', 'localtime') as date,
       cs.ZPARTNERNAME as chat_type
FROM ZWAMESSAGE m
JOIN ZWACHATSESSION cs ON m.ZCHATSESSION = cs.Z_PK
JOIN ZWAGROUPMEMBER gm ON m.ZGROUPMEMBER = gm.Z_PK
JOIN contacts.ZWAADDRESSBOOKCONTACT c ON gm.ZMEMBERJID = c.ZLID
WHERE cs.ZREMOVED = 0 AND cs.ZSESSIONTYPE = 1
  AND c.ZFULLNAME LIKE '%personname%'
  AND m.ZTEXT LIKE '%keyword%'

ORDER BY date DESC LIMIT 30;
```

### 10. Contact lookup (phone number → name or vice versa)

```sql
-- Run against ContactsV2.sqlite directly:
sqlite3 -readonly "$HOME/Library/Group Containers/group.net.whatsapp.WhatsApp.shared/ContactsV2.sqlite" "
SELECT ZFULLNAME, ZPHONENUMBER, ZWHATSAPPID, ZLID, ZABOUTTEXT
FROM ZWAADDRESSBOOKCONTACT
WHERE ZFULLNAME LIKE '%searchterm%'
   OR ZPHONENUMBER LIKE '%searchterm%'
ORDER BY ZFULLNAME;"
```

## Common Mistakes

- **Not using read-only mode:** ALWAYS use `sqlite3 -readonly` — the DB is actively written by WhatsApp. Corruption = lost message history.
- **Forgetting the Core Data epoch offset:** Timestamps are NOT Unix epoch. Add `978307200` to convert. Omitting this gives dates in the year 2001.
- **Using ZLASTMESSAGETEXT for message content:** This field is **protobuf-encoded binary**, not plain text. Always use `ZTEXT` from `ZWAMESSAGE`.
- **Using ZPUSHNAME for sender names:** Also **protobuf-encoded** in current WhatsApp versions. Use `ZPARTNERNAME` (DMs) or the ZGROUPMEMBER→ContactsV2 join (groups) instead.
- **Searching only ZPARTNERNAME for "what did X say":** This only covers DMs. For group chats, the sender is identified via `ZGROUPMEMBER` → `ZWAGROUPMEMBER.ZMEMBERJID` → `ContactsV2.ZLID`. Always search both paths.
- **Not filtering ZREMOVED=0 on chat sessions:** Deleted chats remain in the DB with `ZREMOVED=1`. Always filter them out.
- **ZFROMJID in group chats is the GROUP JID**, not the individual sender. Don't try to resolve sender names from `ZFROMJID` when `ZSESSIONTYPE=1`.
- **JID format mismatch:** Old-format JIDs use `@s.whatsapp.net` (found in `ZCONTACTJID`, `ZTOJID`). New-format uses `@lid` (found in `ZFROMJID`, `ZMEMBERJID`). Match the correct format when joining.
- **Case sensitivity:** `LIKE` in SQLite is case-insensitive for ASCII but case-sensitive for Unicode. For German/accented names, consider using `LOWER()`.
- **Single-query approach:** People remember fragments. Run 4-5 parallel queries: contact name, message keywords, date range, group + DM paths. Cast a wide net.
