#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM5D v0.5 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2022 Pozsar Zsolt <pozsarzs@gmail.com>                  |
# | mm5d.py                                                                    |
# | Main program                                                               |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit
#   1: main configuration file is missing
#   2: environment characteristic configuration file is missing
#   3: cannot create locking file

import configparser
import daemon
import io
import json
import os
import requests
import sys
import time
import Adafruit_DHT
import RPi.GPIO as GPIO
from time import localtime, strftime

global file_pipe
file_pipe="/var/tmp/matrixdisplayfifo"

# initializing ports
def initports():
  writetodebuglog("i","Initializing GPIO ports.")
  writecodetodisplay("D","03")
  GPIO.setwarnings(True)
  GPIO.setmode(GPIO.BCM)
  GPIO.setup(prt_in1,GPIO.IN)
  GPIO.setup(prt_in2,GPIO.IN)
  GPIO.setup(prt_in3,GPIO.IN)
  GPIO.setup(prt_in4,GPIO.IN)
  GPIO.setup(prt_switch,GPIO.IN)
  GPIO.setup(prt_speaker,GPIO.OUT)
  GPIO.setup(prt_act,GPIO.OUT,initial=0)
  GPIO.setup(prt_err1,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_err2,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_err3,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_err4,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_out1,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_out2,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_out3,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_out4,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_twrred,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_twryellow,GPIO.OUT,initial=GPIO.HIGH)
  GPIO.setup(prt_twrgreen,GPIO.OUT,initial=GPIO.HIGH)

# write text to display
def writetexttodisplay(s):
  try:
    with open(file_pipe, "w") as fifo:
      fifo.write(s+'\n')
      fifo.close()
  except:
    print ("")

# write warning/debug code to display
def writecodetodisplay(c,n):
  if (c=="D" and dbg_log=="1") or c=="W" or  c=="E":
    try:
      with open(file_pipe, "w") as fifo:
        fifo.write(c+' #'+n+'\n')
        fifo.close()
        sleep(0.5)
    except:
      print ("")

# write a line to debug logfile
def writetodebuglog(level,text):
  if dbg_log=="1":
    if level=="i":
      lv="INFO   "
    if level=="w":
      lv="WARNING"
    if level=="e":
      lv="ERROR  "
    debugfile=dir_log+time.strftime("debug-%Y%m%d.log")
    dt=(strftime("%Y-%m-%d %H:%M:%S", localtime()))
    try:
      with open(debugfile, "a") as d:
        d.write(dt+'  '+lv+' '+text+'\n')
        d.close()
    except:
      print ("")

# load configuration
def loadconfiguration(conffile):
  global api_key
  global base_url
  global city_name
  global dbg_log
  global dir_log
  global dir_var
  global lockfile
  global logfile
  global prt_act
  global prt_err1
  global prt_err2
  global prt_err3
  global prt_err4
  global prt_in1
  global prt_in2
  global prt_in3
  global prt_in4
  global prt_out1
  global prt_out2
  global prt_out3
  global prt_out4
  global prt_sensor
  global prt_speaker
  global prt_switch
  global prt_twrgreen
  global prt_twrred
  global prt_twryellow
  global sensor
  global builtin_thermostat
  try:
    with open(conffile) as f:
      mm5d_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mm5d_config))
    dbg_log='0'
    dbg_log=config.get('log','dbg_log')
    dir_log=config.get('directories','dir_log')
    dir_var=config.get('directories','dir_var')
    logfile=dir_log+'mm5d.log'
    lockfile=config.get('directories','dir_lck')+'mm5d.lck'
    prt_act=int(config.get('ports','prt_act'))
    prt_err1=int(config.get('ports','prt_err1'))
    prt_err2=int(config.get('ports','prt_err2'))
    prt_err3=int(config.get('ports','prt_err3'))
    prt_err4=int(config.get('ports','prt_err4'))
    prt_in1=int(config.get('ports','prt_in1'))
    prt_in2=int(config.get('ports','prt_in2'))
    prt_in3=int(config.get('ports','prt_in3'))
    prt_in4=int(config.get('ports','prt_in4'))
    prt_out1=int(config.get('ports','prt_out1'))
    prt_out2=int(config.get('ports','prt_out2'))
    prt_out3=int(config.get('ports','prt_out3'))
    prt_out4=int(config.get('ports','prt_out4'))
    prt_sensor=int(config.get('ports','prt_sensor'))
    prt_speaker=int(config.get('ports','prt_speaker'))
    prt_switch=int(config.get('ports','prt_switch'))
    prt_twrgreen=int(config.get('ports','prt_twrgreen'))
    prt_twrred=int(config.get('ports','prt_twrred'))
    prt_twryellow=int(config.get('ports','prt_twryellow'))
    api_key=config.get('openweathermap.org','api_key')
    base_url=config.get('openweathermap.org','base_url')
    city_name=config.get('openweathermap.org','city_name')
    sensor_type=config.get('sensors','sensor_type')
    if sensor_type=='AM2302':
      sensor=Adafruit_DHT.AM2302
    if sensor_type=='DHT11':
      sensor=Adafruit_DHT.DHT11
    if sensor_type=='DHT22':
      sensor=Adafruit_DHT.DHT22
    builtin_thermostat=0
    builtin_thermostat=int(config.get('sensors','builtin_thermostat'))
    writetodebuglog("i","Configuration is loaded.")
    writecodetodisplay("D","00")
  except:
    writetodebuglog("e","Cannot open "+conffile+"!")
    writecodetodisplay("E","01")
    exit(1)

