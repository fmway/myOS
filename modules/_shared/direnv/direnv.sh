session_name() {
  export TMUX_SESSION_NAME="${*:?session_name needs a name as argument}"
}
use_lorri() {
  eval "$(lorri direnv $@)"
}
