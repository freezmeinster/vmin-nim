import os

proc requireRoot*() =
  if not isAdmin():
    echo "Please run command as root"
    quit 1
