{
  services = {
    kanshi = {
      enable = true;
      systemdTarget = "graphical-session.target";
      settings = [
        {
          profile = {
            name = "laptop";
            outputs = [
              {
                criteria = "eDP-1";
              }
            ];
          };
        }
        {
          profile = {
            name = "home";
            outputs = [
              {
                criteria = "eDP-1";
                position = "296,720";
              }
              {
                criteria = "LG Electronics LG ULTRAGEAR 208NTVS0P575";
                position = "0,0";
                scale = 2.0;
                mode = "3440x1440@85.00Hz";
              }
            ];
          };
        }
        {
          profile = {
            name = "home2";
            outputs = [
              {
                criteria = "eDP-1";
                position = "0,0";
              }
              {
                criteria = "Samsung Electric Company S24F350 H4ZH808827";
                position = "1128,164";
                scale = 1.0;
                mode = "1920x1080@71.91Hz";
              }
            ];
          };
        }

      ];
    };
  };
}
