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
  if [ -s "$HOME/.bun/_bun" ]; then
    source "$HOME/.bun/_bun"
    export PATH="$HOME/.bun/bin:$PATH"
  fi
  eval "$(gh copilot alias -- zsh)" # github copilot 
# Style
  [[ $TMUX = "" ]] && export TERM="xterm-256color"
# Shell Plugins
  fpath=(/opt/homebrew/local/share/zsh-completions $fpath)
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # FZF
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    export FZF_DEFAULT_COMMAND='fd --type f' # Respecting .gitignore
    # Default color schema: Seoul256 Dusk
    export FZF_DEFAULT_OPTS='
      --color fg:242,bg:233,hl:65,fg+:15,bg+:234,hl+:108
      --color info:108,prompt:109,spinner:108,pointer:168,marker:168
    '
  command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)" # zoxide, smarter cd
  command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow)" # atuin, ctrl+r alternative
  command -v fnm >/dev/null 2>&1 && eval "$(fnm env --use-on-cd)" # fnm, Node.js version manager. Enable auto-switching
  #command -v corepack >/dev/null 2>&1 && eval "$(corepack enable)" # bridge between Node projects and their package managers
  command -v node >/dev/null && { # unify node package managers
    np() {
      local pm
      if   [ -f bun.lockb ]; then pm="bun"
      elif [ -f pnpm-lock.yaml ]; then pm="pnpm"
      elif [ -f yarn.lock ]; then pm="yarn"
      elif [ -f package-lock.json ]; then pm="npm"
      else pm="bun"
      fi
      command -v "$pm" >/dev/null || {
        echo "🚫 Package manager '$pm' not found"; return 127
      }

      command "$pm" "$@"
    }

    alias npx="bunx"
  
    ##
    # Hard restrictions
    ##
    #for pm in npm yarn pnpm; do
    #  eval "$pm() { echo >&2 \"🚫 '$pm' is disabled. Use 'np' instead.\"; return 1; }"
    #done
  }
# Misc
  function chpwd() { emulate -L zsh; ls } # overwrite cd to cd & ls
  setopt autocd autopushd
  setopt clobber # Same ">", ">>" behavior like bash
# Prompt
  export PROMPT="%1~ λ " # Show only current dir, tmx shows last 2
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
c() {
  fnm use 24
  # Set your api keys in ~/.zprofile
  #export ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
  #export ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY"
  #export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"
  #export ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.7"
  #export ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.7"
  #export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"
  #export ANTHROPIC_AUTH_TOKEN="$MINIMAX_API_KEY"
  #export ANTHROPIC_DEFAULT_HAIKU_MODEL="MiniMax-M2.1"
  #export ANTHROPIC_DEFAULT_SONNET_MODEL="MiniMax-M2.1"
  #export ANTHROPIC_BASE_URL="https://api.moonshot.ai/anthropic"
  #export ANTHROPIC_AUTH_TOKEN="$KIMI_API_KEY"
  #export ANTHROPIC_DEFAULT_HAIKU_MODEL="kimi-k2-thinking-turbo"
  #export ANTHROPIC_DEFAULT_SONNET_MODEL="kimi-k2-thinking-turbo"
  #export ANTHROPIC_DEFAULT_OPUS_MODEL="kimi-k2-thinking-turbo"
  #export ANTHROPIC_DEFAULT_OPUS_MODEL="kimi-k2-thinking-turbo"
  # set in ~/.claude/settings.json

  args=()

  # Simple manual flag handling (only for -y)
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -y)
        args+=(--dangerously-skip-permissions)
        shift
        ;;
      -p)
        shift
        prompt="$1"
        #export ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-airx"
        export ANTHROPIC_DEFAULT_SONNET_MODEL=$ANTHROPIC_DEFAULT_HAIKU_MODEL
        export ANTHROPIC_DEFAULT_OPUS_MODEL=$ANTHROPIC_DEFAULT_HAIKU_MODEL
        args+=(-p "$prompt")
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        break
        ;;
    esac
  done

  claude "${args[@]}" "$@"
}
gccc() {
  command -v gemini >/dev/null 2>&1 || {
    echo "❌ gemini CLI not found"
    return 127
  }

  git diff --cached --quiet && {
    echo "❌ No staged changes to commit"
    return 1
  }

  local msg
  msg=$(
    git diff --cached --stat |
      gemini -p 'Output exactly one concise Conventional Commit title and nothing else. Input is the staged git diff --stat from stdin.' |
      sed -nE 's/.*((feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([^)]+\))?(!)?: .*)/\1/p' |
      head -n 1
  ) || {
    echo "❌ Failed to get commit message from Gemini"
    return 1
  }

  [[ -n "$msg" ]] || {
    echo "❌ Failed to parse commit message"
    return 1
  }

  echo "💡 $msg"
  read -r "?Press Enter to commit, Ctrl-C to cancel... " || return 130
  git commit -e -m "$msg"
}
google() {
  gemini -p "Search google for <query>$1</query> and summarize the results"
}
tree() {
  command tree -C "$@" | sed 's/\xc2\xa0/ /g'
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
  alias vim="nvim"
  # vscode
  if command -v code-insiders >/dev/null 2>&1; then
    alias code="code-insiders"
  elif command -v code >/dev/null 2>&1; then
    alias code="code"
  fi

source ~/.zsh-path

# peon-ping quick controls
alias peon="bash /Users/ike/.claude/hooks/peon-ping/peon.sh"
[ -f /Users/ike/.claude/hooks/peon-ping/completions.bash ] && source /Users/ike/.claude/hooks/peon-ping/completions.bash
