#!/bin/bash

while getopts "p:c:r:o" opt; do
    case $opt in
        p) arg_p="$OPTARG" ;;
        c) arg_c="$OPTARG" ;;
        r) arg_r="$OPTARG" ;;
        o) arg_o="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" ;;
    esac
done


if [ $arg_p ]; then
  echo $arg_p
else
  echo "no -p value"
fi
