# History
  export HISTFILE=~/.zhistory
  export HISTSIZE=10000
  export SAVEHIST=10000
  setopt INC_APPEND_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt EXTENDED_HISTORY
# Setup compelation
  # Make Homebrew’s completions available in zsh
  # Must get the Homebrew-managed zsh site-functions on your FPATH before initialising zsh’s completion facility
  if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
  fi
  autoload -Uz compinit && compinit
  zstyle ':completion:*' menu select # Arrow-key driven interface
  setopt COMPLETE_ALIASES
  zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
# Style
  [[ $TMUX = "" ]] && export TERM="xterm-256color"
# zsh plugins
  fpath=(/usr/local/share/zsh-completions $fpath)
  . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  . /usr/local/etc/profile.d/z.sh
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


# asdf: version manager
  . /usr/local/opt/asdf/asdf.sh
  # Avoid a slowdown when installing large packages
  # (see https://github.com/asdf-vm/asdf-nodejs/issues/46)
  # Reshim after installing all packages using `asdf reshim nodejs`
  export ASDF_SKIP_RESHIM=1
# haxe, temp added
  export HAXE_STD_PATH="/usr/local/lib/haxe/std"

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
  alias tree="tree -I \"$(cat .gitignore 2>&1 | egrep -v '^$|!|#' | sed 's/\/\*//' | tr -s '\n' '|')\""
  #alias cat="bat"
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

# Startup with tmux, TODO intergration with vscode is annoying
  #if [[ -z $TMUX ]]; then
  #  pgrep tmux && tmux
  #fi

# Prompt
  export PROMPT="%1~ λ " # Show only current dir, tmx shows last 2

# Android env
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
