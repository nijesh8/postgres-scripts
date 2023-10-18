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

for i in `cat ${LISTFILE}`
do

  if [ $1 == "cp" ]; then
    FILE=$2
    if echo $i | grep -q "slc"; then
      CLUSTER=137
      cp_file slc $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "lvs"; then
      CLUSTER=134
      cp_file lvs $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "rno"; then
      CLUSTER=174
      cp_file rno $FILE $i $CLUSTER /home/postgres
    fi
  elif [ $1 == "check_file" ]; then
    FILE=$2
    if echo $i | grep -q "slc"; then
      CLUSTER=137
      check_file slc $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "lvs"; then
      CLUSTER=134
      check_file lvs $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "rno"; then
      CLUSTER=174
      check_file rno $FILE $i $CLUSTER /home/postgres
    fi 
  elif [ $1 == "chmod_file" ]; then
    FILE=$2
    if echo $i | grep -q "slc"; then
      CLUSTER=137
      chmod_file slc $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "lvs"; then
      CLUSTER=134
      chmod_file lvs $FILE $i $CLUSTER /home/postgres

    elif echo $i | grep -q "rno"; then
      CLUSTER=174
      chmod_file rno $FILE $i $CLUSTER /home/postgres
    fi
  elif [ $1 == "run_cmd" ]; then
    FILE=$2
    if echo $i | grep -q "slc"; then
      CLUSTER=137
      run_cmd slc $i $CLUSTER /home/postgres

    elif echo $i | grep -q "lvs"; then
      CLUSTER=134
      run_cmd lvs $i $CLUSTER /home/postgres

    elif echo $i | grep -q "rno"; then
      CLUSTER=174
      run_cmd rno $i $CLUSTER /home/postgres
    fi
  fi
done
