#!/bin/sh
# /etc/init.d/canto

### BEGIN INIT INFO
# Provides:          canto
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Canto community annotation tool
### END INIT INFO

canto_path="/var/canto_space"
cmd="./canto/script/canto_start_docker --no-tty"

name="phi-canto"
stdout_log="/var/log/$name.log"
stderr_log="/var/log/$name.err"

get_pid() {
  docker container ls | grep canto | cut -d ' ' -f 1
}

is_running() {
  container=$(get_pid)
  [ ${#container} -gt 0 ]
}

stop_phicanto() {
  container=$(get_pid)
  docker kill --signal=SIGINT "$container"
  docker container stop "$container"
}

case "$1" in
  start)
    if is_running; then
      echo "Already started"
    else
      cd "$canto_path" || exit

      $cmd >> "$stdout_log" 2>> "$stderr_log" &

      max_wait=10
      waited=0
      sleep 1
      while ! is_running; do
        if [ $waited -lt $max_wait ]; then
          waited=$((waited + 1))
          sleep 1
        else
          echo "Canto took too long to start. Check $stdout_log and $stderr_log"
          exit 1
        fi
      done
    fi
    ;;
  stop)
    if is_running; then
      stop_phicanto
      if is_running; then
        echo "Not stopped; may still be shutting down or shutdown may have failed"
        exit 1
      fi
    else
      echo "Not running"
    fi
    ;;
  restart)
    $0 stop
    if is_running; then
      echo "Unable to stop, will not attempt to start"
      exit 1
    fi
    $0 start
    ;;
  status)
    if is_running; then
      echo "Running"
    else
      echo "Stopped"
      exit 1
    fi
    ;;
  *)
    echo "Usage: service canto {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
