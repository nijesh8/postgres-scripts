#!/usr/bin/python3

import shutil 
import math

def disk_space(fs):
  total, used, free = shutil.disk_usage(fs)
  return total, used, free

if __name__ == '__main__':  
  fs_to_check = [ "/data", "/arch", "/backups"]
  warn_threshold = 1
  critical_threshold = 10
  print("\n")
  for fs in fs_to_check:
    total, used, free=disk_space(fs)
    total_gb = total // (2 ** 30)
    used_gb = used // (2 ** 30)
    free_gb = free // (2 ** 30)
    usage_perc = math.ceil(used*100/total)
    # print("File System: " + fs + ": " + "Total: " + str(total // (2 ** 30)) + " Used: " +  str(used // (2 ** 30)) + " Free: " +  str(free // (2 ** 30)) + " % Usate: " + str(math.ceil(used*100/total)) )
    print("File System: " + fs + ": " + "Total: " + str(total_gb) + " Used: " +  str(used_gb) + " Free: " +  str(free_gb) + " % Usate: " + str(usage_perc) )
    if usage_perc >= warn_threshold and usage_perc < critical_threshold:
      print("[WARNING] Filesystem " + fs + " crossed WARN Threshold: " + str(warn_threshold))
      print("Current Usage % for FS: " + fs + " is " + str(usage_perc) + "\n")
    elif usage_perc >= critical_threshold:
      print("[CRITICAL] Filesystem " + fs + " crossed CRITICAL Threshold: " + str(critical_threshold))
      print("Current Usage % for FS: " + fs + " is " + str(usage_perc) + "\n")


