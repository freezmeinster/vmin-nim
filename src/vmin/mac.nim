import std/strutils
import random

proc genMac*: string =
  randomize()
  let alfa = ["a", "b", "c", "d", "f"]
  var total: seq[string]
  for _ in 0..2:
    let hrp = sample(alfa)
    let ank = rand(0..8)
    total.add(hrp & $(ank))
  for _ in 0..2:
    let ank1 = rand(0..8)
    let ank2 = rand(0..8)
    total.add($(ank1) & $(ank2))
  return total.join(":")
