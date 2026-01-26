{ pkgs }: {
  sources = {
    background = {
      type = "image";
      path = "${pkgs.fazantix-sample-images}/background.png";
    };
    test1 = {
      tag = "tst1";
      type = "image";
      path = "${pkgs.fazantix-sample-images}/testsrc1.png";
      makescene = true;
    };
    test2 = {
      tag = "tst2";
      type = "image";
      path = "${pkgs.fazantix-sample-images}/testsrc2.png";
      makescene = true;
    };
    test3 = {
      tag = "tst3";
      type = "image";
      path = "${pkgs.fazantix-sample-images}/testsrc3.png";
      makescene = true;
    };
  };
  scenes = {
    side-by-side = {
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test1";
          transform = {
            cx = 0.25;
            cy = 0.5;
            left = 1.0e-2;
            opacity = 1;
          };
        }
        {
          source = "test2";
          transform = {
            cx = 0.75;
            cy = 0.5;
            right = 1.0e-2;
            opacity = 1;
          };
        }
      ];
    };
    full-1 = {
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test1";
          transform = {
            cy = 0.5;
            left = -3.0e-2;
            right = -3.0e-2;
            opacity = 1;
          };
          warp = {
            x = 3.0e-2;
            y = 3.0e-2;
            scale = 0.9;
            opacity = 0;
          };
        }
      ];
    };
    full-2 = {
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test2";
          transform = {
            cy = 0.5;
            left = -3.0e-2;
            right = -3.0e-2;
            opacity = 1;
          };
          warp = {
            x = 3.0e-2;
            y = 3.0e-2;
            scale = 0.9;
            opacity = 0;
          };
        }
      ];
    };
    full-3 = {
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test3";
          transform = {
            cy = 0.5;
            left = -3.0e-2;
            right = -3.0e-2;
            opacity = 1;
          };
          warp = {
            x = 3.0e-2;
            y = 3.0e-2;
            scale = 0.9;
            opacity = 0;
          };
        }
      ];
    };
    default = {
      tag = "dflt";
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test1";
          transform = {
            left = -4.0e-2;
            top = -4.0e-2;
            scale = 0.79;
            opacity = 1;
          };
          warp = {
            opacity = 0;
            cx = 0.5;
            cy = 0.5;
            scale = 0.1;
          };
        }
        {
          source = "test2";
          transform = {
            right = -4.0e-2;
            bottom = -0.1;
            scale = 0.25;
            opacity = 1;
          };
          warp = {
            opacity = 1;
            scale = 1.0e-3;
            right = -4.0e-2;
            bottom = -0.1;
          };
        }
      ];
    };
    default2 = {
      layers = [
        {
          source = "background";
          transform = {
            x = 0;
            y = 0;
            scale = 1;
            opacity = 1;
          };
        }
        {
          source = "test2";
          transform = {
            left = -4.0e-2;
            top = -4.0e-2;
            scale = 0.79;
            opacity = 1;
          };
          warp = {
            opacity = 0;
            cx = 0.5;
            cy = 0.5;
            scale = 0.1;
          };
        }
        {
          source = "test1";
          transform = {
            right = -4.0e-2;
            bottom = -0.1;
            scale = 0.25;
            opacity = 1;
          };
          warp = {
            opacity = 1;
            scale = 1.0e-3;
            right = -4.0e-2;
            bottom = -0.1;
          };
        }
      ];
    };
  };
  sinks = {
    projector = {
      type = "window";
      frames = {
        width = 1920;
        height = 1080;
      };
      default_scene = "default";
      transition_time_ms = 1500;
    };
  };
  api = {
    bind = ":8000";
    enable_profiler = true;
  };
  fallback_colour = "#ebac54";
  bg_colour = "#54aceb";
}
