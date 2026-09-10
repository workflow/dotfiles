{...}: {
  # Proton Mail Bridge for the desktop mail client: decrypts the Proton
  # mailbox locally and serves it to Thunderbird as IMAP 127.0.0.1:1143 /
  # SMTP 127.0.0.1:1025 (STARTTLS, self-signed cert — Thunderbird asks for a
  # one-time exception). PGP stays Proton's job; Thunderbird's own OpenPGP is
  # left off for this account so nothing gets double-signed.
  #
  # Keychain: Bridge stores its refresh tokens and vault key via the
  # freedesktop Secret Service, which gnome-keyring already provides on these
  # desktops (see ssh/default.nix), so no `pass` setup is needed.
  #
  # The account itself (accounts.email) is declared elsewhere. One-time
  # activation after the first switch:
  #   protonmail-bridge --cli      # login (password + 2FA), `info` → bridge password, exit
  #   systemctl --user restart protonmail-bridge
  # then enter the bridge password when Thunderbird first connects.
  flake.modules.homeManager.protonmail-bridge = {
    lib,
    osConfig,
    ...
  }: {
    services.protonmail-bridge = {
      enable = true;
      logLevel = "warn";
    };

    # vault + settings, gluon message cache, logs — losing the cache on a
    # reboot would mean a full mailbox re-sync every boot.
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".config/protonmail"
        ".local/share/protonmail"
        ".cache/protonmail"
      ];
    };
  };
}
