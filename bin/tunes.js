#!/usr/bin/env osascript -l JavaScript

var music = Application("Music");
if (music.running()) {
  var state = music.playerState();
  if (state === "playing" || state === "paused") {
    var track = music.currentTrack;
    var icon = state === "playing" ? "♫" : "⏸";
    icon + " " + track.artist() + " – " + track.name();
  }
}
