# /dev/nall's tmux config cheatsheet

## Meta keys
    `
> prefix

    ` CTRL+d

> detach client

## Basic Session, Window, Pane Management

### Sessions

    tmux list-sessions 

> list all running sessions

    tmux attach-session -t $session_name 

> attach to an existing session named $session\_name

### Windows

### Panes
    ` CTRL+o

> rotate-window

> Poorly named, actually rotates panes within a window. Not super-useful but may as well keep it bound.
