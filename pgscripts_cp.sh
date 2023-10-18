#!/bin/bash 
. ~/.profile

export LISTFILE=$1
export SCPFILE=$2


for i in `cat $LISTFILE`
do
  for colo in slc lvs
  do
  if  echo "$i" | grep -q "$colo"   ; then
    echo "yes"
    if [ $colo == "slc" ];then
      tk140d cp $SCPFILE $i:/tmp/$SCPFILE
      tk140d exec -it $i -- tar xvfz /tmp/$SCPFILE -C /home/postgres
    elif [ $colo == "lvs" ];then
      tk130d cp $SCPFILE $i:/tmp/$SCPFILE
      tk130d exec -it $i -- tar xvfz /tmp/$SCPFILE -C /home/postgres
    fi
  fi
  done
done
