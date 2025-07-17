#!/bin/bash
# Prompt user for email subject and body
read -p "Enter subject: " subject
echo "Enter body (end with Ctrl+D):"
body=$(</dev/stdin)

# Prompt for recipient (local user)
read -p "Enter local username to send mail to: " recipient

# Validate recipient
if ! id "$recipient" &>/dev/null; then
    echo "User '$recipient' does not exist."
    exit 1
fi

# Send the mail
echo "$body" | mail -s "$subject" "$recipient"

echo "Mail sent to $recipient."
