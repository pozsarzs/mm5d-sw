#!/usr/bin/python3
# +----------------------------------------------------------------------------+
# | MM5D v0.1 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2020 Pozsar Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | matrixdisplay.py                                                           |
# | Matrix display handler daemon                                              |
# +----------------------------------------------------------------------------+

#   This program is free software: you can redistribute it and/or modify it
# under the terms of the European Union Public License 1.1 version.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.

# Exit codes:
#   0: normal exit

import RPi.GPIO as GPIO
import time
from luma.core.interface.serial import spi, noop
from luma.core.legacy.font import proportional, SINCLAIR_FONT
from luma.core.legacy import text
from luma.core.render import canvas
from luma.core.virtual import viewport
from luma.led_matrix.device import max7219

file_pipe="/var/tmp/matrixdisplayfifo"

serial=spi(port=0, device=0, gpio=noop())
device=max7219(serial, width=32, height=8, block_orientation=-90)
device.contrast(5)
virtual=viewport(device, width=32, height=8)
s=''
while True:
  try:
    with open(file_pipe, "r") as fifo:
      s=fifo.read()
      fifo.close()
  except:
    print ("")
  with canvas(virtual) as draw:
    text(draw, (0, 0), s, fill="white", font=proportional(SINCLAIR_FONT))
  time.sleep(0.5)
GPIO.cleanup
exit(0)
