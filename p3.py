#!/usr/bin/python3

import time
from multiprocessing import Pool
from datetime import datetime

def collect_result(val):
    return val


def cube(x):
    print(f"start process {x}")
    time.sleep(1)
    print(f"end process {x}")
    return x * x * x


def cube_print(x):
    # print(x * x * x)
    print (str(datetime.now()))


if __name__ == "__main__":
    pool = Pool(processes=4)
    # print(pool.map_async(cube, range(10), callback=collect_result).get())
    pool.map_async(cube_print, range(2))
    print("HERE!")
    print("HERE AGAIN!")
    pool.close()
    print("HERE AGAIN2!")
    pool.join()
