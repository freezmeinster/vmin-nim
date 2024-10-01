type
  VM* = object
    name*, memory*, disk*, mac*, ip*, cpu*, vnc*, pid*: string

proc status*(self: VM): string =
  return "Dead"
