# Wallpapers

Default wallpapers for automatic dark/light switching.

## How it works

```
macOS appearance change
  → dark-notify → bin/theme-switch
    → desktoppr sets wallpaper from dark.* or light.*
```

`theme-switch` checks for images at `~/.local/share/wallpapers/` (symlinked here by dotbot). It looks for `dark.jpg`, `dark.png`, `light.jpg`, or `light.png` — first match wins.

Default images (`dark.jpg`, `light.jpg`) are committed to this directory and available immediately after `./install`.

## Replacing defaults

Swap `dark.jpg` / `light.jpg` with your preferred images. Both `.jpg` and `.png` are supported — just name them `dark.<ext>` / `light.<ext>`.

## Tier 2: Full wallpaper rotation

For folder-based rotation with multiple wallpapers per mode, clone the wallpapers repo (prompted during `bootstrap.sh`, or run manually):

```sh
bin/wallpaper-setup
```

This clones the full wallpapers repo to `~/Pictures/wallpapers/`, prompts for display type (widescreen/ultrawide), and enables folder-based rotation. When a tier 2 folder exists with images, `theme-switch` uses `desktoppr` folder rotation instead of the single-image default.

### Wallpapers repo

Source: https://github.com/devnall/wallpapers/

Expected folder structure:
```
~/Pictures/wallpapers/
├── widescreen-dark/
├── widescreen-light/
├── ultrawide-dark/
└── ultrawide-light/
```

## Display type

`theme-switch` auto-detects each display's aspect ratio at runtime via `system_profiler`. Mixed setups (e.g. one ultrawide + one widescreen) are handled automatically — each screen gets wallpapers from its matching folder.

A fallback display type at `~/.local/state/display-type` is used only when `system_profiler` is unavailable (defaults to `widescreen`):

```sh
echo "ultrawide" > ~/.local/state/display-type
```

## Manual wallpaper set

```sh
desktoppr ~/.local/share/wallpapers/dark.jpg
```
