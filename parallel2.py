#!/usr/bin/python3

import multiprocessing
import time
from datetime import datetime

# square function
def square(x):
	return x * x

def current_time(y):
	time1 = str(datetime.now())
	return time1 


if __name__ == '__main__':

	# multiprocessing pool object
	pool = multiprocessing.Pool()

	# pool object with number of element
	pool = multiprocessing.Pool(processes=5)

	# input list
	inputs = [0, 1, 2, 3, 4]

	# map the function to the list and pass
	# function and input list as arguments
	outputs = pool.map(square, inputs)
	outputs2 = pool.map(current_time, inputs)
	outputs_async = pool.map_async(current_time, inputs)

	# Print input list
	print("Input: {}".format(inputs))

	# Print output list
	print("Output: {}".format(outputs))
	print("Output2: {}".format(outputs2))
	print("Output2: {}".format(outputs_async))
	print("Current time " + str(datetime.now()) )
    
