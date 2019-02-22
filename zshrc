# Setup compelation
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select # Arrow-key driven interface
setopt COMPLETE_ALIASES
# Enter dir without cd
setopt autocd autopushd
# Same ">", ">>" behavior like bash
setopt clobber

##
# zsh plugins
##
fpath=(/usr/local/share/zsh-completions $fpath)
. /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
. /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# asdf
. /usr/local/opt/asdf/asdf.sh

# Alias
alias l="ls -G"
alias ls="ls -G"
alias la="ls -aG"
alias ll="ls -lahg"
alias ...="../.."
alias ....="../../.."
# python server
alias py-srv="python -m SimpleHTTPServer"
alias py-jq="python -m json.tool"

# cd & ls
function chpwd() {
  emulate -L zsh
  ls -a
}

# Style
[[ $TMUX = "" ]] && export TERM="xterm-256color"

# Startup with tmux
#if [[ -z $TMUX ]]; then
#  pgrep tmux && tmux
#fi

# Custom prompt
#export PROMPT="%2~ λ "
export PROMPT="%1~ λ "
