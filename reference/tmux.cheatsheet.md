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

    SPACE

> Cycle between pane layouts:

> > * even-horizontal - all panes evenly distributed horizontally

> > * even-vertical - all panes evenly distributed vertically

> > * main-horizontal - one main horizontal pane on top, all other panes evenly distributed vertically below

> > * main-vertical - one main vertical pane on left, all other panes evenly distributed horizontally below

> > * tiled - panes distributed evenly (as possible) in rows and columns
