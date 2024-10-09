import nancy
import termstyle
import utils
import vm

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
