# Color Palettes

## NordicPine

### Background / Foreground / Cursor / Selection

| Role               | Hex       |
|--------------------|-----------|
| Background         | `#0f111a` |
| Foreground         | `#c6e0df` |
| Cursor             | `#c6e0df` |
| Cursor text        | `#0f111a` |
| Selection bg       | `#232a3b` |
| Selection fg       | `#e4f5f4` |

### Primary accents

| Role                      | Hex       |
|---------------------------|-----------|
| Teal (command / branch)   | `#38c9a7` |
| Cyan (path / dir)         | `#6ab4c2` |
| Blue (keyword / k8s)      | `#087fab` |

### Secondary accents

| Role                          | Hex       |
|-------------------------------|-----------|
| Dark cyan (ANSI 6)            | `#33859d` |
| Gold (string literals)        | `#e6cc6f` |
| Yellow (ANSI 3 / aws)         | `#ddbc44` |
| Orange-red (error / git del)  | `#e16c58` |
| Dark red (ANSI 1)             | `#bb2938` |
| Pink (separator / terraform)  | `#cca2c0` |
| Lavender (globbing)           | `#ffd2f8` |
| Muted blue (ANSI 4 / docker)  | `#2a5f8f` |
| Dark green (ANSI 2)           | `#26a98b` |
| Borders / invisibles          | `#343b51` |
| Autosuggest / comments        | `#555e7a` |

### ANSI Palette

| Index | Label         | Hex       |
|-------|---------------|-----------|
| 0     | Black         | `#1c2030` |
| 1     | Red           | `#bb2938` |
| 2     | Green         | `#26a98b` |
| 3     | Yellow        | `#ddbc44` |
| 4     | Blue          | `#2a5f8f` |
| 5     | Magenta       | `#cca2c0` |
| 6     | Cyan          | `#33859d` |
| 7     | White         | `#c6e0df` |
| 8     | Bright black  | `#555e7a` |
| 9     | Bright red    | `#e16c58` |
| 10    | Bright green  | `#38c9a7` |
| 11    | Bright yellow | `#e6cc6f` |
| 12    | Bright blue   | `#087fab` |
| 13    | Bright magenta| `#ffd2f8` |
| 14    | Bright cyan   | `#6ab4c2` |
| 15    | Bright white  | `#e4f5f4` |

---

## Rosé Pine Dawn

The light theme is stock [Rosé Pine Dawn](https://rosepinetheme.com/en/palette/). Prefer an upstream port from [rosepinetheme.com/en/themes](https://rosepinetheme.com/en/themes/) when adding a tool. Ghostty uses its built-in `Rose Pine Dawn` theme; bat and btop use upstream `rose-pine-dawn` files; Neovim uses rose-pine's `dawn` variant. Hand-written light sections (tmux, zsh, starship, glow, classic vim) use only palette colors.

### Palette

| Name           | Hex       |
|----------------|-----------|
| Base           | `#faf4ed` |
| Surface        | `#fffaf3` |
| Overlay        | `#f2e9e1` |
| Muted          | `#9893a5` |
| Subtle         | `#797593` |
| Text           | `#575279` |
| Love           | `#b4637a` |
| Gold           | `#ea9d34` |
| Rose           | `#d7827e` |
| Pine           | `#286983` |
| Foam           | `#56949f` |
| Iris           | `#907aa9` |
| Highlight low  | `#f4ede8` |
| Highlight med  | `#dfdad9` |
| Highlight high | `#cecacd` |

### How the hand-written configs use it

| Role                                   | Color |
|----------------------------------------|-------|
| Command / branch / active tmux window  | Pine  |
| Path / dir / tmux date segment         | Foam  |
| Separator / terraform / tmux copy mode | Iris  |
| Error / git del / tmux offline         | Love  |
| Strings / aws / tmux prefix            | Gold  |
| Globbing                               | Rose  |
| Comments / autosuggest                 | Muted |

### ANSI Palette (Ghostty built-in)

| Index | Label         | Hex       |
|-------|---------------|-----------|
| 0     | Black         | `#f2e9e1` |
| 1     | Red           | `#b4637a` |
| 2     | Green         | `#286983` |
| 3     | Yellow        | `#ea9d34` |
| 4     | Blue          | `#56949f` |
| 5     | Magenta       | `#907aa9` |
| 6     | Cyan          | `#d7827e` |
| 7     | White         | `#575279` |
| 8     | Bright black  | `#9893a5` |
| 9     | Bright red    | `#b4637a` |
| 10    | Bright green  | `#286983` |
| 11    | Bright yellow | `#ea9d34` |
| 12    | Bright blue   | `#56949f` |
| 13    | Bright magenta| `#907aa9` |
| 14    | Bright cyan   | `#d7827e` |
| 15    | Bright white  | `#575279` |

### Retired Ghostty tweaks

Before the switch to Ghostty's built-in theme, the local `AlpineDawn` Ghostty theme differed from stock in four places. To bring any back, restore a local light theme (`git show 12db173:config/ghostty/themes/AlpineDawn`) and point `theme = ...,light:` at it. Don't set `palette =` in `config/ghostty/config`; the main config applies to both the dark and light themes.

| Setting                | Stock (now)      | Old local value  |
|------------------------|------------------|------------------|
| `palette = 4` (blue)   | `#56949f` foam   | `#286983` pine   |
| `palette = 6` (cyan)   | `#d7827e` rose   | `#56949f` foam   |
| `palette = 14` (bright cyan) | `#d7827e` rose | `#56949f` foam |
| `selection-background` | `#dfdad9` highlight med | `#f2e9e1` overlay |
