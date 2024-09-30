import nancy
import termstyle

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
   for a in [1,2,3]:
      table.add "10", "VM ", "asf", "asf", "Not use", "2", "1", "20", "Running"
   table.echoTableSeps()
