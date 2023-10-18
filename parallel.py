#!/usr/bin/python3

from multiprocessing import Pool


def print_range(range):
	
    # print range
    print('From {} to {}:'.format(range[0], range[1]))


def run_parallel():
	
    # list of ranges
    list_ranges = [[0, 10], [10, 20], [20, 30]]

    print ('Length of list_ranges ' + str(len(list_ranges)) + '\n')
    # pool object with number of elements in the list
    pool = Pool(processes=len(list_ranges))

    # map the function to the list and pass
    # function and list_ranges as arguments
    pool.map(print_range, list_ranges)

# Driver code
if __name__ == '__main__':
    run_parallel()

