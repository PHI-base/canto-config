#!/bin/sh
### BEGIN INIT INFO
# Provides: canto
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

export OWLTOOLS_MEMORY=4g

canto_path="/var/canto_space"
cmd="./canto/script/canto_start_docker"
user=""

name="phi-canto"
pid_file="perl"
stdout_log="/var/log/$name.log"
stderr_log="/var/log/$name.err"

get_pid() {
  sudo docker container ls | grep canto | cut -d ' ' -f 1
}

is_running() {
  mpid=`get_pid`; [ ${#mpid} -gt 0 ]
}

stop_phicanto() {
  sudo docker container stop `get_pid`
}

case "$1" in
  start)
  if is_running; then
    echo "Already started"
  else
    echo "Starting $name"
    cd "$canto_path"

    if [ -z "$user" ]; then
      $cmd >> "$stdout_log" 2>> "$stderr_log" &
    else
      $cmd >> "$stdout_log" 2>> "$stderr_log" &
    fi

    sleep 5
    echo `get_pid`

    if ! is_running; then
      echo "Unable to start, see $stdout_log and $stderr_log"
      exit 1
    fi
  fi
  ;;
  stop)
  if is_running; then
    echo -n "Stopping $name.."
    stop_phicanto
    for i in 1 2 3 4 5 6 7 8 9 10

      do
        if ! is_running; then
          break
        fi

        echo -n "."
        sleep 1
      done
        echo

      if is_running; then
        echo "Not stopped; may still be shutting down or shutdown may have failed"
        exit 1
      else
        echo "Stopped"
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
  echo "Usage: $0 {start|stop|restart|status}"
  exit 1
  ;;
esac

exit 0
