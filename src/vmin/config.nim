import nancy
import termstyle
import vm
import os
import mac

proc config*(name: string) =
  let vm = VM(path: expandTilde("~/Vmdir/" & name) )
  vm.parse()
  var table: TerminalTable
  table.add yellow "Key", 
            blue "Value"
  table.add "Name", vm.name
  table.add "Path", vm.path
  table.add "CPU", vm.cpu 
  table.add "Memory in GB", vm.memory 
  table.add "Disk in GB", vm.disk 
  table.add "IP", vm.ip
  table.add "MAC", genMac() 
  table.add "Host Interface", vm.hostintf 
  table.add "VNC Address", "127.0.0.1:" & vm.vnc
  table.echoTableSeps()
