# +----------------------------------------------------------------------------+
# | MM5D v0.6 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2023 Pozsár Zsolt <pozsarzs@gmail.com>                  |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

srcfiles = editenvirconf.pas
binfiles = mm5d-editenvirconf.bin

all:
	@echo "- Compiling source code..."
	@mkdir -p ../_lib/$(architecture)-$(os)/
	@for x in $(srcfiles); do \
	  if [ -e $$x ]; then fpc $(fpflag) $$x; echo ""; fi; \
	done
	@mv ../_lib/$(architecture)-$(os)/editenvirconf ../_lib/$(architecture)-$(os)/$(name)-editenvirconf.bin
	@echo "...done."

clean:
	@echo -n "- Cleaning source code..."
	@$(rm) config.pas
	@$(rm) ../_lib/$(architecture)-$(os)/*
	@echo "...done."

install:
	@echo -n "- Installing binary files..."
	@for x in $(binfiles); do \
	  if [ -e ../_lib/$(architecture)-$(os)/$$x ]; then $(install) -m $(binmode) ../_lib/$(architecture)-$(os)/$$x ../../binary/; fi; \
	done
	@echo "...done."
