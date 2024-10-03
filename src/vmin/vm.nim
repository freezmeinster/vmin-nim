import std/strutils
import parsetoml

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
  
