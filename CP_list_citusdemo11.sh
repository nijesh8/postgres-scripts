#!/bin/bash

export file1=pgscripts3.tar
for colo in lvs slc
do
export listfile=list_citusdemo11_$colo
for i in `cat $listfile`
do
if [ "$colo" == "lvs" ]; then
  echo "Copying $file1 to $i"; echo
  tk130d cp $file1 $i:/tmp/$file1
  tk130d exec -it $i -- tar xvf /tmp/$file1
  tk130d exec -it $i -- rm -f /tmp/$file1
  echo
else 
  echo "Copying $file1 to $i"; echo
  tk140d cp $file1 $i:/tmp/$file1
  tk140d exec -it $i -- tar xvf /tmp/$file1
  tk140d exec -it $i -- rm -f /tmp/$file1
  echo
fi
done
done

