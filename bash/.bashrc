if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# forces spaceship to show the whole pat on git repositories
export SPACESHIP_DIR_TRUNC_REPO=false

eval "$(starship init bash)"
. "$HOME/.cargo/env"

alias llvm-config="llvm-config-17"
alias llvm-as="llvm-as-17"
alias llc="llc-17"
