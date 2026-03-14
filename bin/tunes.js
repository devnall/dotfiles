#!/usr/bin/env osascript -l JavaScript

var music = Application("Music");
if (music.running()) {
  var state = music.playerState();
  if (state === "playing" || state === "paused") {
    var track = music.currentTrack;
    var icon  = state === "playing" ? "♫" : "⏸";
    var artist = track.artist();
    var name   = track.name();
    var totalMax = state === "playing" ? 40 : 20;

    function trunc(str, len) {
      return str.length > len ? str.substring(0, len - 1) + "…" : str;
    }

    function allocate(aLen, bLen, total) {
      if (aLen <= 20 && bLen <= 20) {
        if (aLen + bLen <= total) {
          return [aLen, bLen];
        } else {
          var a = Math.min(aLen, Math.ceil(total / 2));
          return [a, Math.min(bLen, total - a)];
        }
      } else if (aLen <= 20) {
        return [aLen, Math.min(bLen, total - aLen)];
      } else if (bLen <= 20) {
        return [Math.min(aLen, total - bLen), bLen];
      } else {
        var a = Math.min(20, Math.ceil(total / 2));
        return [a, Math.min(20, total - a)];
      }
    }

    var alloc  = allocate(artist.length, name.length, totalMax);
    var dArtist = trunc(artist, alloc[0]);
    var dName   = trunc(name,   alloc[1]);

    icon + " " + dArtist + " – " + dName;
  }
}
