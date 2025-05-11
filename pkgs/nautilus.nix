{ internal, self, pkgs ? self, ... }: {
  __output.buildInputs.__append = with pkgs.gst_all_1; [
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-ugly
  ];
}
