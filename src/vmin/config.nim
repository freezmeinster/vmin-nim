import vm
import os


proc dialog_yesno(title: cstring, msg: cstring, height: cint, width: cint): cint {.header: "dialog.h".} 

proc config*(name: string) =
  let vm = VM(path: expandTilde("~/Vmdir/" & name) )
  vm.parse()
  let _ = dialog_yesno("asdfas", "asfasdf", 40, 40)