# add a zero char
def addzero(num):
  if num<10:
    z="0"
  else:
    z=""
  s=z+str(num)
  return s

# load environment characteristics
def loadenvirchars(conffile):
  global hheater_disable
  global hheater_off
  global hheater_on
  global hhumidifier_disable
  global hhumidifier_off
  global hhumidifier_on
  global hhumidity_max
  global hhumidity_min
  global hlight_off1
  global hlight_off2
  global hlight_on1
  global hlight_on2
  global htemperature_max
  global htemperature_min
  global hvent_disable
  global hvent_disablehightemp
  global hvent_disablelowtemp
  global hvent_hightemp
  global hvent_lowtemp
  global hvent_off
  global hvent_on
  global mheater_disable
  global mheater_off
  global mheater_on
  global mhumidifier_disable
  global mhumidifier_off
  global mhumidifier_on
  global mhumidity_max
  global mhumidity_min
  global mlight_off1
  global mlight_off2
  global mlight_on1
  global mlight_on2
  global mtemperature_max
  global mtemperature_min
  global mvent_disable
  global mvent_disablehightemp
  global mvent_disablelowtemp
  global mvent_hightemp
  global mvent_lowtemp
  global mvent_off
  global mvent_on
  H="hyphae"
  M="mushroom"
  hheater_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  hhumidifier_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  hvent_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  hvent_disablehightemp=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  hvent_disablelowtemp=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  mheater_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  mhumidifier_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  mvent_disable=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  mvent_disablehightemp=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  mvent_disablelowtemp=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,]
  try:
    with open(conffile) as f:
      envir_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(envir_config))
    for x in range(24):
      hhumidifier_disable[x]=int(config.get(H,'humidifier_disable_'+addzero(x)))
    for x in range(24):
      hheater_disable[x]=int(config.get(H,'heater_disable_'+addzero(x)))
    for x in range(24):
      hvent_disable[x]=int(config.get(H,'vent_disable_'+addzero(x)))
    for x in range(24):
      hvent_disablehightemp[x]=int(config.get(H,'vent_disablehightemp_'+addzero(x)))
    for x in range(24):
      hvent_disablelowtemp[x]=int(config.get(H,'vent_disablelowtemp_'+addzero(x)))
    hheater_off=int(config.get(H,'heater_off'))
    hheater_on=int(config.get(H,'heater_on'))
    hhumidifier_off=int(config.get(H,'humidifier_off'))
    hhumidifier_on=int(config.get(H,'humidifier_on'))
    hhumidity_max=int(config.get(H,'humidity_max'))
    hhumidity_min=int(config.get(H,'humidity_min'))
    hlight_off1=int(config.get(H,'light_off1'))
    hlight_off2=int(config.get(H,'light_off2'))
    hlight_on1=int(config.get(H,'light_on1'))
    hlight_on2=int(config.get(H,'light_on2'))
    htemperature_max=int(config.get(H,'temperature_max'))
    htemperature_min=int(config.get(H,'temperature_min'))
    hvent_hightemp=int(config.get(H,'vent_hightemp'))
    hvent_lowtemp=int(config.get(H,'vent_lowtemp'))
    hvent_off=int(config.get(H,'vent_off'))
    hvent_on=int(config.get(H,'vent_on'))
    for x in range(24):
      mhumidifier_disable[x]=int(config.get(M,'humidifier_disable_'+addzero(x)))
    for x in range(24):
      mheater_disable[x]=int(config.get(M,'heater_disable_'+addzero(x)))
    for x in range(24):
      mvent_disable[x]=int(config.get(M,'vent_disable_'+addzero(x)))
    for x in range(24):
      mvent_disablehightemp[x]=int(config.get(M,'vent_disablehightemp_'+addzero(x)))
    for x in range(24):
      mvent_disablelowtemp[x]=int(config.get(M,'vent_disablelowtemp_'+addzero(x)))
    mheater_off=int(config.get(M,'heater_off'))
    mheater_on=int(config.get(M,'heater_on'))
    mhumidifier_off=int(config.get(M,'humidifier_off'))
    mhumidifier_on=int(config.get(M,'humidifier_on'))
    mhumidity_max=int(config.get(M,'humidity_max'))
    mhumidity_min=int(config.get(M,'humidity_min'))
    mlight_off1=int(config.get(M,'light_off1'))
    mlight_off2=int(config.get(M,'light_off2'))
    mlight_on1=int(config.get(M,'light_on1'))
    mlight_on2=int(config.get(M,'light_on2'))
    mtemperature_max=int(config.get(M,'temperature_max'))
    mtemperature_min=int(config.get(M,'temperature_min'))
    mvent_hightemp=int(config.get(M,'vent_hightemp'))
    mvent_lowtemp=int(config.get(M,'vent_lowtemp'))
    mvent_off=int(config.get(M,'vent_off'))
    mvent_on=int(config.get(M,'vent_on'))
    writetodebuglog("i","Environment characteristics is loaded.")
    writecodetodisplay("D","01")
  except:
    writetodebuglog("e","Cannot open "+conffile+"!")
    writecodetodisplay("E","02")
    exit(2)

