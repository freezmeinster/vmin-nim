import vm
import os
import utils

proc config*(name: string) =
  let vm = VM(path: expandTilde("~/Vmdir/" & name) )
  vm.parse()
  discard genVncPort()


