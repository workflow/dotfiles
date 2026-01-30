{config, lib, ...}: let
  cfg = config;
in {
  flake.modules.homeManager.aichat = {
    lib,
    pkgs,
    ...
  }: {
    home.persistence."/persist" = lib.mkIf cfg.dendrix.isImpermanent {
      directories = [
        ".config/aichat"
      ];
    };

    programs.aichat = {
      enable = true;
      package = pkgs.unstable.aichat;
      settings = {
        model = "openai:gpt-5.1-chat-latest";
        keybindings = "vi";
        save_session = true;
        compress_threshold = 0;
        clients = [
          {type = "openai";}
          {type = "deepseek";}
          {
            type = "gemini";
            patch.chat_completions.".*".body.safetySettings = [
              {
                category = "HARM_CATEGORY_HARASSMENT";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_HATE_SPEECH";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_SEXUALLY_EXPLICIT";
                threshold = "BLOCK_NONE";
              }
              {
                category = "HARM_CATEGORY_DANGEROUS_CONTENT";
                threshold = "BLOCK_NONE";
              }
            ];
          }
          {type = "claude";}
        ];
      };
    };
  };
}
