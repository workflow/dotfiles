# Nushell Config File
#
# Defaults: https://github.com/nushell/nushell/blob/main/docs/sample_config/default_config.nu

# The default config record. This is where much of your global configuration is setup.
$env.config = {
  history: {
    max_size: 1_000_000 # Session has to be reloaded for this to take effect
  }

  keybindings: [
      #{
      #  name: completion_menu
      #  modifier: control
      #  keycode: char_s
      #  mode: [vi_insert vi_normal]
      #  event: {
      #    until: [
      #      { send: menu name: completion_menu }
      #      { send: menupagenext }
      #    ]
      #  }
      #}
      #{
      #  name: history_menu
      #  modifier: control
      #  keycode: char_h
      #  mode: [vi_insert vi_normal]
      #  event: {
      #    until: [
      #      { send: menu name: history_menu }
      #      { send: menupagenext }
      #    ]
      #  }
      #}
      {
          name: open_command_editor
          modifier: control
          keycode: char_e
          mode: [emacs, vi_normal, vi_insert]
          event: { send: openeditor }
      }
    ]
}
