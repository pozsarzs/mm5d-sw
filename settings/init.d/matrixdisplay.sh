#!/bin/sh

### BEGIN INIT INFO
# Provides:		matrixdisplay
# Default-Start:	2 3 4 5
# Default-Stop:		
# Short-Description:	Matrix display handler
### END INIT INFO

BINFILE=/usr/local/bin/matrixdisplay.py
PIDFILE=/var/run/matrixdisplay.pid

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
	log_daemon_msg "Starting matrix display handler" "matrixdisplay" || true
	if start-stop-daemon --background -m --start --quiet --oknodo --pidfile $PIDFILE --exec $BINFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  stop)
	log_daemon_msg "Stopping matrix display handler" "matrixdisplay" || true
	if start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE; then
	    log_end_msg 0 || true
	else
	    log_end_msg 1 || true
	fi
	;;
  restart)
	log_daemon_msg "Restarting matrix display handler" "matrixdisplay" || true
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
	log_action_msg "Usage: /etc/init.d/matrixdisplay.sh {start|stop|restart|status}" || true
	exit 1
	;;
esac
