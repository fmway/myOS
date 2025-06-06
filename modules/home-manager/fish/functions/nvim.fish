# @description simple suck for handling folder
if set -q argv[1]
  if [ -d "$argv[1]" ]
    ! command -q zoxide || zoxide add $argv
    set argv[1] +"tcd $argv[1]"
  else if command -q zoxide && set dir (zoxide query "$argv[1]")
    set argv[1] +"tcd $dir"
  end
end
command nvim $argv
