import os
import std/terminal

proc requireRoot*() =
  if not isAdmin():
    styledEcho styleBright, fgRed, "Please run command as root !!", resetStyle
    quit 1
