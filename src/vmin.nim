const Help = """
vmin - Virtual Machine Manager build with NVMM + Qemu and lot of patient 

Usage:
  ls            => List available Virtual Machine
  setup-net     => Setup NetBSD Bridge and NAT
  setup-base    => Setup Virtual Machine Directory
  setup-dhcp    => Setup dnsmasq service 
  create        => Create new VM
  start         => Starting VM
  stop          => Stoping VM
  restart       => Restarting VM
Options:
  -h, --help     print this help
  -v, --version  version number ("" & NimblePkgVersion & "")

"""

proc main() =
  echo Help
  quit 1

when isMainModule:
  main()
