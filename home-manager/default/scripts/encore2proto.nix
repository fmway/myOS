{ pkgs, ... }: {
  runtimeEnv = {
    ENCORE_SRC = "${pkgs.encore.src}"; 
  };

  runtimeInputs = with pkgs; [
    buf
  ];
}
