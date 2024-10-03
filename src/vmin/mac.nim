import std/strutils
import random

proc genMac*: string =
  randomize()
  let alfa = ["a", "b", "c", "d", "f"]
  var total: seq[string]
  for _ in 0..5:
    let hrp = sample(alfa)
    let ank = rand(0..8)
    total.add(hrp & $(ank))
  return total.join(":")
