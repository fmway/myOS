x: x.override {
  commandLineArgs = [
    "--enable-features=VaapiVideoDecodeLinuxGL,TouchpadOverscrollHistoryNavigation"
    "--use-gl=angle"
    "--use-angle=gl"
    "--ozone-platform=wayland"
  ];
}
