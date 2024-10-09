import os
import std/terminal
import std/strformat
import parsetoml

proc checkBase*() =
  if not fileExists(expandTilde("~/.config/vmin.toml")):
    echo "Vmin not yet configured, please run 'vmin setupbase' first !!"
    quit 1

proc setupbase*() = 
  var setuped: bool = false
  let conffile = expandTilde("~/.config/vmin.toml")
  if fileExists(conffile):
    setuped = true

  if setuped:
    write(stdout, "We detect that vmin aleady configured, are you sure to overide it ? [y/N] -> ") 
    var cont = readLine(stdin)
    var ok: array[2, string] = ["y", "Y"]
    if not (cont in ok):
      quit 1

  
  styledEcho styleBright, fgGreen, "Welcome to vmin configuration wizard, please answer folowing question !", resetStyle

  write(stdout, "Where you want to place VM directory (Vmdir) -> ") 
  var vmdir = readLine(stdin)
  write(stdout, "What the name of bridge device -> ") 
  var br = readLine(stdin)
  write(stdout, "What the name of vether device -> ") 
  var vet = readLine(stdin)
  write(stdout, "What the base ip address do you want to use (ie, 2.2.2)-> ") 
  var base = readLine(stdin)

  let conftxt = fmt"""
qemu_bin="/usr/pkg/bin/qemu-system-x86_64"
img_bin="/usr/pkg/bin/qemu-img"
vmdir="{vmdir}"
bridge_interface="{br}"
vether_interface="{vet}"
baseip="{base}"
dnsmasq_confdir="/usr/pkg/etc/dnsmasq.d"
dnasmas_conf="/usr/pkg/etc/dnsmasq.conf"
  """
  writeFile(conffile, conftxt)
  styledEcho styleBright, fgGreen, "Configuring Done", resetStyle

proc getConfig*(key: string): string = 
  let conffile = expandTilde("~/.config/vmin.toml")
  try:
    let tb = parsetoml.parseFile(conffile)
    return tb[key].getStr()
  except CatchableError as e:
    echo e.msg
    quit 1
