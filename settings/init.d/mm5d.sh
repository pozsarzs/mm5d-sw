#!/bin/sh

### BEGIN INIT INFO
# Provides:		mm5d
# Default-Start:	2 3 4 5
# Default-Stop:		
# Short-Description:	MM5D controlling software
### END INIT INFO

#BINFILE=/usr/bin/mm5d.py
BINFILE=/usr/local/bin/mm5d.py
PIDFILE=/var/run/mm5d.pid

set -e
test -x $BINFILE || exit 0
umask 022
. /lib/lsb/init-functions

# Are we running from init?
run_by_init() {
    ([ "$previous" ] && [ "$runlevel" ]) || [ "$runlevel" = S ]
}

export PATH="${PATH:+$PATH:}/usr/sbin:/sbin"

case "$1" in
  start)
	log_daemon_msg "Starting MM5D daemon" "mm5d" || true
	if start-stop-daemon --background -m --start --quiet --oknodo --pidfile $PIDFILE --exec $BINFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  stop)
	log_daemon_msg "Stopping MM5D daemon" "mm5d" || true
	if start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  restart)
	log_daemon_msg "Restarting MM5D daemon" "mm5d" || true
	start-stop-daemon --stop --quiet --oknodo --retry 30 --pidfile $PIDFILE
	if start-stop-daemon --background -m --start --quiet --oknodo --pidfile $PIDFILE --exec $BINFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  reload|force-reload)
	echo "Error: argument '$1' not supported" >&2
	exit 3
	;;
  *)
	log_action_msg "Usage: /etc/init.d/mm5d.sh {start|stop|restart|status}" || true
	exit 1
	;;
esac