# create and remove lock file
def lckfile(mode):
  try:
    if mode>0:
      lcf=open(lockfile,'w')
      lcf.close()
      writetodebuglog("i","Creating lockfile.")
      writecodetodisplay("D","12")
    else:
      writetodebuglog("i","Removing lockfile.")
      writecodetodisplay("D","14")
      os.remove(lockfile)
  except:
    writetodebuglog("w","Cannot create/remove"+lockfile+"!")
    writecodetodisplay("W","03")

# write data to log with timestamp
def writelog(temperature,humidity,inputs,outputs):
  dt=(strftime("%Y-%m-%d,%H:%M",localtime()))
  lckfile(1)
  writetodebuglog("i","Writing data to log.")
  writecodetodisplay("D","13")
  if not os.path.isfile(logfile):
    f=open(logfile,'w')
    f.close()
  try:
    with open(logfile,"r+") as f:
      first_line=f.readline()
      lines=f.readlines()
      f.seek(0)
      f.write(dt+','+str(temperature)+','+str(humidity)+','+inputs[4]+','+
              inputs[0]+','+inputs[1]+','+inputs[2]+','+inputs[3]+','+
              outputs[0]+','+outputs[1]+','+outputs[2]+','+outputs[3]+','+
              outputs[4]+','+outputs[5]+','+outputs[6]+','+outputs[7]+','+
              outputs[8]+','+outputs[9]+','+outputs[10]+'\n')
      f.write(first_line)
      f.writelines(lines)
      f.close()
  except:
    writetodebuglog("e","Cannot write "+logfile+"!")
    writecodetodisplay("E","04")
    lckfile(0)
    exit(3)
  lckfile(0)

