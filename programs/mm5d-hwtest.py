#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM5D v0.1 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2020 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
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

import Adafruit_DHT
import configparser
import io
import RPi.GPIO as GPIO
import sys
import time
from luma.core.interface.serial import spi, noop
from luma.core.legacy.font import proportional, LCD_FONT
from luma.core.legacy import text
from luma.core.render import canvas
from luma.core.virtual import viewport
from luma.led_matrix.device import max7219

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
  global prt_speaker
  global prt_switch
  global prt_twrgreen
  global prt_twrred
  global prt_twryellow
  global sensor
  try:
    with open(conffile) as f:
      mm5d_config=f.read()
    config=configparser.RawConfigParser(allow_no_value=True)
    config.read_file(io.StringIO(mm5d_config))
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

# write text to display
def writetodisplay(txt):
  with canvas(virtual) as draw:
    text(draw, (0, 1), txt, fill="white", font=proportional(LCD_FONT))
  time.sleep(1)

#conffile='/etc/mm5d/mm5d.ini'
conffile='/usr/local/etc/mm5d/mm5d.ini'
print("\nMM5D hardware test utility * (C)2019-2020 Pozsar Zsolt")
print("======================================================")
print(" * load configuration: %s..." % conffile)
loadconfiguration(conffile)
print(" * setting ports...")
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
GPIO.setup(prt_speaker,GPIO.OUT)
GPIO.setup(prt_switch,GPIO.IN,pull_up_down=GPIO.PUD_DOWN)
GPIO.setup(prt_twrgreen,GPIO.OUT,initial=1)
GPIO.setup(prt_twrred,GPIO.OUT,initial=1)
GPIO.setup(prt_twryellow,GPIO.OUT,initial=1)
print(" * initialising display...")
serial=spi(port=0, device=0, gpio=noop())
device=max7219(serial, width=32, height=8, block_orientation=-90)
device.contrast(5)
virtual=viewport(device, width=32, height=8)
while True:
  writetodisplay("")
  print(" * What do you like?")
  selection=input(" \
   1: Check input ports\n \
   2: Check LEDs\n \
   3: Check controlling outputs\n \
   4: Check signal light outputs\n \
   5: Check T/RH sensor\n \
   6: Check speaker\n \
   q: Quit\n")
  if selection is "Q" or selection is "q":
        print(" * Quitting.")
        GPIO.cleanup()
        sys.exit()
  if selection is "1":
    print(" * Check input ports")
    print("   used ports:")
    print("     In #1:  GPIO", prt_in1)
    print("     In #2:  GPIO", prt_in2)
    print("     In #3:  GPIO", prt_in3)
    print("     In #4:  GPIO", prt_in4)
    print("     Switch: GPIO", prt_switch)
    print("   Press ^C to stop!")
    try:
      while True:
        s=""
        if GPIO.input(prt_in1):
          s="O"
        else:
          s="C"
        if GPIO.input(prt_in2):
          s=s+"O"
        else:
          s=s+"C"
        if GPIO.input(prt_in3):
          s=s+"O"
        else:
          s=s+"C"
        if GPIO.input(prt_in4):
          s=s+"O"
        else:
          s=s+"C"
        if GPIO.input(prt_switch):
          s=s+"O"
        else:
          s=s+"C"
        writetodisplay(s)
    except KeyboardInterrupt:
        print()
  if selection is "2":
    print(" * Check LEDs")
    print("   used ports:")
    print("     Act:    GPIO", prt_act)
    print("     Err #1: GPIO", prt_err1)
    print("     Err #2: GPIO", prt_err2)
    print("     Err #3: GPIO", prt_err3)
    print("     Err #4: GPIO", prt_err4)
    print("   Press ^C to stop!")
    try:
      while True:
        GPIO.output(prt_act,1)
        writetodisplay('Act')
        GPIO.output(prt_act,0)
        GPIO.output(prt_err1,0)
        writetodisplay('Err#1')
        GPIO.output(prt_err1,1)
        GPIO.output(prt_err2,0)
        writetodisplay('Err#2')
        GPIO.output(prt_err2,1)
        GPIO.output(prt_err3,0)
        writetodisplay('Err#3')
        GPIO.output(prt_err3,1)
        GPIO.output(prt_err4,0)
        writetodisplay('Err#4')
        GPIO.output(prt_err4,1)
    except KeyboardInterrupt:
      GPIO.output(prt_act,0)
      GPIO.output(prt_err1,1)
      GPIO.output(prt_err2,1)
      GPIO.output(prt_err3,1)
      GPIO.output(prt_err4,1)
      print()

  if selection is "3":
    print(" * Check controlling outputs")
    print("   used ports:")
    print("     Out #1: GPIO", prt_out1)
    print("     Out #2: GPIO", prt_out2)
    print("     Out #3: GPIO", prt_out3)
    print("     Out #4: GPIO", prt_out4)
    print("   Press ^C to skip next!")
    try:
      while True:
        GPIO.output(prt_out1,0)
        writetodisplay('Out#1')
        GPIO.output(prt_out1,1)
        GPIO.output(prt_out2,0)
        writetodisplay('Out#2')
        GPIO.output(prt_out2,1)
        GPIO.output(prt_out3,0)
        writetodisplay('Out#3')
        GPIO.output(prt_out3,1)
        GPIO.output(prt_out4,0)
        writetodisplay('Out#4')
        GPIO.output(prt_out4,1)
    except KeyboardInterrupt:
      GPIO.output(prt_out1,1)
      GPIO.output(prt_out2,1)
      GPIO.output(prt_out3,1)
      GPIO.output(prt_out4,1)
      print()

  if selection is "4":
    print(" * Check signal light outputs")
    print("   used ports:")
    print("     Green:  GPIO", prt_twrgreen)
    print("     Yellow: GPIO", prt_twryellow)
    print("     Red:    GPIO", prt_twrred)
    print("   Press ^C to skip next!")
    try:
      while True:
        GPIO.output(prt_twrgreen,0)
        writetodisplay('Green')
        GPIO.output(prt_twrgreen,1)
        GPIO.output(prt_twryellow,0)
        writetodisplay('Yellow')
        GPIO.output(prt_twryellow,1)
        GPIO.output(prt_twrred,0)
        writetodisplay('Red')
        GPIO.output(prt_twrred,1)
    except KeyboardInterrupt:
      GPIO.output(prt_out1,1)
      GPIO.output(prt_out2,1)
      GPIO.output(prt_out3,1)
      GPIO.output(prt_out4,1)
      print()

  if selection is "5":
    print(" * Check T/RH sensor")
    print("   used ports:")
    print("     Data:  GPIO", prt_sensor)
    print("   Press ^C to exit!")
    try:
      while True:
        hum,temp=Adafruit_DHT.read_retry(sensor,prt_sensor)
        temp=round(temp)
        hum=round(hum)
        writetodisplay(str(temp)+"  "+str(hum))
        time.sleep(1)
    except KeyboardInterrupt:
      print()

  if selection is "6":
    print(" * Check speaker")
    print("   used ports:")
    print("     Data:  GPIO", prt_speaker)
    print("   Press ^C to exit!")
    try:
      p=GPIO.PWM(17,100)
      p.ChangeFrequency(425)
      p.start(0)
      while True:
        writetodisplay("")
        p.ChangeDutyCycle(50)
        writetodisplay("Beep...")
        p.ChangeDutyCycle(0)
    except KeyboardInterrupt:
      p.stop()
      print()
