#!/bin/bash   


LISTFILE=list_stms

cp_file()
{ 
  echo "Copying " $2 " to " $3
  DIR1=$5
  tess kubectl --cluster=$4 -n postgresdba-prod cp $2 $3:${DIR1}/$2 
}

check_file()
{
  echo "Checking " $2 "  " $3
  DIR1=$5
  tess kubectl --cluster=$4 -n postgresdba-prod exec -it  $3 -- ls -lh ${DIR1}/$2
}

chmod_file()
{ 
  echo "chmod " $2 "  " $3
  DIR1=$5
  tess kubectl --cluster=$4 -n postgresdba-prod exec -it  $3 -- chmod u+x ${DIR1}/$2
}

run_cmd()
{
  CMD1=$5
  tess kubectl --cluster=$4 -n postgresdba-prod exec -it  $3 -- $CMD1
}


while getopts "t:c:r:o:d:f" opt; do
    case $opt in
        t) arg_t="$OPTARG" ;;
        c) arg_c="$OPTARG" ;;
        r) arg_r="$OPTARG" ;;
        o) arg_o="$OPTARG" ;;
        d) arg_d="$OPTARG" ;;
        f) arg_f="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" ;;
    esac
done

if [ $arg_t == "run_cmd" ]; then    # run_cmd
  if [ "$arg_r" ]; then
    for host in `cat ${LISTFILE}`
    do
        echo; echo
        echo "[HOST]: "$host" [CMD]: "$arg_r ; echo
        if echo ${host} | grep -q "slc"; then
          CLUSTER=137
          tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r
    
        elif echo ${host} | grep -q "lvs"; then
          CLUSTER=134
          tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r
    
        elif echo ${host} | grep -q "rno"; then
          CLUSTER=174
          tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r
        fi
    done
  else 
    echo "-r flag value for command is not given !!"
    exit
  fi
fi

exit

for host in `cat ${LISTFILE}`
do

  # if [ $1 == "cp" ]; then
  if [ ! $arg_t ]; then
    if [ $arg_t == "cp" ]; then    # cp_file 
      FILE=$2
      if echo $host | grep -q "slc"; then
        CLUSTER=137
        cp_file slc $FILE $host $CLUSTER /home/postgres
  
      elif echo $host | grep -q "lvs"; then
        CLUSTER=134
        cp_file lvs $FILE $host $CLUSTER /home/postgres
  
      elif echo $host | grep -q "rno"; then
        CLUSTER=174
        cp_file rno $FILE $host $CLUSTER /home/postgres
      fi
    fi
  fi
  ## elif [ $1 == "check_file" ]; then
  if [ ! $arg_c ]; then 
    if [ $arg_c == "check_file" ]; then    # check_file 
      if [ ! $arg_f ]; then
        echo "File name is not given with -f flag"
        exit
      else
        FILE=$2
        if echo ${host} | grep -q "slc"; then
          CLUSTER=137
          check_file slc $FILE ${host} $CLUSTER /home/postgres
    
        elif echo ${host} | grep -q "lvs"; then
          CLUSTER=134
          check_file lvs $FILE ${host} $CLUSTER /home/postgres
    
        elif echo ${host} | grep -q "rno"; then
          CLUSTER=174
          check_file rno $FILE ${host} $CLUSTER /home/postgres
        fi 
      fi
    # elif [ $1 == "chmod_file" ]; then
    fi
  fi
  if [ ! $arg_o ]; then 
    if [ $arg_o ]; then    # chmod_file 
      FILE=$2
      if echo ${host} | grep -q "slc"; then
        CLUSTER=137
        chmod_file slc $FILE ${host} $CLUSTER /home/postgres
  
      elif echo ${host} | grep -q "lvs"; then
        CLUSTER=134
        chmod_file lvs $FILE ${host} $CLUSTER /home/postgres
  
      elif echo ${host} | grep -q "rno"; then
        CLUSTER=174
        chmod_file rno $FILE ${host} $CLUSTER /home/postgres
      fi
    fi
  fi
  ## elif [ $1 == "run_cmd" ]; then
  
  if [ $arg_t == "run_cmd" ]; then    # run_cmd 
    if echo ${host} | grep -q "slc"; then
      CLUSTER=137
      tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r

    elif echo ${host} | grep -q "lvs"; then
      CLUSTER=134
      tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r

    elif echo ${host} | grep -q "rno"; then
      CLUSTER=174
      tess kubectl --cluster=$CLUSTER -n postgresdba-prod exec -it  ${host} -- $arg_r
    fi
  fi
done
