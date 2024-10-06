import os
import vmin/ls
import vmin/utils
import vmin/detail
import vmin/config
import vmin/create
import vmin/destroy
import vmin/install

#{.passL: "-liconv".}

const NimblePkgVersion {.strdefine.} = "Unknown"

const Help = """
vmin - Virtual Machine Manager build with NVMM + Qemu and lot of patient 

Usage:
  ls                => List available Virtual Machine
  detail [vname]    => Detail Virtual Machine
  config [vname]    => Configure Virtual Machine
  setup-net         => Setup NetBSD Bridge and NAT
  setup-base        => Setup Virtual Machine Directory
  setup-dhcp        => Setup dnsmasq service 
  create            => Create new VM
  start [vmname]    => Starting VM
  stop [vmname]     => Stoping VM
  restart [vname]   => Restarting VM
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
      of "create":
        create()
      of "-v", "--version":
        echo NimblePkgVersion
      else:
        echo Help
        quit 1
    of 2:
      case paramStr(1)
      of "destroy":
        let vmname = paramStr(2)
        destroy(vmname)
      of "config":
        let vmname = paramStr(2)
        config(vmname)
      of "status":
        let vmname = paramStr(2)
        detail(vmname)
      of "start":
        requireRoot()
        let vmname = paramStr(2)
        detail(vmname)
      of "stop":
        requireRoot()
        let vmname = paramStr(2)
        detail(vmname)
      of "restart":
        requireRoot()
        let vmname = paramStr(2)
        detail(vmname)
    of 3:
      case paramStr(1)
      of "install":
        requireRoot()
        let vmname = paramStr(2)
        let iso = paramStr(3)
        install(vmname, iso)
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
