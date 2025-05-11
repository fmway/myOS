# @description simple suck for handling folder
if set -q argv[1] && [ -d "$argv[1]" ]
    set argv[1] +"tcd $argv[1]"
end
command nvim $argv
