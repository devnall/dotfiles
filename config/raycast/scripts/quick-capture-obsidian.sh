#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Quick Capture to Obsidian
# @raycast.mode silent
# @raycast.argument1 { "type": "text", "placeholder": "Note content" }

INBOX="$HOME/Documents/Obsidian/KB/Inbox/"
DATE=$(date +%Y%m%d)
TIME=$(date +%H-%M-%S)
CREATED=$(date +%Y-%m-%dT%H:%M)
FILENAME="${DATE} ${TIME} Capture.md"

cat >"$INBOX/$FILENAME" <<EOF
---
status: inbox
type: capture
created: ${CREATED}
---
# ${DATE} Capture

$1
EOF

echo "Captured to Obsidian inbox"
