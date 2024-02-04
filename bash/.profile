# ensuring sourcing of /etc/profile
test -z "$PROFILEREAD" && source /etc/profile || true

# adding things to path
source "$HOME/.cargo/env" # addding the rust environment
export PATH="$HOME/.golang/bin:$PATH" # addding the go environment
export PATH="$HOME/.local/bin:$PATH" # adding my local scripts
export PATH="$HOME/.ghcup/bin:$PATH" # adding the haskell environment
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH" # adding bob neovim to path

# useful exports
export XDG_CONFIG_HOME=$HOME/.config # i don't understand why sometimes this variable is not set
export TERMINAL="kitty"
export BROWSER="firefox"
export PDF_READER="zathura"
export FILE_MANAGER="thunar"
export GOPATH="$HOME/.golang"
export GOBIN="$HOME/.golang/bin"

setxkbmap -layout us -variant altgr-intl # setting keyboard layout

# forces the loading of bashrc on login shells (useful for tmux)
# this should stay on the bottom
if [ -n "$BASH_VERSION" -a -n "$PS1" ]; then
	if [ -f "$HOME/.bashrc" ]; then
		. "$HOME/.bashrc"
	fi
fi
