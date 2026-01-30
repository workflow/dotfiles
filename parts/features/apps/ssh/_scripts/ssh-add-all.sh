#!/usr/bin/env bash
# SSH Key Manager for GNOME Keyring
# This script adds all SSH keys from ~/.ssh to the GNOME Keyring SSH agent

set -euo pipefail

# Check if SSH agent is running
if [ -z "${SSH_AUTH_SOCK:-}" ]; then
	echo "Error: SSH_AUTH_SOCK is not set. SSH agent might not be running."
	echo "Make sure GNOME Keyring SSH agent is started."
	exit 1
fi

# Find all SSH private keys in ~/.ssh directory
SSH_DIR="$HOME/.ssh"
if [ ! -d "$SSH_DIR" ]; then
	echo "Error: SSH directory $SSH_DIR does not exist."
	exit 1
fi

# Common SSH key patterns
KEY_PATTERNS=("id_rsa" "id_ed25519" "id_ecdsa" "id_dsa")

echo "Looking for SSH keys in $SSH_DIR..."

KEYS_FOUND=0
for pattern in "${KEY_PATTERNS[@]}"; do
	# Check for exact match first
	if [ -f "$SSH_DIR/$pattern" ]; then
		echo "Found key: $SSH_DIR/$pattern"
		ssh-add "$SSH_DIR/$pattern" || echo "Warning: Failed to add $SSH_DIR/$pattern"
		KEYS_FOUND=$((KEYS_FOUND + 1))
	fi

	# Check for numbered variants (e.g., id_rsa_1, id_rsa_2)
	for key_file in "$SSH_DIR"/"${pattern}"_*; do
		if [ -f "$key_file" ] && [[ ! "$key_file" == *.pub ]]; then
			echo "Found key: $key_file"
			ssh-add "$key_file" || echo "Warning: Failed to add $key_file"
			KEYS_FOUND=$((KEYS_FOUND + 1))
		fi
	done
done

# Also look for any other files that look like private keys
for key_file in "$SSH_DIR"/*; do
	if [ -f "$key_file" ] && [[ ! "$key_file" == *.pub ]] && [[ ! "$key_file" == *config* ]] && [[ ! "$key_file" == *known_hosts* ]]; then
		# Skip if we already processed this key
		basename_key=$(basename "$key_file")
		already_processed=false
		for pattern in "${KEY_PATTERNS[@]}"; do
			if [[ "$basename_key" == "$pattern" ]] || [[ "$basename_key" == ${pattern}_* ]]; then
				already_processed=true
				break
			fi
		done

		if [ "$already_processed" = false ]; then
			echo "Found potential key: $key_file"
			ssh-add "$key_file" || echo "Warning: Failed to add $key_file"
			KEYS_FOUND=$((KEYS_FOUND + 1))
		fi
	fi
done

if [ $KEYS_FOUND -eq 0 ]; then
	echo "No SSH keys found in $SSH_DIR"
	echo "You can create a new SSH key with: ssh-keygen -t ed25519 -C \"your_email@example.com\""
else
	echo "Processed $KEYS_FOUND SSH key(s)"
	echo ""
	echo "Current keys in SSH agent:"
	ssh-add -l || echo "No keys currently loaded in SSH agent"
fi
