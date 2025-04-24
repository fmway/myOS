{ super, lib, self, ... }:
_: {
  obs-studio = self.wrapOBS {
    plugins = with self.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
    ];
  };
}
