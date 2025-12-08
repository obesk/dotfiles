if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# source "$HOME/.gvm/scripts/gvm" # go version manager environment (no idea why but it needs to be in the bashrc)
# . "$HOME/.cargo/env"

alias download_yt_video="yt-dlp -i -f bestvideo+bestaudio"
alias topdf="libreoffice --headless --convert-to pdf"
alias prime-run='__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'

mkcd () {
  mkdir -p $1 && cd $1
}

# forces spaceship to show the whole path on git repositories
export SPACESHIP_DIR_TRUNC_REPO=false
eval "$(starship init bash)"
