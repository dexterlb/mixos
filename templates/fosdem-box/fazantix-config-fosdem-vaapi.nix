{ pkgs, ... }: {
  networking.firewall.allowedTCPPorts = [ 9899 ];
  programs.fazantix.config = {
    sources = {
      background = {
        type = "image";
        path = "${pkgs.fazantix-sample-images}/background.png";
      };
      camera = {
        type = "v4l";
        path = "/dev/video-cam";
        fmt = "yuyv";
        fps = 30;
        frames = {
          width = 1920;
          height = 1080;
          num_allocated_frames = 6;
        };
        num_frames_in_writing = 3;
      };
      slides = {
        type = "v4l";
        path = "/dev/video-slides";
        fmt = "yuyv";
        fps = 30;
        frames = {
          width = 1920;
          height = 1080;
          num_allocated_frames = 6;
        };
        num_frames_in_writing = 3;
      };
    };
    scenes = {
      cam-over-slides = {
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
            source = "camera";
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
            source = "slides";
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
      slides-over-cam = {
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
            source = "slides";
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
            source = "camera";
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
            source = "slides";
            transform = {
              x = 3.0e-2;
              y = 0.25;
              scale = 0.45;
              opacity = 1;
            };
          }
          {
            source = "camera";
            transform = {
              x = 0.52;
              y = 0.25;
              scale = 0.45;
              opacity = 1;
            };
          }
        ];
      };
      full-slides = {
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
            source = "slides";
            transform = {
              x = 0;
              y = 0;
              scale = 1;
              opacity = 1;
            };
          }
        ];
      };
      full-cam = {
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
            source = "camera";
            transform = {
              x = 0;
              y = 0;
              scale = 1;
              opacity = 1;
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
        default_scene = "full-slides";
        transition_time_ms = 1500;
      };
      stream = {
        type = "ffmpeg_stdin";
        cmd = ''
          ${pkgs.ffmpeg}/bin/ffmpeg \
            -y -v verbose \
            -init_hw_device vaapi=intel:/dev/dri/renderD128 \
            -fflags '+genpts+nobuffer+igndts' \
            -hwaccel vaapi -hwaccel_output_format vaapi \
            -hwaccel_device intel -filter_hw_device intel  \
            -flags low_delay \
            -probesize 32 \
            -analyzeduration 0 \
            -f rawvideo -video_size ''${SIZE} \
            -pixel_format rgba -framerate ''${RATE} -re -i - \
            -itsoffset 0.16 -f alsa -sample_rate 48000 -channels 2 -i hw:3 \
            -threads:0 0 \
            -filter_complex "[1:a] volume=volume=0dB [ain]; [0:v] format=nv12,hwupload [vout]" \
            -map '[vout]:0' \
            -c:v h264_vaapi -rc_mode CBR \
            -maxrate:v:0 5000k -bufsize:v:0 8192k \
            -b:v:0 3000k \
            -qmin:v:0 1 \
            -fps_mode cfr \
            -pix_fmt yuv420p \
            -map '[ain]:0' \
            -ac 2 -strict -2 -c:a aac -b:a 128k -ar 48000 \
            -f mpegts pipe:1 \
            | ${pkgs.fosdem-sproxy}/bin/sproxy 1000
        '';
        frames = {
          width = 1920;
          height = 1080;
          num_allocated_frames = 5;
        };
        default_scene = "slides-over-cam";
        transition_time_ms = 1500;
      };
    };
    api = {
      bind = ":8000";
      enable_profiler = true;
    };
    fallback_colour = "#ebac54";
    bg_colour = "#54aceb";
    base_framerate = 30;
  };
}
