if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

source "$HOME/.gvm/scripts/gvm" # go version manager environment (no idea why but it needs to be in the bashrc)

alias download_yt_video="yt-dlp -i -f bestvideo+bestaudio"
alias topdf="libreoffice --headless --convert-to pdf"

mkcd () {
  mkdir -p $1 && cd $1
}

# forces spaceship to show the whole path on git repositories
export SPACESHIP_DIR_TRUNC_REPO=false
eval "$(starship init bash)"
. "$HOME/.cargo/env"
