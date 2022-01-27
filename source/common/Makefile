# +----------------------------------------------------------------------------+
# | MM5D v0.4 * Growing house controlling and remote monitoring system         |
# | Copyright (C) 2019-2022 Pozsár Zsolt <pozsar.zsolt@szerafingomba.hu>       |
# | Makefile                                                                   |
# | Make file for source code                                                  |
# +----------------------------------------------------------------------------+

include ../Makefile.global

srcfiles = untcommon.pas

all:
	@echo "- Compiling source code..."
	@mkdir -p ../_lib/$(architecture)-$(os)/
	@for x in $(srcfiles); do \
	  if [ -e $$x ]; then fpc $(fpflag) $$x; echo ""; fi; \
	done
	@echo "...done."

clean:
	@echo -n "- Cleaning source code..."
	@$(rm) ../_lib/$(architecture)-$(os)/*
	@echo "...done."
