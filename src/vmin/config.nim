import vm
import os




proc config*(name: string) =
  let vm = VM(path: expandTilde("~/Vmdir/" & name) )
  vm.parse()