# check external control files
def extcont(channel,status):
  writecodetodisplay("D","04")
  writetodebuglog("i","Checking override file: "+dir_var+"out"+str(channel)+".")
  if os.path.isfile(dir_var+"out"+str(channel)):
    try:
      f=open(dir_var+"out"+str(channel),'r')
      v=f.read()
      f.close()
      if v == "neutral": s=status
      if v == "off": s="0"
      if v == "on": s="1"
    except:
      s=status
  else:
    s=status
  return s

# blink ACT LED
def blinkactled():
  GPIO.output(prt_act,1)
  time.sleep(0.5)
  GPIO.output(prt_act,0)
  time.sleep(0.5)

# auto off OUT #4
def autooffport4():
  # aop4:  auto off port after switch on (in s)
  aop4="5"
  return aop4

# get external temperature from openweathermap.org
def getexttemp():
  writetodebuglog("i","Get external temperature from internet.")
  writecodetodisplay("D","05")
  try:
    response=requests.get(base_url+"appid="+api_key+"&q="+city_name)
    x=response.json()
    if x["cod"]!="404":
      y=x["main"] 
      current_temperature=y["temp"]
      current_temperature=round(current_temperature-273)
      writetodebuglog("i","External temperature: "+str(current_temperature)+" degree Celsius")
      return current_temperature
    else:
      writetodebuglog("w","Cannot get external temperature from internet.")
      writecodetodisplay("W","01")
      return 18
  except:
    writetodebuglog("w","Cannot get external temperature from internet.")
    writecodetodisplay("W","01")
    return 18

