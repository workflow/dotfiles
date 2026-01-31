{...}: {
  flake.modules.homeManager.kanshi = {...}: {
    services.kanshi = {
      enable = true;
      settings = [
        {
          output = {
            alias = "leftLG27";
            criteria = "HDMI-A-2";
            mode = "3840x2160@60.000Hz";
            position = "0,0";
            scale = 2.0;
            transform = "90";
          };
        }
        {
          output = {
            alias = "middleLG34";
            criteria = "DP-1";
            mode = "3840x2160@144.050Hz";
            position = "1080,208";
            scale = 1.5;
            transform = "normal";
          };
        }
        {
          output = {
            alias = "rightLG27";
            criteria = "HDMI-A-1";
            mode = "3840x2160@60.000Hz";
            position = "3640,0";
            scale = 2.0;
            transform = "90";
          };
        }
        {
          profile = {
            name = "numenor";
            outputs = [
              {
                criteria = "$leftLG27";
                status = "enable";
              }
              {
                criteria = "$middleLG34";
                status = "enable";
              }
              {
                criteria = "$rightLG27";
                status = "enable";
              }
            ];
          };
        }
        {
          profile = {
            name = "numenor-movie";
            outputs = [
              {
                criteria = "$leftLG27";
                status = "enable";
                position = "0,272";
                transform = "normal";
              }
              {
                criteria = "$middleLG34";
                status = "enable";
                position = "1920,132";
              }
              {
                criteria = "$rightLG27";
                status = "disable";
              }
            ];
          };
        }
      ];
    };
  };
}
