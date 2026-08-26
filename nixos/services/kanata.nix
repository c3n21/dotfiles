{
  services.kanata = {
    enable = true;
    keyboards = {
      laptop = {
        config =
          # lisp
          ''
            (defsrc
              caps esc c h j k l
            )

            (defalias
              scroll-layer
                (layer-while-held scrolling)

              scroll-left
                (mwheel-accel-left 3 1200 1.15 0.93)

              scroll-down
                (mwheel-accel-down 3 1200 1.15 0.93)

              scroll-up
                (mwheel-accel-up 3 1200 1.15 0.93)

              scroll-right
                (mwheel-accel-right 3 1200 1.15 0.93)
            )

            (deflayer base
              esc @scroll-layer c h j k l
            )

            (deflayer scrolling
              _ _ caps @scroll-left @scroll-down @scroll-up @scroll-right
            )
          '';

        devices = [
          "/dev/input/by-path/platform-i8042-serio-0-event-kbd"
        ];
      };
    };
  };

}
