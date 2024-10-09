import std/strformat
import setupbase

proc setupdhcp*() = 
  let dnsmasq_conf = "/usr/pkg/etc/dnsmasq.d"
  let baseip = getConfig("baseip")
  let adds = fmt"{baseip}" & ".1"
  let rng = fmt"{baseip}.2,{baseip}.200"
  let dns = fmt"""
    interface=bridge0
    listen-address={adds}
    dhcp-range={rng},255.255.255.0,12h
    conf-dir={dnsmasq_conf}
    dhcp-option=3,{adds}
  """
  echo dns
