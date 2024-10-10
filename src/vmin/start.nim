import vm
import setupbase

proc start*(name: string) =
  let vm = VM(path: getConfig("vmdir")&"/"&name )
  vm.parse()
  vm.startVM()
  
