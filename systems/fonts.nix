{ pkgs, ... }:
{
  # add fonts
  fontDir.enable = true;
  packages = (with pkgs; [
    # amiri
    corefonts
    # clearlyU
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    roboto
    liberation_ttf
    dejavu_fonts
    roboto-serif
  ]) ++ (with pkgs.nerd-fonts; [
    # _0xproto
    _3270
    # agave
    # anonymice
    # arimo
    # aurulent-sans-mono
    # bigblue-terminal
    # bitstream-vera-sans-mono
    # blex-mono
    # caskaydia-cove
    # caskaydia-mono
    # code-new-roman
    # comic-shanns-mono
    # commit-mono
    # cousine
    # d2coding
    # daddy-time-mono
    dejavu-sans-mono
    # departure-mono
    # droid-sans-mono
    # envy-code-r
    # fantasque-sans-mono
    fira-code
    fira-mono
    # geist-mono
    # go-mono
    # gohufont
    # hack
    # hasklug
    # heavy-data
    # hurmit
    # im-writing
    # inconsolata
    # inconsolata-go
    # inconsolata-lgc
    # intone-mono
    # iosevka
    # iosevka-term
    # iosevka-term-slab
    jetbrains-mono
    # lekton
    # liberation
    # lilex
    # martian-mono
    # meslo-lg
    # monaspace
    # monofur
    # monoid
    # mononoki
    # mplus
    # noto
    # open-dyslexic
    # overpass
    # override
    # overrideDerivation
    # profont
    # proggy-clean-tt
    # recurseForDerivations
    # recursive-mono
    # roboto-mono
    # sauce-code-pro
    # shure-tech-mono
    # space-mono
    # symbols-only
    # terminess-ttf
    # tinos
    ubuntu
    # ubuntu-mono
    # ubuntu-sans
    # victor-mono
    # zed-mono
  ]);
}