# control output ports and error lights
def control(temperature,humidity,inputs,exttemp,wrongvalues):
  in1=int(inputs[0])
  in2=int(inputs[1])
  in3=int(inputs[2])
  in4=int(inputs[3])
  swi=int(inputs[4])
  h=int(time.strftime("%H"))
  m=int(time.strftime("%M"))
  # -----------------------------------------------------------------------------
  # See control.txt for useable variables!
  # switch on/off outputs:
  if swi==1: # growing hyphae
    # heaters
    out1=0
    if builtin_thermostat==0:
      if (wrongvalues==0) and (temperature<hheater_on):
        out1=1
      if (wrongvalues==0) and (temperature>hheater_off):
        out1=0
    else:
      out1=1
    if hheater_disable[h]==1:
      out1=0
    # lights
    out2=0
    if (h>=hlight_on1) and (h<hlight_off1):
      out2=1
    if (h>=hlight_on2) and (h<hlight_off2):
      out2=1
    # ventilators
    out3=0
    if (m>hvent_on) and (m<hvent_off):
      out3=1
    if hvent_disable[h]==1:
      out3=0
    if (wrongvalues==0) and (humidity>hhumidity_max) and (exttemp<htemperature_max):
      out3=1
    if (wrongvalues==0) and (temperature>htemperature_max) and (exttemp<htemperature_max):
      out3=1
    if (hvent_disablelowtemp[h]==1) and (exttemp<hvent_lowtemp):
      out3=0
    if (hvent_disablehightemp[h]==1) and (exttemp>hvent_hightemp):
      out3=0
    # humidifier
    out4=0
    if (wrongvalues==0) and (humidity<hhumidifier_on):
      out4=1
    if (wrongvalues==0) and (humidity>hhumidifier_off):
      out4=0
    if hhumidifier_disable[h]==1:
      out4=0
  else: # growing mushroom
    # heaters
    out1=0
    if builtin_thermostat==0:
      if (wrongvalues==0) and (temperature<mheater_on):
        out1=1
      if (wrongvalues==0) and (temperature>mheater_off):
        out1=0
    else:
      out1=1
    if mheater_disable[h]==1:
      out1=0
    # lights
    out2=0
    if (h>=mlight_on1) and (h<mlight_off1):
      out2=1
    if (h>=mlight_on2) and (h<mlight_off2):
      out2=1
    # ventilators
    out3=0
    if (m>mvent_on) and (m<mvent_off):
      out3=1
    if mvent_disable[h]==1:
      out3=0
    if (wrongvalues==0) and (humidity>mhumidity_max) and (exttemp<mtemperature_max):
      out3=1
    if (wrongvalues==0) and (temperature>mtemperature_max) and (exttemp<mtemperature_max):
      out3=1
    if (mvent_disablehightemp[h]==1) and (exttemp>mvent_hightemp):
      out3=0
    if (mvent_disablelowtemp[h]==1) and (exttemp<mvent_lowtemp):
      out3=0
    # humidifier
    out4=0
    if (wrongvalues==0) and (humidity<mhumidifier_on):
      out4=1
    if (wrongvalues==0) and (humidity>mhumidifier_off):
      out4=0
    if mhumidifier_disable[h]==1:
      out4=0
  # -----------------------------------------------------------------------------
  # switch on/off error lights:
  if swi==1: # growing hyphae
    # bad temperature
    err1=0
    if (wrongvalues==0) and (temperature<htemperature_min):
      err1=1
    if (wrongvalues==0) and (temperature>htemperature_max):
      err1=1
    if err1==1:
      writecodetodisplay("E","51")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # overcurrent protection
    err2=0 if in2==1 else 1
    if err2==1:
      writecodetodisplay("E","52")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # bad water pressure error light
    err3=0 if in3==1 else 1
    if err3==1:
      writecodetodisplay("E","53")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # bad relative humidity
    err4=0
    if (wrongvalues==0) and (humidity<hhumidity_min):
      err4=1
    if (wrongvalues==0) and (humidity>hhumidity_max):
      err4=1
    if err4==1:
      writecodetodisplay("E","54")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
  else: # growing mushroom
    # bad temperature
    err1=0
    if (wrongvalues==0) and (temperature<mtemperature_min):
      err1=1
    if (wrongvalues==0) and (temperature>mtemperature_max):
      err1=1
    if err1==1:
      writecodetodisplay("E","51")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # MM4A overcurrent proctection
    err2=0 if in2==1 else 1
    if err2==1:
      writecodetodisplay("E","52")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # bad water pressure error light
    err3=0 if in3==1 else 1
    if err3==1:
      writecodetodisplay("E","53")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
    # bad relative humidity
    err4=0
    if (wrongvalues==0) and (humidity<mhumidity_min):
      err4=1
    if (wrongvalues==0) and (humidity>mhumidity_max):
      err4=1
    if err4==1:
      writecodetodisplay("E","54")
      time.sleep(1)
      writetexttodisplay(stemp+' '+shum)
  # -----------------------------------------------------------------------------
  # In this case, we use twrg output to restart (off and on again) T/RH sensor.
  # The green light is switch by NC contacts of the twry and twrr relays.
  # switch on/off tower signal lights:
  twrg=0 # 0: on
  twry=0 # 1: on
  twrr=0 # 1: on
  # - yellow -
  # MM4A manual control
  if in1==1:
    twry=1
    writecodetodisplay("W","51")
    time.sleep(1)
    writetexttodisplay(stemp+' '+shum)
  # opened door/window
  if in4==0:
    twry=1
    writecodetodisplay("W","52")
    time.sleep(1)
    writetexttodisplay(stemp+' '+shum)
  # switch of green lights
  if twry==1:
    twrg=1
  # - red -
  # MM4A overcurrent proctection
  if in2==0:
    twrr=1
  # bad water pressure error light
  if in3==0:
    twrr=1
  # bad sensor
  if wrongvalues==1:
    twrr=1
  # switch of other lights
  if twrr==1:
    twrg=1
    twry=0
  # -----------------------------------------------------------------------------
  outputs=str(out1)+str(out2)+str(out3)+str(out4)+ \
          str(err1)+str(err2)+str(err3)+str(err4)+ \
          str(twrg)+str(twry)+str(twrr)
  return outputs

