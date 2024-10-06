import os 
import std/strformat
import vm
import std/osproc

proc install*(name: string, iso: string) =
  let vm = VM(path: expandTilde("~/Vmdir/" & name) )
  vm.parse()
  let cpu = $(vm.cpu)
  let memory = $(vm.memory)
  let diskpath = vm.path & "/disk1.qcow2"
  let hostintf = vm.hostintf
  let mac = vm.mac
  
  let runCmd = fmt"qemu-system-x86_64 -accel nvmm -cpu max -smp cpus={cpu} -m {memory}G " &
        fmt"-display sdl,gl=on -drive file={diskpath},if=none,id=hd0 " &
        "-device virtio-blk-pci,drive=hd0 " &
        "-object rng-random,filename=/dev/urandom,id=viornd0 " &
        "-device virtio-rng-pci,rng=viornd0 " &
        fmt"-netdev tap,id=mynet0,ifname={hostintf},script=no " &
        fmt"-device virtio-net-pci,netdev=mynet0,mac={mac} " &
        fmt"-cdrom {iso}"
  let netifCmd = fmt"""ifconfig {hostintf} create descr "vmin -> {name}" up """
  let stopnetifCmd = fmt"""ifconfig {hostintf} destroy """
  let brCmd = fmt"""brconfig bridge0 add {hostintf}"""
  echo runCmd
  discard execCmd(stopnetifCmd)
  discard execCmd(netifCmd)
  discard execCmd(brCmd)
  discard execCmd(runCmd)
  discard execCmd(stopnetifCmd)
