# +----------------------------------------------------------------------------+
# | MM5D v0.1 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019 Pozsár Zsolt <pozsar.zsolt@.szerafingomba.hu>           |
# | Makefile                                                                   |
# | Makefile for Unix-like systems                                             |
# +----------------------------------------------------------------------------+

include ./Makefile.global

dirs =  editenvirconf editmainconf override

all:
	@echo Compiling $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir all; fi; \
	done
	@echo "Source code is compiled."

clean:
	@echo Cleaning source code:
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir clean; fi; \
	done
	@echo "Source code is cleaned."

install:
	@echo Installing $(name):
	@for dir in $(dirs); do \
	  if [ -e Makefile ]; then make -s -C $$dir install; fi; \
	done
	@echo "Programs are installed."