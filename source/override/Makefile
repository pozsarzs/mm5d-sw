# +----------------------------------------------------------------------------+
# | MM5D v0.2 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2020 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

srcfiles = override.pas
binfiles = mm5d-override.bin

all:
	@echo "- Compiling source code..."
	@mkdir -p ./lib/$(architecture)-$(os)/
	@for x in $(srcfiles); do \
	  if [ -e $$x ]; then fpc $(fpflag) $$x; echo ""; fi; \
	done
	@mv ./lib/$(architecture)-$(os)/override ./lib/$(architecture)-$(os)/$(name)-override.bin
	@echo "...done."

clean:
	@echo -n "- Cleaning source code..."
	@$(rm) ./lib/$(architecture)-$(os)/*
	@echo "...done."

install:
	@echo -n "- Installing binary files..."
	@for x in $(binfiles); do \
	  if [ -e ./lib/$(architecture)-$(os)/$$x ]; then $(install) -m $(binmode) ./lib/$(architecture)-$(os)/$$x ../../binary/; fi; \
	done
	@echo "...done."
