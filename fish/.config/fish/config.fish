if status is-interactive
    # Commands to run in interactive sessions can go here
    if set -q SSH_CONNECTION; and not set -q TMUX; and not set -q ZELLIJ
        tmux new-session -A -s BlackLands
    end
end

fish_add_path ~/bin
fish_add_path ~/go/bin
