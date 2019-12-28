#!/usr/bin/python
# +----------------------------------------------------------------------------+
# | MM5D v0.1 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019 Pozsar Zsolt <pozsar.zsolt@.szerafingomba.hu>           |
# | mm5d-hwtest.py                                                             |
# | Hardware test program                                                      |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit
#   1: configuration file is missing

import ConfigParser
import RPi.GPIO as GPIO
import Adafruit_DHT
import time
import io
import sys

# load configuration
def loadconfiguration(conffile):
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
  global prt_switch
  global prt_twrgreen
  global prt_twrred
  global prt_twryellow
  global sensor
  try:
    with open(conffile) as f:
      sample_config = f.read()
    config = ConfigParser.RawConfigParser(allow_no_value=True)
    config.readfp(io.BytesIO(sample_config))
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
    prt_switch=int(config.get('ports','prt_switch'))
    prt_twrgreen=int(config.get('ports','prt_twrgreen'))
    prt_twrred=int(config.get('ports','prt_twrred'))
    prt_twryellow=int(config.get('ports','prt_twryellow'))
    sensor_type=config.get('sensors','sensor_type')
    if sensor_type=='AM2302':
      sensor=Adafruit_DHT.AM2302
    if sensor_type=='DHT11':
      sensor=Adafruit_DHT.DHT11
    if sensor_type=='DHT22':
      sensor=Adafruit_DHT.DHT22
  except:
    print("ERROR: Cannot open configuration file!");
    exit(1);

# blink ACT LED
def blink_act():
    GPIO.output(prt_act,1)
    time.sleep(0.5)
    GPIO.output(prt_act,0)
    time.sleep(0.5)

#conffile='/etc/mm3d/mm3d.ini'
conffile='/usr/local/etc/mm3d/mm3d.ini'
print "\nMM5D hardware test utility * (C)2019 Pozsar Zsolt"
print "======================================================"
print " * load configuration: %s..." % conffile
loadconfiguration(conffile)
print " * setting ports..."
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(prt_act,GPIO.OUT,initial=0)
GPIO.setup(prt_err1,GPIO.OUT,initial=1)
GPIO.setup(prt_err2,GPIO.OUT,initial=1)
GPIO.setup(prt_err3,GPIO.OUT,initial=1)
GPIO.setup(prt_err4,GPIO.OUT,initial=1)
GPIO.setup(prt_in1,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_in2,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_in3,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_in4,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_out1,GPIO.OUT,initial=1)
GPIO.setup(prt_out2,GPIO.OUT,initial=1)
GPIO.setup(prt_out3,GPIO.OUT,initial=1)
GPIO.setup(prt_out4,GPIO.OUT,initial=1)
GPIO.setup(prt_sensor,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_switch,GPIO.IN,pull_up_down=GPIO.PUD_OFF)
GPIO.setup(prt_twrgreen,GPIO.OUT,initial=1)
GPIO.setup(prt_twrred,GPIO.OUT,initial=1)
GPIO.setup(prt_twryellow,GPIO.OUT,initial=1)
# 1st step
print " * input test (Press ^C to next!)"
print "   used ports:"
print "     In #1:", prt_in1
print "     In #2:", prt_in2
print "     In #3:", prt_in3
print "     In #4:", prt_in4
print "     Switch:", prt_switch, "\n"
try:
  while True:
    print "   status: ",GPIO.input(prt_in1),GPIO.input(prt_in2),GPIO.input(prt_in3),GPIO.input(prt_in4),GPIO.input(prt_switch)
    blink_act()
except KeyboardInterrupt:
    print "\n"
# 1st step
print " * output test (Press ^C to next!)"
print "   used ports:"
print "     Err #1:", prt_err1
print "     Err #2:", prt_err2
print "     Err #3:", prt_err3
print "     Err #4:", prt_err4
print "     Out #1:", prt_out1
print "     Out #2:", prt_out2
print "     Out #3:", prt_out3
print "     Out #4:", prt_out4, "\n"
try:
  while True:
    print "   active port: %02d" % prt_err1,
    GPIO.output(prt_err1,0)
    blink_act()
    GPIO.output(prt_err1,1)
    print "   active port: %02d" % prt_err2,
    GPIO.output(prt_err2,0)
    blink_act()
    GPIO.output(prt_err2,1)
    print "   active port: %02d" % prt_err3,
    GPIO.output(prt_err3,0)
    blink_act()
    GPIO.output(prt_err3,1)
    print "   active port: %02d" % prt_err4,
    GPIO.output(prt_err4,0)
    blink_act()
    GPIO.output(prt_err4,1)
    print "   active port: %02d" % prt_out1,
    GPIO.output(prt_out1,0)
    blink_act()
    GPIO.output(prt_out1,1)
    print "   active port: %02d" % prt_out2,
    GPIO.output(prt_out2,0)
    blink_act()
    GPIO.output(prt_out2,1)
    print "   active port: %02d" % prt_out3,
    GPIO.output(prt_out3,0)
    blink_act()
    GPIO.output(prt_out3,1)
    print "   active port: %02d" % prt_out4,
    GPIO.output(prt_out4,0)
    blink_act()
    GPIO.output(prt_out4,1)
    print "   active port: %02d" % prt_twrgreen,
    GPIO.output(prt_twrgreen,0)
    blink_act()
    GPIO.output(prt_twrgreen,1)
    print "   active port: %02d" % prt_twryellow,
    GPIO.output(prt_twrgreen,0)
    blink_act()
    GPIO.output(prt_twrgreen,1)
    print "   active port: %02d" % prt_twrred,
    GPIO.output(prt_twrgreen,0)
    blink_act()
    GPIO.output(prt_twrgreen,1)
except KeyboardInterrupt:
  GPIO.output(prt_act,0)
  GPIO.output(prt_err1,1)
  GPIO.output(prt_err2,1)
  GPIO.output(prt_err3,1)
  GPIO.output(prt_err4,1)
  GPIO.output(prt_out1,1)
  GPIO.output(prt_out2,1)
  GPIO.output(prt_out3,1)
  GPIO.output(prt_out4,1)
  GPIO.output(prt_twrgreen,1)
  GPIO.output(prt_twrred,1)
  GPIO.output(prt_twryellow,1)
  print"\n"
# 3rd step
print " * T/RH sensor test (Press ^C to exit!)"
print "   used port:", prt_sensor
print""
try:
  while True:
    blink_act()
    hum,temp=Adafruit_DHT.read_retry(sensor,prt_sensor)
    hi=int(hum)
    ti=int(temp)
    print "   humidity: %02d%% - temperature: %02d C" % (hi,ti),
    blink_act()
    blink_act()
    blink_act()
    blink_act()
except KeyboardInterrupt:
  GPIO.cleanup()
  print"\n"
