# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export DOTFILES="$HOME/code/useful-things/dotfiles"

ZSH_THEME="powerlevel10k/powerlevel10k"

# update reminders
zstyle ':omz:update' mode reminder
# stops them from being annoying
DISABLE_MAGIC_FUNCTIONS="true"
# auto corrects commands
ENABLE_CORRECTION="true"
# dots when function is auto completing
COMPLETION_WAITING_DOTS="true"
# stops git status from checking untracked files
DISABLE_UNTRACKED_FILES_DIRTY="true"

# load in plugins
plugins=(
  git
  )

source $ZSH/oh-my-zsh.sh
# remove preset aliases
unalias -a

# load in aliases
aliaspath=$DOTFILES/other/.aliasrc
if [ -f "$aliaspath" ]; then
    source "$aliaspath"
fi
# load in extra commands
commandpath=$DOTFILES/other/.commandsrc
if [ -f "$commandpath" ]; then
    source "$commandpath"
fi


customization=$DOTFILES/other
[[ ! -f $customization/.p10k.zsh ]] || source $customization/.p10k.zsh