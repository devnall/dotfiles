# cVim Chrome Extension Cheatsheet


[cVim](https://github.com/1995eaton/chromium-vim) (or Chromium Vim) is an extension to allow you to interact with Chrome wholly from the keyboard, using
vim-like keyboard shortcuts.

Configuration is managed via a cvimrc which can be configured in the extention's Options page.
The cvimrc can also be synced to/from a GitHub Gist.
My cvimrc can be found here: https://gist.github.com/devnall/4ccd8f2779856016b9811bdacfe4d16d

## Keybinds

### Scrolling

|Movement|Action|Mapping Name|
|-----|------|-------|
|`j`,`s`|scroll down|scrollDown|
|`k`,`w`|scroll up|scrollUp|
|`h`|scroll left|scrollLeft|
|`l`|scroll right|scrollRight|
|`d`|scroll half page down|scrollPageDown|
|unmapped|scroll full page down|scrollFullPageDown|
|`u`,`e`|scroll half page up|scrollPageUp|
|unmapped|scroll full page up|scrollFullPageUp|
|`gg`|scroll to top of page|scrollToTop|
|`G`|scroll to bottom of page|scrollToBottom|
|`0`|scroll to the left of the page|scrollToLeft|
|`$`|scroll to the right of the page|scrollToRight|
|`#`|reset the scroll focus to the main page|resetScrollFocus|
|`gi`|go to the first input box|goToInput|
|`gI`|go to the last input box that was in focus|goToLastInput|
|`zz`|center page to current search match|centerMatchH|
|`zt`|scroll current search match to top of page|centerMatchT|
|`zb`|scroll current search match to bottom of page|centerMatchB|

### Link Hints

|Movement|Action|Mapping Name|
|------|------|------|
|`f`|open link in current tab|createHint|
|`F`|open link in new tab|createTabbedHint|
|`W`|open link in new window|createHintWindow|
|`A`|repeat last hint command|openLastHint|
|`mf`|open multiple links in new tabs|createMultiHint|
|`mr`|reverse image search multiple links|multiReverseImage|
|`my`|yank multiple links|multiYankUrl|
|`gy`|copy URL from link to clipboard|yankUrl|
|`gr`|reverse image search (google images)|reverseImage|
|`;`|change the link hint focus||

### Miscellaneous

|Movement|Action|Mapping Name|
|-----|------|-------|
|`a`|alias to ":tabnew google "| :tabnew google |
|`.`|repeat the last command| repeatCommand |
|`:`|open command bar|openCommandBar|
|`/`|open search bar|openSearchBar|
|`?`|open search bar (reverse search)|openSearchBarReverse|
|`I`|search through browser history| :history |
|`i`|enter insert mode (escape to exit)|insertMode|
|`r`|reload the current tab|reloadTab|
|`gR`|reload the current tab + local cache|reloadTabUncached|
|`cm`|mute/unmute a tab|muteTab|
|`cr`|reload all tabs but current|reloadAllButCurrent|
|`zi`|zoom page in|zoomPageIn|
|`zo`|zoom page out|zoomPageOut|
|`z0`|zoom page to original size|zoomOrig|
|`gd`|alias to :chrome://downloads&lt;CR&gt;| :chrome://downloads&lt;CR&gt; |
|`ge`|alias to :chrome://extensions&lt;CR&gt;| :chrome://extensions&lt;CR&gt; |
|`yy`|copy the URL of the current page to the clipboard|yankDocumentUrl|
|`yY`|copy the URL of the current frame to the clipboard|yankRootUrl|
|`ya`|copy the URLs in the current window|yankWindowUrls|
|`b`|search through bookmarks| :bookmarks |
|`p`|open the clipboard selection|openPaste|
|`P`|open the clipboard selection in a new tab|openPasteTab|
|`gj`|hide the download shelf|hideDownloadsShelf|
|`gq`|stop the current tab from loading|cancelWebRequest|
|`gQ`|stop all tabs from loading|cancelAllWebRequests|
|`gu`|go up one path in the URL|goUpUrl|
|`gU`|go to to the base URL|goToRootUrl|
|`g-`|decrement the first number in the URL path|decrementURLPath|
|`g+`|increment the first number in the URL path|incrementURLPath|

### Tab Navigation

|Movement|Action|Mapping Name|
|-----|------|-------|
|`gt`,`K`,`R`|navigate to the next tab|nextTab|
|`gT`,`J`,`E`|navigate to the previous tab|previousTab|
|`g0`,`g$`|go to the first/last tab|firstTab, lastTab|
|`x`|close the current tab|closeTab|
|`gxT`|close the tab to the left of the current tab|closeTabLeft|
|`gxt`|close the tab to the right of the current tab|closeTabRight|
|`gx0`|close all tabs to the left of the current tab|closeTabsToLeft|
|`gx$`|close all tabs to the right of the current tab|closeTabsToRight|
|`X`|open the last closed tab|lastClosedTab|
|`t`| :tabnew | :tabnew |
|`T`| :tabnew &lt;CURRENT URL&gt; | :tabnew @% |
|`O`| :open &lt;CURRENT URL&gt; | :open @% |
|`H`,`S`|go back|goBack|
|`L`,`D`|go forward|goForward|
|`B`|search for another active tab| :buffer |
|`<`|move current tab left|moveTabLeft|
|`>`|move current tab right|moveTabRight|
|`]]`|click the "next" link on the page|nextMatchPattern|
|`[[`|click the "back" link on the page|previousMatchPattern|
|`gp`|pin/unpin the current tab|pinTab|

### Find Mode

|Movement|Action|Mapping Name|
|-----|------|-------|
|`n`|next search result|nextSearchResult|
|`N`|previous search result|previousSearchResult|
|`v`|enter visual/caret mode (highlight current search/selection)|toggleVisualMode|
|`V`|enter visual line mode from caret mode/currently highlighted search|toggleVisualLineMode|

### Visual/Caret Mode

|Movement|Action|
|-----|------|
|`<Esc>`|exit visual mode to caret mode/exit caret mode to normal mode|
|`v`|toggle between visual/caret mode|
|`h`,`j`,`k`,`l`|move the caret position/extend the visual selection|
|`y`|copys the current selection|
|`n`|select the next search result|
|`N`|select the previous search result|
|`p`|open highlighted text in current tab|
|`P`|open highlighted text in new tab|

## Command Mode

| Command                                     | Description                                                                            |
| ------------------------------------------- | -------------------------------------------------------------------------------------- |
| :tabnew (autocomplete)                      | open a new tab with the typed/completed search                                         |
| :new (autocomplete)                         | open a new window with the typed/completed search                                      |
| :open (autocomplete)                        | open the typed/completed URL/google search                                             |
| :history (autocomplete)                     | search through browser history                                                         |
| :bookmarks (autocomplete)                   | search through bookmarks                                                               |
| :bookmarks /&lt;folder&gt; (autocomplete)   | browse bookmarks by folder/open all bookmarks from folder                              |
| :set (autocomplete)                         | temporarily change a cVim setting                                                      |
| :chrome:// (autocomplete)                   | open a chrome:// URL                                                                   |
| :tabhistory (autocomplete)                  | browse the different history states of the current tab                                 |
| :command `<NAME>` `<ACTION>`                | aliases :`<NAME>` to :`<ACTION>`                                                       |
| :quit                                       | close the current tab                                                                  |
| :qall                                       | close the current window                                                               |
| :restore (autocomplete)                     | restore a previously closed tab (newer versions of Chrome only)                        |
| :tabattach (autocomplete)                   | move the current tab to another open window                                            |
| :tabdetach                                  | move the current tab to a new window                                                   |
| :file (autocomplete)                        | open a local file                                                                      |
| :source (autocomplete)                      | load a cVimrc file into memory (this will overwrite the settings in the options page if the `localconfig` setting had been set previously |
| :duplicate                                  | duplicate the current tab                                                              |
| :settings                                   | open the settings page                                                                 |
| :nohlsearch                                 | clear the highlighted text from the last search                                        |
| :execute                                    | execute a sequence of keys (Useful for mappings. For example, "map j :execute 2j<CR>") |
| :buffer (autocomplete)                      | change to a different tab                                                              |
| :mksession                                  | create a new session from the current tabs in the active window                        |
| :delsession (autocomplete)                  | delete a saved session                                                                 |
| :session (autocomplete)                     | open the tabs from a saved session in a new window                                     |
| :script                                     | run JavaScript on the current page                                                     |
| :togglepin                                  | toggle the pin state of the current tab                                                |
| :pintab                                     | pin the current tab                                                                    |
| :unpintab                                   | unpin the current tab                                                                  |

## Tips

* You can use `@%` in "open" commands to specify the current URL. For example, `:open @%` would essentially 
refresh the current page.
* Prepend a number to the command to repeat that command N times
* Use the up/down arrows in command/find mode to navigate through previously executed commands/searches -- you 
can also use this to search for previously executed commands starting with a certain combination of letters (for 
example, entering `ta` in the command bar and pressing the up arrow will search command history for all matches 
beginning with `ta`
