# Initialize Starship prompt

DISABLE_UNTRACKED_FILES_DIRTY="true"
export DISABLE_AUTO_UPDATE="true"
export STARSHIP_CONFIG="$HOME/.config/starship.toml"

eval "$(starship init zsh)"

# Oh My Zsh path
export ZSH="$HOME/.oh-my-zsh"

# Plugins configuration
plugins=(zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Initialize Zoxide
eval "$(zoxide init zsh)"

# ZARCHBLACK environment settings
export PAGER='most'
export EDITOR='nano'
export VISUAL='nano'

# User Aliases
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -alFh'
alias ff='fastfetch'
alias update='sudo pacman -Syyu'
alias cat='bat'

# Source system-wide plugins if they exist
[[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Archive extraction function
ex () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.zip)       unzip $1     ;;
      *.7z)        7z x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
