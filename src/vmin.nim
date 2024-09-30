import os
import vmin/ls

const NimblePkgVersion {.strdefine.} = "Unknown"

const Help = """
vmin - Virtual Machine Manager build with NVMM + Qemu and lot of patient 

Usage:
  ls            => List available Virtual Machine
  setup-net     => Setup NetBSD Bridge and NAT
  setup-base    => Setup Virtual Machine Directory
  setup-dhcp    => Setup dnsmasq service 
  create        => Create new VM
  start         => Starting VM
  stop          => Stoping VM
  restart       => Restarting VM
Options:
  -h, --help     print this help
  -v, --version  version number ("" & NimblePkgVersion & "")

"""

proc main() =
  try:
    case paramCount():
    of 0:
      echo Help
      quit 1
    of 1:
      case paramStr(1)
      of "-h", "--help":
        echo Help
        quit 1
      of "ls":
        ls()
      of "-v", "--version":
        echo NimblePkgVersion
      else:
        echo Help
        quit 1
    else:
      echo Help
      quit 1
  except CatchableError, Defect:
    let ex = getCurrentException()
    echo ex.msg
    echo ex.getStackTrace()
    quit 1

when isMainModule:
  main()
