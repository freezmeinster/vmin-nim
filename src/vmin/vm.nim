import std/strutils
import parsetoml
import os
import std/osproc
import setupbase
import std/strformat

type
  VM* = ref object
    hostintf*, name*, memory*, disk*: string
    mac*, ip*, cpu*, vnc*, pid*, path*: string

proc kill(pid: int, sig: int): int {.importc.}

proc status*(self: VM): string =
  var st: int
  st = kill(parseInt(self.pid), 0)
  return $(st)

proc parse*(self: VM) =
  let pt = self.path.split("/")
  let name = pt[pt.high]
  let conffile = self.path & "/config.toml"
  try:
    let tb =  parsetoml.parseFile(conffile)
    let pidfile = self.path & "/pid"
    if fileExists(pidfile):
      self.pid = readFile(pidfile);
    self.name = name
    self.memory = $(tb["memory"])
    self.mac = tb["mac"].getStr()
    self.ip = tb["ip"].getStr()
    self.vnc = $(tb["vnc"])
    self.cpu = $(tb["cpu"])
    self.disk = $(tb["disk"])
    self.hostintf = tb["hostintf"].getStr()
  except CatchableError as e:
    echo e.msg
    quit 1

proc persistConfig*(self: VM) =
  try:
    let tb = newTTable()
    tb.add("cpu", newTInt(parseInt(self.cpu)))
    tb.add("memory", newTInt(parseInt(self.memory)))
    tb.add("disk", newTInt(parseInt(self.disk)))
    tb.add("vnc", newTInt(parseInt(self.vnc)))
    tb.add("ip", newTString(self.ip))
    tb.add("hostintf", newTString(self.hostintf))
    tb.add("mac", newTString(self.mac))
    let res = tb.toTomlString()
    writeFile(self.path & "/config.toml", res)
    if self.pid != "":
      writeFile(self.path&"/pid", self.pid)
  except CatchableError as e:
    echo e.msg
    quit 1

proc addDisk*(self: VM) = 
  let diskpath = self.path & "/disk1.qcow2"
  let disksize = $(self.disk)
  if not fileExists(diskpath):
    discard execProcess("/usr/pkg/bin/qemu-img", 
                       args=["create", "-f", "qcow2", diskpath, disksize&"G"],
                       options={poUsePath,poStdErrToStdOut}
                     )

proc setDHCPConfig*(self: VM) = 
  let ip = self.ip
  let mac= self.mac
  let dnsmasq_dir = getConfig("dnsmasq_confdir")
  let confdir = dnsmasq_dir&"/"&self.name
  let cmd = fmt"""dhcp-host={mac},{ip}"""
  writeFile(confdir, cmd)
  discard execCmd("service dnsmasq restart")
