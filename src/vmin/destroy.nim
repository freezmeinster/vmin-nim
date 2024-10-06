import os
import std/terminal

proc destroy*(name: string) =
  let vmpath = expandTilde("~/Vmdir/" & name)
    
  if not dirExists(vmpath):
    stdout.styledWriteLine(fgRed, "VM " & name & " does not exist")
    quit 1
  write(stdout, "Are you sure want to destroy "&name&" ? [y/N]") 
  var cont = readLine(stdin)
  var ok: array[2, string] = ["y", "Y"]
  if not (cont in ok):
    quit 1

  removeDir(vmpath)

  styledEcho styleBright, fgGreen, "Done", resetStyle
  
