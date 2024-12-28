{ programs.fish = {
  enable = true;
  interactiveShellInit = ''
    set fish_greeting # Disable greeting
    printf '\e[5 q'
  '';
  functions = {
    nvim = {
      description = "simple suck for handling folder";
      body = /* fish */ ''
        if set -q argv[1] && [ -d "$argv[1]" ]
          cd $argv[1]
          command nvim $argv[2..-1]
          cd -
        else
          command nvim $argv
        end
      '';
    };
    strlen  = ''
      for arg in $argv
        count (string split "" -- $arg)
      end
    '';
    to-line = ''
      for i in $argv
        echo $i
      end
    '';
    unstring = {
      description = "remove string  'str' \"str\"";
      body = ''
        [ -z $argv ] && set -l argv && while read line
          set argv $argv $line
        end
        for string in $argv
          string replace -r '[\'"]([\s\S]+)[\'"]$' '$1' -- $string
        end
      '';
    };
  };
}; imports = [ ./shellAbbrs.nix ]; }
