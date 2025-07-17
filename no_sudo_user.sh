#!/bin/bash
# Set username
read -p "Enter the new username (no sudo access): " username

# Create the user without password login initially
sudo adduser --disabled-password --gecos "" "$username"

# Set a password for the USER
sudo passwd "$username"

# Make sure the user is NOT in the 'sudo' group.
sudo deluser "$username" sudo 2>/dev/null || echo "User not in sudo group already."

echo "User '$username' created without sudo privileges."

# Verify
id "$username"
