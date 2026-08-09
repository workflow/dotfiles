{...}: {
  flake.modules.homeManager.opencode = {
    osConfig,
    config,
    lib,
    pkgs,
    ...
  }: let
    allowRules = lib.listToAttrs (lib.concatMap (prefix: [
        {
          name = prefix;
          value = "allow";
        }
        {
          name = "${prefix} *";
          value = "allow";
        }
      ])
      config.dendrix.agents.shellAllowlist);
    askRules = lib.genAttrs config.dendrix.agents.shellAsklist (_: "ask");
    denyRules = lib.genAttrs config.dendrix.agents.shellDenylist (_: "deny");

    # Stylix ships an opencode target that generates a "stylix" theme with
    # per-key {dark, light} values and selects it. opencode chooses dark vs
    # light by *terminal background luminance*, and Stylix's .light slots assume
    # a dark-scheme ordering: on a light base16 scheme (catppuccin-latte in the
    # light specialisation) it paints near-white text on base06 (Rosewater, a
    # pink-orange), i.e. the unreadable "yellow on orange".
    #
    # Each specialisation only ever runs one polarity (dark spec => gruvbox on a
    # dark terminal; light spec => latte on a light terminal), so single hex
    # values over the *active* scheme's logical slots are correct for both. The
    # slots below mirror Stylix's own .dark mapping verbatim, so the dark theme
    # is byte-identical to before and only the broken light rendering changes.
    c = config.lib.stylix.colors.withHashtag;
    opencodeThemeColors = {
      primary = c.base0D;
      secondary = c.base0E;
      accent = c.base0F;
      error = c.base08;
      warning = c.base0A;
      success = c.base0B;
      info = c.base0C;
      text = c.base05;
      textMuted = c.base04;
      background = c.base00;
      backgroundPanel = c.base01;
      backgroundElement = c.base01;
      border = c.base02;
      borderActive = c.base03;
      borderSubtle = c.base02;
      diffAdded = c.base0B;
      diffRemoved = c.base08;
      diffContext = c.base03;
      diffHunkHeader = c.base03;
      diffHighlightAdded = c.base0B;
      diffHighlightRemoved = c.base08;
      diffAddedBg = c.base01;
      diffRemovedBg = c.base01;
      diffContextBg = c.base01;
      diffLineNumber = c.base03;
      diffAddedLineNumberBg = c.base01;
      diffRemovedLineNumberBg = c.base01;
      markdownText = c.base05;
      markdownHeading = c.base0E;
      markdownLink = c.base0D;
      markdownLinkText = c.base0C;
      markdownCode = c.base0B;
      markdownCodeBlock = c.base01;
      markdownBlockQuote = c.base03;
      markdownEmph = c.base0A;
      markdownStrong = c.base09;
      markdownHorizontalRule = c.base04;
      markdownListItem = c.base0D;
      markdownListEnumeration = c.base0C;
      markdownImage = c.base0D;
      markdownImageText = c.base0C;
      syntaxComment = c.base04;
      syntaxKeyword = c.base0E;
      syntaxFunction = c.base0D;
      syntaxVariable = c.base07;
      syntaxString = c.base0B;
      syntaxNumber = c.base09;
      syntaxType = c.base0A;
      syntaxOperator = c.base0C;
      syntaxPunctuation = c.base05;
    };
  in {
    home.persistence."/persist" = lib.mkIf osConfig.dendrix.isImpermanent {
      directories = [
        ".local/share/opencode"
        ".cache/uv" # kagimcp is fetched by uvx; keep it across boots
      ];
    };

    programs.opencode = {
      enable = true;
      package = pkgs.unstable.opencode;
      # Override Stylix's broken light mapping; tui.theme = "stylix" is set by
      # the Stylix opencode target itself.
      themes.stylix.theme = lib.mkForce opencodeThemeColors;
      settings = {
        model = "zai-coding-plan/glm-5.2";
        small_model = "zai-coding-plan/glm-5-turbo";
        disabled_providers = ["zai"];
        permission.edit = "ask";
        permission.bash = {"*" = "ask";} // allowRules // askRules // denyRules;
        mcp.kagi = {
          type = "local";
          command = [(lib.getExe' pkgs.uv "uvx") "kagimcp"];
        };
      };
    };
  };
}
