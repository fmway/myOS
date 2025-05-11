{
  security = {
    polkit.enable = true;

    pam.services = {
      swaylock = {};
    };
  };
}
