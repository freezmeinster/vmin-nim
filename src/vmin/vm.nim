import std/strutils
import parsetoml
import os
import setupbase
import std/strformat
import std/osproc

type
  VM* = ref object
    hostintf*, name*, memory*, disk*: string
    mac*, ip*, cpu*, vnc*, pid*, path*: string

proc kill(pid: int, sig: int): int {.importc.}

proc status*(self: VM): string =
  let pid = self.pid
  if pid == "":
    return "Dead"
  var st: int
  st = kill(parseInt(self.pid), 0)
  if st == 0:
    let opt = execProcess(fmt"ps ax | grep {pid} | grep -v grep")
    if "-boot d" in opt:
      return "Installing"
    return "Running"
  else:
    return "Dead"

proc parse*(self: VM) =
  let pt = self.path.split("/")
  let name = pt[pt.high]
  let conffile = self.path & "/config.toml"
  try:
    let tb =  parsetoml.parseFile(conffile)
    let pidfile = self.path & "/pid"
    if fileExists(pidfile):
      let pid = strip(readFile(pidfile))
      self.pid = pid
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

proc getPIDFromName*(name: string): string =
  let opt = execProcess(fmt"ps ax | grep qemu | grep -v grep | grep 'name {name}'")
  let spt = opt.split(" ")
  return spt[0]

proc stopVM*(self: VM) =
  discard kill(parseInt(self.pid), 1)

proc startVM*(self: VM, iso: string = "") =
  let cpu = $(self.cpu)
  let memory = $(self.memory)
  let vnc = $(self.vnc)
  let diskpath = self.path & "/disk1.qcow2"
  let hostintf = self.hostintf
  let mac = self.mac
  let name = self.name
  
  var runCmd: string

  if iso != "":
     runCmd = runCmd &
        fmt"-boot d"
  else:
    runCmd = runCmd & "-boot c"

  runCmd = runCmd & fmt" -name {name} -accel nvmm -cpu max -smp cpus={cpu} -m {memory}G " &
        fmt"-drive file={diskpath},if=none,id=hd0 " &
        "-device virtio-blk-pci,drive=hd0 " &
        "-object rng-random,filename=/dev/urandom,id=viornd0 " &
        "-device virtio-rng-pci,rng=viornd0 " &
        fmt"-vnc :{vnc} -daemonize "&
        fmt"-netdev tap,id=mynet0,ifname={hostintf},script=no " &
        fmt"-device virtio-net-pci,netdev=mynet0,mac={mac}"

  if iso != "":
     runCmd = runCmd &
        fmt" -cdrom {iso}"

  let args = runCmd.split(" ")
  let netifCmd = fmt"""ifconfig {hostintf} create descr "vmin -> {name}""""
  let netifUpCmd = fmt"""ifconfig {hostintf} up"""
  # let stopnetifCmd = fmt"""ifconfig {hostintf} destroy """
  let brCmd = fmt"""brconfig bridge0 add {hostintf}"""
  discard execProcess(fmt"/dev/MAKEDEV {hostintf}", workingDir="/dev/" )

  discard execProcess(netifCmd)
  discard execProcess(brCmd)
  discard startProcess(getConfig("qemu_bin"), args=args)
  #let ps =  startProcess(getConfig("qemu_bin"), args=args)
  #echo ps.readLines
  sleep(1000)
  let pid = getPIDFromName(name)
  self.pid = pid
  self.persistConfig()
  discard execProcess(netifUpCmd)
