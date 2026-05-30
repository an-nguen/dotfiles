function install_starship() {
  if ! command -v starship &> /dev/null; then 
    echo 'test'
  . /etc/os-release
  case "$ID" in
    debian)
      sudo apt install -y starship
      ;;
    fedora)
      sudo dnf copr enable atim/starship
      sudo dnf install starship
      ;;
    arch)
      sudo pacman -S starship
      ;;
    *)
      curl -sS https://starship.rs/install.sh | sh
      ;;
  esac
  fi
}

DOTFILES_GIT_DIR=$HOME/.dotfiles/
alias git-dotfiles='/usr/bin/git --git-dir=$DOTFILES_GIT_DIR --work-tree=$HOME'

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
      https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
# Install missing modules and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

install_starship
eval "$(starship init zsh)"

# fnm
FNM_PATH="/home/an/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env --shell zsh)"
fi

if command -v ng >/dev/null 2>&1
then
  # Load Angular CLI autocompletion.
  source <(ng completion script)
fi

