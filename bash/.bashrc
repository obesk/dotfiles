if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# forces spaceship to show the whole pat on git repositories
export SPACESHIP_DIR_TRUNC_REPO=false

eval "$(starship init bash)"
. "$HOME/.cargo/env"