# main program
global operationmode
writetexttodisplay("MM5D")
time.sleep(1)
writetexttodisplay("init...")
time.sleep(0.5)
#loadconfiguration("/etc/mm5d/mm5d.ini")
#loadenvirchars('/etc/mm5d/envir.ini')
loadconfiguration("/usr/local/etc/mm5d/mm5d.ini")
loadenvirchars('/usr/local/etc/mm5d/envir.ini')
initports()
first=1
exttemp=18
prevtemperature=0
prevhumidity=0
previnputs=""
prevoutputs=""
writetodebuglog("i","Starting program as daemon.")
writecodetodisplay("D","02")
with daemon.DaemonContext() as context:
  try:
    writetexttodisplay("ready")
    time.sleep(1)
    while True:
      # read input data from sensor
      writetodebuglog("i","Measuring T/RH.")
      humidity,temperature=Adafruit_DHT.read_retry(sensor,prt_sensor)
      if humidity is not None and temperature is not None:
        wrongvalues=0
      else:
        wrongvalues=1
        temperature=18
        humidity=72
        # reset sensor with unused green signal light output
        GPIO.output(prt_twrgreen,0)
        time.sleep(1)
        GPIO.output(prt_twrgreen,1)
      temperature=round(temperature)
      humidity=round(humidity)
      stemp=str(temperature)
      shum=str(humidity)
      writetodebuglog("i","Measure is done.")
      writecodetodisplay("D","07")
      writetexttodisplay(stemp+' '+shum)
      blinkactled()
      if humidity>100:
        wrongvalues=1
        writetodebuglog("w","Measured values are bad!")
        writecodetodisplay("W","02")
      # read input data from GPIO
      writetodebuglog("i","Reading input ports.")
      writecodetodisplay("D","08")
      inputs=str(int(not GPIO.input(prt_in1)))
      inputs=inputs+str(int(not GPIO.input(prt_in2)))
      inputs=inputs+str(int(not GPIO.input(prt_in3)))
      inputs=inputs+str(int(not GPIO.input(prt_in4)))
      inputs=inputs+str(int(not GPIO.input(prt_switch)))
      blinkactled()
      # check values and set outputs
      writetodebuglog("i","Check values and set outputs.")
      writecodetodisplay("D","09")
      if (int(time.strftime("%M"))==5):
        exttemp=getexttemp()
      outputs=control(temperature,humidity,inputs,exttemp,wrongvalues)
      aop4=autooffport4()
      blinkactled()
      # override state of outputs
      ss=""
      writetodebuglog("i","Original value of outputs: "+outputs)
      for x in range(0, 4):
        ss=ss+extcont(x+1,outputs[x])
      outputs=ss+outputs[4]+outputs[5]+outputs[6]+outputs[7]+outputs[8]+outputs[9]+outputs[10]
      writetodebuglog("i","New value of outputs: "+outputs)
      # write output data to GPIO
      writetodebuglog("i","Writing output ports.")
      writecodetodisplay("D","10")
      GPIO.output(prt_out1,not int(outputs[0]))
      GPIO.output(prt_out2,not int(outputs[1]))
      GPIO.output(prt_out3,not int(outputs[2]))
      GPIO.output(prt_out4,not int(outputs[3]))
      GPIO.output(prt_err1,not int(outputs[4]))
      GPIO.output(prt_err2,not int(outputs[5]))
      GPIO.output(prt_err3,not int(outputs[6]))
      GPIO.output(prt_err4,not int(outputs[7]))
      # next line is commented, because the twrg output is used to reset the T/RH sensor
      # GPIO.output(prt_twrgreen,not int(outputs[8]))
      GPIO.output(prt_twryellow,not int(outputs[9]))
      GPIO.output(prt_twrred,not int(outputs[10]))
      # auto-off 4th port
      if aop4!="0":
        for i in range(int(aop4)):
          blinkactled()
        GPIO.output(prt_out4,1)
        writetodebuglog("i","Auto off enabled at 4th output port.")
        writecodetodisplay("D","11")
      blinkactled()
      # write logfile if changed
      enablewritelog=0
      if prevtemperature!=temperature:
        enablewritelog=1
      if prevhumidity!=humidity:
        enablewritelog=1
      if previnputs!=inputs:
        enablewritelog=1
      if prevoutputs!=outputs:
        enablewritelog=1
      if first==1:
        enablewritelog=1
      if enablewritelog==1:
        first=0
        writelog(temperature,humidity,inputs,outputs)
        prevtemperature=temperature
        prevhumidity=humidity
        previnputs=inputs
        prevoutputs=outputs
      blinkactled()
      # wait 10s
      writetodebuglog("i","Waiting 10 s.")
      writecodetodisplay("D","15")
      time.sleep(10)
  except KeyboardInterrupt:
    GPIO.cleanup
exit(0)
