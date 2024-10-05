import os

proc create*() =
  echo "Welcome to Vmin Virtual Machine Creator"
  write(stdout, "Are you sure want to continue ? [y/N] -> ") 
  var cont = readLine(stdin)
  var ok: array[2, string] = ["y", "Y"]
  if not (cont in ok):
    quit 1
  write(stdout, "Virtual Machine Name -> ") 
  var vmname = readLine(stdin)
  write(stdout, "How much Memory in GB ? -> ") 
  var mem = readLine(stdin)
  write(stdout, "How much vCPU is ? -> ") 
  var cpu = readLine(stdin)
  write(stdout, "How much Disk in GB ? -> ") 
  var disk = readLine(stdin)
  write(stdout, "What IP Address do you want to this VM have ? -> ") 
  var ip = readLine(stdin)
  
  let vmpath = expandTilde("~/Vmdir/" & vmname)
  if not existsDir(vmpath):
    createDir(vmpath)
