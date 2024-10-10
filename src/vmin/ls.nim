import nancy
import strutils
# import termstyle
import utils
import vm

proc ls*() =
  var table: TerminalTable
  table.add "Name", 
            "MAC", 
            "IP", 
            "VNC", 
            "Memory [GB]", 
            "vCPU", 
            "Disk [GB]", 
            "Status"
  for a in scanVmDir():
    let vncport = parseInt(a.vnc) + 5900
    let vncaddr = "127.0.0.1:" & $(vncport)
    table.add  a.name, a.mac, a.ip, vncaddr, a.memory, a.cpu, a.disk, a.status()
  table.echoTableSeps()
