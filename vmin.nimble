# Package

version       = "0.0.1"
author        = "Bramandityo"
description   = "VM manager based on NVMM + Qemu and patient"
license       = "BSD-3-Clause"
srcDir        = "src"
bin           = @["vmin.bin"]


# Dependencies

requires "nim >= 2.0.4"
requires "nancy"
requires "termstyle"
