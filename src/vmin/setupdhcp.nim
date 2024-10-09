import std/strformat
import std/terminal
import setupbase
import os
import std/osproc
import std/times
import utils


proc setupdhcp*() =
  requireRoot()
  let curtime = getTime().format("yyyy-MM-dd-HH-mm-ss")
  let dnsmasq_conf = getConfig("dnsmasq_conf")
  let dnsmasq_confdir = getConfig("dnsmasq_confdir")
  let br = getConfig("bridge_interface")
  let baseip = getConfig("baseip")
  let adds = fmt"{baseip}" & ".1"
  let rng = fmt"{baseip}.2,{baseip}.200"
  let dns = fmt"""
    interface={br}
    listen-address={adds}
    dhcp-range={rng},255.255.255.0,12h
    conf-dir={dnsmasq_confdir}
    dhcp-option=3,{adds}
  """
  if not dirExists(dnsmasq_confdir):
    createDir(dnsmasq_confdir)

  if fileExists(dnsmasq_conf):
    moveFile(dnsmasq_conf, dnsmasq_conf&"-"&curtime)
    removeFile(dnsmasq_conf)

  writeFile(dnsmasq_conf, dns)

  discard execCmd("service dnsmasq restart")

  styledEcho styleBright, fgGreen, "Configuring Done", resetStyle


