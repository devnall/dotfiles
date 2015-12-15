#Alfred Cheatsheet:

## Built-ins:
---

### File Manipulation:
---
* `open $file` open $file in associated app
* `find $file` reveal $file in Finder
* `in $file` look for the contents of $file

### Other:
---
* `dict $word` search for $word in Dictionary.app
* `spell $word` use Dictionary.app to suggest spellings for $word
* `email $contact` send an email to $contact using default mail client (gMail)

### Clipboard History:
---
* `SHIFT+CMD+C` to invoke (alt: invoke Alfred and use "clipboard" keyword)
* `clear` - clear clipboard history (with "Last 5 minutes" or "Last 15 minutes" options)
* Search Clipboard History by invoking it (`SHIFT+CMD+C`) and typing search term
* `SHIFT+CMD+V` quickly pastes the current contents of the clipboard into the frontmost app as plain text

#### Snippets:
---
* To create snippets: Alfred -> Preferences -> Features -> Clipboard -> Snippets
* To invoke snippets:
  * Open Clipboard History with `SHIFT+CMD+C`
  * Choose "All Snippets"
* Alternately:
  * Invoke Alfred
  * `snip $keyword`

### iTunes:
---
* `play`
* `pause`
* `next`
* `previous`
* `random` - play a random album
* `volmax` - set volume to max
* `volmid` - set volume to middle
* `mute`

### 1Password
---
* `1p $site` - Open $site and login

### System:
---
* `screensaver` - start screensaver
- `trash` - show trash
- `emptytrash` - empty trash
- `logout`
- `sleep`
- `lock`
- `restart`
- `shutdown`
- `hide` - hide current app window
- `quit` - quit current app
- `forcequit`
- `quitall`

## Custom Searches:
---
* `+gcal` - Add event to Google Calendar
* `+gmail` - Compose message in Google Mail
* `+rtm $task` - Add $task to Remember the Milk
* `define $word` - Search Wordnik for $word
* `discog $band` - Search Wikipedia for $band's discography
* `episode $tvshow` - Search wikipedia for $tvshow's episode list
* `gith $query` - Search github for $query
* `last $query` - Search last.fm for $query
* `meta $query` - Search metacritic for $query
* `pinb $query` - Search pinboard.in for $query
* `time $location` - Find local time in $location
* `goog $query` - Search Google for $query
* `img $query` - Search Google Images for $query
* `map $query` - Search Google Maps for $query
* `translate $query` - Google Translate $query
* `gmail` - Open Google Mail
* `gmail $query` - Search Google Mail for $query
* `drive` - Open Google Drive
* `drive $query` - Search Google Drive for $query
* `twitter` - Open Twitter.com in browser
* `twitter $query` - Search Twitter for $query
* `wiki $query` - Search Wikipedia for $query
* `amaz $query` - Search Amazon for $query
* `ebay $query` - Search Ebay for $query
* `youtube $query` - Search YouTube for $query
* `wolfram $query` - Ask Wolfram $query
* `weather $location` - Get weather for $location from Weather Underground

# Workflows:
---
* amaz $query - Search Amazon for $query and display results in Alfred
* convert $number - Convert $number from one USD to Euro or vice-versa
* dash $query - Search Dash programming docs for $query
* down $website - Query $website status from downforeveryone
* gm - Open or jump to Google Mail in Chrome
* itp $iterm2_profile - Open a new iTerm2 instance using $iterm2_profile
* man $unix_command - Seach ExplainShell.com for $unix_command; works great with command arguments
* roll $#d# - roll dice, e.g. roll 3d6
* timer #:## - set a countdown timer for #:##
* tz $city - Show local time in $city
* translate $string - Translate $string to/from French/Spanish/English
* u $measure to $unit - Unit converter. e.g. "u 26.2km to miles"
* conditions - Get current weather conditions in Atlanta
* forecast - Get four day forecast for Atlanta

######Last Updated: Dec 15, 2015
######Alfred Version: 2.8.1 (425)
######OS X Version: OS X 10.10.5 (14F1021)
