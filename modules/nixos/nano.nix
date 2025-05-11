{ lib, ... }:
{
  programs.nano = {
    enable = lib.mkDefault true;
    nanorc = /* nanore */ ''
      set nowrap
      set tabstospaces
      set tabsize 2
      set linenumbers
      set autoindent
      set mouse
    '';
  };
}
