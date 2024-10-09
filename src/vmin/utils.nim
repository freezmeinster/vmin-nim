import os
import std/terminal
import std/algorithm
import strutils
import vm


proc requireRoot*() =
  if not isAdmin():
    styledEcho styleBright, fgRed, "Please run command as root !!", resetStyle
    quit 1

proc scanVmDir*(): seq[VM] =
  var vmlist: seq[VM]
  for kind, obj in walkDir(expandTilde("~/Vmdir")):
    case kind:
      of pcDir:
        var vm1: VM
        vm1 = VM(path:obj)
        vm1.parse()
        vmlist.add(vm1)
      else:
        continue

  return vmlist


proc genVncPort*(): string =
  let vmlist = scanVmDir()
  if vmlist.len == 0:
    return "1"
  var prt: seq[int] 
  for a in vmlist:
    prt.add(parseInt(a.vnc))
  prt.sort()
  let port = prt[prt.low] + 1
  return $(port)

proc genHostInterface*(): string =
  let vmlist = scanVmDir()
  if vmlist.len == 0:
    return "tap4"
  var prt: seq[int] 
  for a in vmlist:
    let bb = a.hostintf.split("tap")
    prt.add(parseInt(bb[bb.high]))
  prt.sort()
  let port = prt[prt.low] + 1
  return "tap" & $(port)
