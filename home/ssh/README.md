# SSH Agent Setup with GNOME Keyring

This configuration sets up SSH agent integration with GNOME Keyring on your Niri NixOS system. This allows SSH key passphrases to be stored securely in GNOME Keyring and automatically provided when needed.

## How it works

1. **GNOME Keyring SSH Agent**: Instead of using the default ssh-agent, we use GNOME Keyring's SSH agent component which integrates with the keyring for secure passphrase storage.

2. **Automatic Key Addition**: SSH is configured with `AddKeysToAgent yes` so keys are automatically added to the agent when first used.

3. **Persistent Storage**: Passphrases are stored in GNOME Keyring and will be remembered between sessions.

## Usage

### First Time Setup

1. **Rebuild your NixOS configuration**:
   ```bash
   sudo nixos-rebuild switch --flake .
   ```

2. **Restart your session** or manually start the SSH agent:
   ```bash
   systemctl --user start gnome-keyring-ssh
   ```

3. **Add your SSH keys** (optional, they'll be added automatically when first used):
   ```bash
   ssh-add-all  # Adds all SSH keys from ~/.ssh
   ```

### Daily Usage

- **First SSH connection**: You'll be prompted to enter your key passphrase once per session
- **Subsequent connections**: No passphrase required - GNOME Keyring provides it automatically
- **Unlocking keyring**: If prompted to unlock the keyring, enter your user password

### Useful Commands

- **List loaded keys**: `ssh-add -l`
- **Add all keys manually**: `ssh-add-all`
- **Add specific key**: `ssh-add ~/.ssh/id_ed25519`
- **Remove all keys**: `ssh-add -D`
- **Check agent status**: `systemctl --user status gnome-keyring-ssh`

### Troubleshooting

If SSH agent isn't working:

1. **Check if service is running**:
   ```bash
   systemctl --user status gnome-keyring-ssh
   ```

2. **Check environment variable**:
   ```bash
   echo $SSH_AUTH_SOCK
   # Should show: /run/user/1000/keyring/ssh
   ```

3. **Restart the service**:
   ```bash
   systemctl --user restart gnome-keyring-ssh
   ```

4. **Unlock GNOME Keyring**:
   - Run `seahorse` (GNOME Passwords and Keys)
   - Unlock the "Default" keyring if locked

### Security Notes

- Passphrases are stored encrypted in GNOME Keyring
- The keyring is protected by your user login password
- Keys are automatically removed from the agent when you log out
- You can view and manage stored passphrases using Seahorse (GNOME Passwords and Keys)
