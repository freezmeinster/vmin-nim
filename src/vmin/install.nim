import std/strformat
import vm
import strutils
import std/osproc
import setupbase
import utils

proc install*(name: string, iso: string) =
  let vm = VM(path: getConfig("vmdir")&"/"&name )
  vm.parse()
  let cpu = $(vm.cpu)
  let memory = $(vm.memory)
  let vnc = $(vm.vnc)
  let diskpath = vm.path & "/disk1.qcow2"
  let hostintf = vm.hostintf
  let mac = vm.mac
  
  let runCmd = fmt"-name {name} -accel nvmm -boot d -cpu max -smp cpus={cpu} -m {memory}G " &
        fmt"-drive file={diskpath},if=none,id=hd0 " &
        "-device virtio-blk-pci,drive=hd0 " &
        "-object rng-random,filename=/dev/urandom,id=viornd0 " &
        "-device virtio-rng-pci,rng=viornd0 " &
        fmt"-vnc :{vnc} -daemonize "&
        fmt"-netdev tap,id=mynet0,ifname={hostintf},script=no " &
        fmt"-device virtio-net-pci,netdev=mynet0,mac={mac} " &
        fmt"-cdrom {iso}"
  let args = runCmd.split(" ")
  let netifCmd = fmt"""ifconfig {hostintf} create descr "vmin -> {name}""""
  let netifUpCmd = fmt"""ifconfig {hostintf} up"""
  # let stopnetifCmd = fmt"""ifconfig {hostintf} destroy """
  let brCmd = fmt"""brconfig bridge0 add {hostintf}"""
  discard execProcess(fmt"/dev/MAKEDEV {hostintf}", workingDir="/dev/" )

  discard execCmd(netifCmd)
  discard execCmd(brCmd)
  let qm = startProcess(getConfig("qemu_bin"), args=args)
  vm.pid = $(qm.processID)
  vm.persistConfig()
  discard execCmd(netifUpCmd)
