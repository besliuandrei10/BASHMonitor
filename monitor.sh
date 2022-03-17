#!/bin/bash

echo "Setting up monitor..."

TIME=$1
quitpoint=$(($(date +%s) + $TIME))
regex=$2

if [[ $(ls log.txt 2> /dev/null) ]]; then
  rm -f log.txt
fi

curr_tty=$(ps -o tty= | tr '\n' ' ' | cut -d' ' -f1)
old_pids=( $(ls -l /proc | tr -s ' ' | cut -d' ' -f9 | grep ^[0-9]*$ | tr " " "\n" | sort -g) )

echo "Setup complete!"
echo "Scanning /proc for new PID's..."

while [[ $TIME -gt 0 ]]
do
  new_pids=( $(ls -l /proc | tr -s ' ' | cut -d' ' -f9 | grep ^[0-9]*$ | tr " " "\n" | sort -g) )

  i=0

  while [[ i -lt ${#new_pids[@]} ]]; do

    if [[ ! "${old_pids[@]}" =~ "${new_pids[$i]}" ]]; then

      proc_tty=$(ps -p ${new_pids[$i]} -o tty=)

      if [[ ${#proc_tty} -ne 0 ]]; then

        if [[ "$proc_tty" != "$curr_tty" ]]; then

          if [[ ! $(grep ${new_pids[$i]} log.txt 2> /dev/null) ]]; then

            output=( $(ps -p ${new_pids[$i]} -o user=,ppid=,cmd= | tr -s '[:blank:]' ' ') )
            ppid=${output[1]}
            pcmd=$(ps -p $PPID -o cmd=)

            user=${output[0]}
            pid=${new_pids[$i]}

            unset 'output[0]'
            unset 'output[1]'

            cmd=${output[@]}

            if [[ ${#regex} -ne 0 ]]; then

              if [[ $cmd =~ $regex ]]; then

                echo "###### NEW PROCESS ######"
                echo "  USER: $user"
                echo "  PID: $pid"
                echo "  CMD: $cmd"
                echo "  PPID: $ppid"
                echo "  PPCMD: $pcmd"
                echo "-------------------------"

                echo "$pid","$user","$cmd","$ppid","$pcmd" >> log.txt
              fi

            else

              echo "###### NEW PROCESS ######"
              echo "  USER: $user"
              echo "  PID: $pid"
              echo "  CMD: $cmd"
              echo "  PPID: $ppid"
              echo "  PPCMD: $pcmd"
              echo "-------------------------"

              echo "$pid","$user","$cmd","$ppid","$pcmd" >> log.txt

            fi
          fi
        fi
      fi
    fi

    i=$(( i + 1 ))

  done

  old_pids=new_pids

  if [[ $(date +%s) -ge $quitpoint ]]; then
    TIME=0
  fi

done

echo "Script timed out."
