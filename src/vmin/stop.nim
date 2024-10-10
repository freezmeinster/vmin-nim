import vm
import setupbase

proc stop*(name: string) =
  let vm = VM(path: getConfig("vmdir")&"/"&name )
  vm.parse()
  vm.stopVM()
  
