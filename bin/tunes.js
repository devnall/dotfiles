#!/usr/bin/env osascript -l JavaScript

var mode = $.NSProcessInfo.processInfo.arguments.count > 4
  ? ObjC.unwrap($.NSProcessInfo.processInfo.arguments.objectAtIndex(4))
  : "dark";

ObjC.import("Foundation");

var GLYPH = "\uE0B2";

var THEMES = {
  dark: {
    barBg:       "#0f111a",
    playPillBg:  "#1a6070",
    playPillFg:  "#e4f5f4",
    pausePillBg: "#343b51",
    pausePillFg: "#c6e0df",
  },
  light: {
    barBg:       "#f2e9e1",
    playPillBg:  "#307f9e",
    playPillFg:  "#faf4ed",
    pausePillBg: "#dfdad9",
    pausePillFg: "#9893a5",
  }
};

var t = THEMES[mode] || THEMES.dark;

function pill(bg, fg, content) {
  var entry = "#[fg=" + bg     + ",bg=" + t.barBg + ",nobold,noitalics,nounderscore]" + GLYPH;
  var text  = "#[fg=" + fg     + ",bg=" + bg      + "]" + content;
  var exit  = "#[fg=" + t.barBg + ",bg=" + bg     + ",nobold,noitalics,nounderscore]" + GLYPH;
  var reset = "#[fg=" + bg     + ",bg=" + t.barBg + "]";
  return entry + text + exit + reset + " ";
}

var music = Application("Music");
if (music.running()) {
  var state = music.playerState();
  if (state === "playing" || state === "paused") {
    var track  = music.currentTrack;
    var icon   = state === "playing" ? "♫" : "⏸";
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

    var alloc   = allocate(artist.length, name.length, totalMax);
    var dArtist = trunc(artist, alloc[0]);
    var dName   = trunc(name,   alloc[1]);
    var content = " " + icon + " " + dArtist + " – " + dName + " ";

    var bg = state === "playing" ? t.playPillBg : t.pausePillBg;
    var fg = state === "playing" ? t.playPillFg : t.pausePillFg;
    pill(bg, fg, content);
  }
}
