import std/strutils
import parsetoml

type
  VM* = ref object
    name*, memory*, disk*, mac*, ip*, cpu*, vnc*, pid*, path*: string

proc status*(self: VM): string =
  return "Dead"

proc parse*(self: VM) =
  let pt = self.path.split("/")
  let name = pt[pt.high]
  let conffile = self.path & "/config.toml"
  let tb =  parsetoml.parseFile(conffile)
  self.name = name
  self.memory = $(tb["memory"])
  self.mac = tb["mac"].getStr()
  self.ip = tb["ip"].getStr()
  self.vnc = $(tb["vnc"])
  self.cpu = $(tb["cpu"])
  self.disk = $(tb["disk"])
  
