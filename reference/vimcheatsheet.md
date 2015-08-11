#Vim Cheatsheet

##Standard vim shit:
###Panes:
- CTRL+A, CTRL+W, Arrow - Move to indicated pane
- CTRL+A, CTRL+W, CTRL+W - Switch to other/next pane

##Plugins:
###Fugitive:
:help :Git
- :Git \<command> - Run the specified git command
- :Gwrite - Stage the current file to the index (equiv. :Git add %)
- :Gread - Revert current file to last checked in version (equiv. :Git checkout %)
- :Gremove - Delete the current file and the corresponding vim buffer (equiv. :Git rm %)
- :Gmove - Rename the current file and the corresponding vim buffer (equiv. :Git mv %)
