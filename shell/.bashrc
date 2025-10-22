# .bashrc

export PATH="$HOME/dev_env/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export EMACSDIR="$XDG_CONFIG_HOME/emacs"
export DOOMDIR="$XDG_CONFIG_HOME/doom"

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.config/emacs/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
eval "$(/bin/mise activate bash)"
eval "$(zoxide init bash)"
export PATH="$HOME/.config/emacs/bin:$PATH"

#aliases
alias ll='eza -la'
alias lt='eza --tree'
alias ls='eza'
alias cat='bat --paging=never'
alias find='fd'
alias grep='rg'
alias ps='procs'
alias top='btop'
alias du='dust'
alias df='duf'

# Git aliases
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --graph'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gco='git checkout'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Terminal multiplexers
alias zj='zellij'




