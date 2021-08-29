# Vim Cheatsheet

## Standard vim Stuff:
* `.`: repeat the last change
* `>G`: increase indention level on this and all subsequent lines to end of file
* `:! <command>`: run a shell command

### Undo/Redo

* `u` - undo last change
* `U` - undo series of changes on current line
* `CTRL+R` - redo last change

### Cut/Copy/Paste

* `p` - put previously deleted text after the cursor
* `P` - put previously deleted text before the cursor


### Searching

* 

## Compound Commands

|Compound Command | Equivalent To |
| --------------- |:-------------:|
| C               | c$            |
| s               | cl            |
| S               | ^C            |
| I               | ^i            |
| A               | $a            |
| o               | A<CR>         |
| O               | ko            |

## Panes:

* `CTRL+W, Arrow` - Move to indicated pane
* `CTRL+W, CTRL+W` - Switch to other/next pane

## Folding:
* `{{{`: open a fold section
  * Precede with a comment marker
  * Follow with a description. 
  * Example: `#{{{ ---Section Description---`
* `}}}`: close a fold section (precede with comment marker)
* `za`: toggle a fold

##Plugins:

### Vundle:
* `:PluginList` - lists configured plugins
* `:PluginInstall` - installs plugins
* `:PluginUpdate` - update installed plugins
* `:PluginSearch foo` - searches for foo; append ! to refresh local cache
* `:PluginClean` - confirms removal of unused plugins; append ! to auto-approve

See `:h vundle` for more details or [the wiki](https://github.com/VundleVim/Vundle.vim/wiki) for FAQ

###Fugitive:

`:help :Git`

- `:Git \<command>` - Run the specified git command
- `:Gwrite` - Stage the current file to the index (equiv. :Git add %)
- `:Gread` - Revert current file to last checked in version (equiv. :Git checkout %)
- `:Gremove` - Delete the current file and the corresponding vim buffer (equiv. :Git rm %)
- `:Gmove` - Rename the current file and the corresponding vim buffer (equiv. :Git mv %)

### NERDTree

`:help NERDTree`

* `CTRL+n` - toggle NERDTree file browser

### NERDCommenter

`:help NERDCommenter`

* 
