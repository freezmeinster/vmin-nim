import vm
import setupbase

proc install*(name: string, iso: string) =
  let vm = VM(path: getConfig("vmdir")&"/"&name )
  vm.parse()
  vm.startVM(iso=iso)
  
