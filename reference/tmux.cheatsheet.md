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


Meta:
` send-prefix

Sessions:
$ command-prompt -I #S "rename-session '%%'"
( switch-client -p
) switch-client -n

Windows:
& confirm-before -p "kill-window #W? (y/n)" kill-windw
' command-prompt -p index "select-window -t ':%%'"
, command-prompt -I #W "rename-window '%%'"
0 select-window -t :0
1 select-window -t :1
2 select-window -t :2
3 select-window -t :3
4 select-window -t :4
5 select-window -t :5
6 select-window -t :6
7 select-window -t :7
8 select-window -t :8
9 select-window -t :9
E set-window-option synchronize-panes off
_ split-window -v
c new-window
e set-window-option synchronize-panes on
f command-prompt "find-window '%%'"
n next-window
| split-window -h
r rotate-window -D
s choose-tree
w choose-window

Panes:
C-o rotate-window
Space next-layout
! break-pane
H resize-pane -L 10
J resize-pane -D 10
K resize-pane -U 10
L resize-pane -R 10
h select-pane -L
j select-pane -D
k select-pane -U
l select-pane -R
o select-pane -t :.+
q display-panes
x confirm-before -p "kill-pane #P? (y/n)" kill-pane
+ resize-pane -Z
= resize-pane -Z
{ swap-pane -U
} swap-pane -D
Up select-pane -U
Down select-pane -D
Left select-pane -L
Right select-pane -R

Buffers:
# list-buffers
- delete-buffer
= choose-buffer
] paste-buffer
p paste-buffer

Copy Mode:
[ copy-mode

Utility:
: command-prompt
; command-prompt
? list-keys
i display-message
t clock-mode
~ show-messages


M-1 select-layout even-horizontal
M-2 select-layout even-vertical
M-3 select-layout main-horizontal
M-4 select-layout main-vertical
M-5 select-layout tiled
M-n next-window -a
M-o rotate-window -D
M-p previous-window -a
M-Up resize-pane -U 5
M-Down resize-pane -D 5
M-Left resize-pane -L 5
M-Right resize-pane -R 5
C-Up resize-pane -U
C-Down resize-pane -D
C-Left resize-pane -L
C-Right resize-pane -R
