# History
  export HISTFILE=~/.zhistory
  export HISTSIZE=1000
  export SAVEHIST=1000
  setopt INC_APPEND_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt EXTENDED_HISTORY
# Setup compelation
  # Make Homebrew’s completions available in zsh
  # Must get the Homebrew-managed zsh site-functions on your FPATH before initialising zsh’s completion facility
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fi
  autoload -Uz compinit && compinit -u
  zstyle ':completion:*' menu select # Arrow-key driven interface
  setopt COMPLETE_ALIASES
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
# Style
  [[ $TMUX = "" ]] && export TERM="xterm-256color"
# zsh plugins
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
    # Fuzzy grep open via ag with line number
    av() {
      local file
      local line

      read -r file line <<<"$(ag --nobreak --noheading $@ | fzf -0 -1 | awk -F: '{print $1, $2}')"

      if [[ -n $file ]]
      then
        vim $file +$line
      fi
    }

# neovim
alias vim=nvim

# Alias
  # Basic
  alias l="ls -G"
  alias ls="ls -G"
  alias la="ls -aG"
  alias ll="ls -lahg"
  alias ...="../.."
  alias ....="../../.."
  # Improves
  alias gittree='if [ -e .gitignore ]; then TMP_FILE=$(mktemp); grep -v -f .gitignore <(tree -a -I "$(git ls-files --ignored --exclude-standard)" --noreport) > "$TMP_FILE"; cat "$TMP_FILE"; rm "$TMP_FILE"; else tree -a --noreport; fi'
  # Python utils
  alias py-srv="python -m SimpleHTTPServer"
  alias py-jq="python -m json.tool"

# Misc
  # cd & ls
  function chpwd() { emulate -L zsh; ls }
  # Enter dir without cd
  setopt autocd autopushd
  # Same ">", ">>" behavior like bash
  setopt clobber

# Prompt
  export PROMPT="%1~ λ " # Show only current dir, tmx shows last 2
  export RPROMPT="%T"
  # Make right prompt time reset every 10 seconds (breaks with atuin)
  #TMOUT=10
  #TRAPALRM() {
  #    zle reset-prompt
  #}

# Functions
port-tcp() {
  (
    echo 'PROC PID USER x IPV x x PROTO BIND PORT'
    (
      lsof +c 15 -iTCP -sTCP:LISTEN -P -n | tail -n +2
    ) | sed -E 's/ ([^ ]+):/ \1 /' | sort -k8,8 -k5,5 -k1,1 -k10,10n
  ) | awk '{ printf "%-16s %-6s %-9s %-5s %-7s %s:%s\n",$1,$2,$3,$5,$8,$9,$10 }'
}

port-udp() {
  (
    echo 'PROC PID USER x IPV x x PROTO BIND PORT'
    (
      lsof +c 15 -iUDP -P -n | tail -n +2 | egrep -v ' (127\.0\.0\.1|\[::1\]):'
    ) | sed -E 's/ ([^ ]+):/ \1 /' | sort -k8,8 -k5,5 -k1,1 -k10,10n
  ) | awk '{ printf "%-16s %-6s %-9s %-5s %-7s %s:%s\n",$1,$2,$3,$5,$8,$9,$10 }'
}

base64-to-hex() {
  echo $1 | base64 --decode | xxd -p | sed 's/../& /g'
}

source ~/.zsh-path

# fnm
eval "$(fnm env --use-on-cd)"
# atuin: ctrl+r alternative, but it may break new line somehow
eval "$(atuin init zsh --disable-up-arrow)"
# github copilot, if u feel laggy, turn off the Usage Analytics by "gh copilot config"
eval "$(gh copilot alias -- zsh)"

