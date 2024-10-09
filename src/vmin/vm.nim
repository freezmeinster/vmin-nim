import std/strutils
import parsetoml
import os
import std/osproc

type
  VM* = ref object
    hostintf*, name*, memory*, disk*: string
    mac*, ip*, cpu*, vnc*, pid*, path*: string

proc status*(self: VM): string =
  return "Dead"

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
