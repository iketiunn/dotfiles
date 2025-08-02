# General
  zstyle ':completion:*' menu select # Arrow-key driven interface
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
  setopt COMPLETE_ALIASES
# History
  export HISTFILE=~/.zhistory
  export HISTSIZE=1000
  export SAVEHIST=1000
  setopt INC_APPEND_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt EXTENDED_HISTORY
# Compilations
  # Make Homebrew’s completions available in zsh
  # Must get the Homebrew-managed zsh site-functions on your FPATH before initialising zsh’s completion facility
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fi
  autoload -Uz compinit && compinit -u
  [ -s "/Users/ike/.bun/_bun" ] && source "/Users/ike/.bun/_bun" # bun path
  eval "$(gh copilot alias -- zsh)" # github copilot 
# Style
  [[ $TMUX = "" ]] && export TERM="xterm-256color"
# Plugins
  fpath=(/opt/homebrew/local/share/zsh-completions $fpath)
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  . /opt/homebrew/etc/profile.d/z.sh
    unalias z
    z() {
      if [[ -z "$*" ]]; then
        cd "$(_z -l 2>&1 | fzf +s --tac | sed 's/^[0-9,.]* *//')"
      else
        _last_z_args="$@"
        _z "$@"
      fi
    }

    zz() {
      cd "$(_z -l 2>&1 | sed 's/^[0-9,.]* *//' | fzf -q "$_last_z_args")"
    }
    alias j=z
    alias jj=zz
  # FZF
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    export FZF_DEFAULT_COMMAND='fd --type f' # Respecting .gitignore
    # Default color schema: Seoul256 Dusk
    export FZF_DEFAULT_OPTS='
      --color fg:242,bg:233,hl:65,fg+:15,bg+:234,hl+:108
      --color info:108,prompt:109,spinner:108,pointer:168,marker:168
    '
  # vscode
  if command -v code-insiders >/dev/null 2>&1; then
    alias code="code-insiders"
  elif command -v code >/dev/null 2>&1; then
    alias code="code"
  fi
# Misc
  function chpwd() { emulate -L zsh; ls } # overwrite cd to cd & ls
  setopt autocd autopushd
  setopt clobber # Same ">", ">>" behavior like bash
# Prompt
  export PROMPT="%1~ # " # Show only current dir, tmx shows last 2
  export RPROMPT="%T"
# Functions
ls-port-tcp() {
  (
    echo 'PROC PID USER x IPV x x PROTO BIND PORT'
    (
      lsof +c 15 -iTCP -sTCP:LISTEN -P -n | tail -n +2
    ) | sed -E 's/ ([^ ]+):/ \1 /' | sort -k8,8 -k5,5 -k1,1 -k10,10n
  ) | awk '{ printf "%-16s %-6s %-9s %-5s %-7s %s:%s\n",$1,$2,$3,$5,$8,$9,$10 }'
}
ls-port-udp() {
  (
    echo 'PROC PID USER x IPV x x PROTO BIND PORT'
    (
      lsof +c 15 -iUDP -P -n | tail -n +2 | egrep -v ' (127\.0\.0\.1|\[::1\]):'
    ) | sed -E 's/ ([^ ]+):/ \1 /' | sort -k8,8 -k5,5 -k1,1 -k10,10n
  ) | awk '{ printf "%-16s %-6s %-9s %-5s %-7s %s:%s\n",$1,$2,$3,$5,$8,$9,$10 }'
}
kimi() {
  # Set your api keys in ~/.zprofile
  export ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic"
  export ANTHROPIC_AUTH_TOKEN="$KIMI_API_KEY"

  args=()

  while getopts "ty" flag; do
    [[ $flag == "t" ]] && export ANTHROPIC_MODEL="kimi-k2-turbo-preview" ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview"
    [[ $flag == "y" ]] && args+=(--dangerously-skip-permissions)
  done

  shift $((OPTIND - 1))
  claude "${args[@]}" "$@"
}
google() {
  gemini -p "Search google for <query>$1</query> and summarize the results"
}
# Alias
  alias l="ls -G"
  alias ls="ls -G"
  alias la="ls -aG"
  alias ll="ls -lahg"
  alias gittree='if [ -e .gitignore ]; then TMP_FILE=$(mktemp); grep -v -f .gitignore <(tree -a -I "$(git ls-files --ignored --exclude-standard)" --noreport) > "$TMP_FILE"; cat "$TMP_FILE"; rm "$TMP_FILE"; else tree -a --noreport; fi'
  alias py-srv="python3 -m http.server"
  alias py-jq="python3 -m json.tool"
  alias base64-to-hex="echo $1 | base64 --decode | xxd -p | sed 's/../& /g'"
  alias hex-to-base64="echo $1 | xxd -r -p | base64"
  for i in {3..10}; do
    do=$(printf '.%.0s' {1..$i})
    pa=$(printf '../%.0s' {1..$((i-1))})
    alias "$do=cd $pa"
  done
  alias gr='cd "$(git rev-parse --show-toplevel)"' # Go to current git project root

source ~/.zsh-path

[ command -v fnm >/dev/null 2>&1 ] && eval "$(fnm env --use-on-cd)" # fnm, Node.js version manager. Enable auto-switching
[ command -v atuin >/dev/null 2>&1 ] && eval "$(atuin init zsh --disable-up-arrow)" # atuin, ctrl+r alternative
