import nancy
import termstyle
import vm
import os

proc scanVmDir(): seq[VM] =
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

proc ls*() =
  var table: TerminalTable
  table.add yellow "PID", 
            "Name", 
            "MAC", 
            "IP", 
            blue "VNC", 
            "Memory [GB]", 
            red "vCPU", 
            "Disk [GB]", 
            "Status"
  for a in scanVmDir():
      table.add a.pid , a.name, a.mac, a.ip, a.vnc, a.memory, a.cpu, a.disk, a.status()
  table.echoTableSeps()
