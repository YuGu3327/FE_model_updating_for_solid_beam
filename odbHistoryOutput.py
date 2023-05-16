#! /user/bin/python
#- -coding: UTF-8-*-
#odbHistoyOutput.py
# Importing required modules
import numpy as np
import time
import os
from odbAccess import *

# Setting path, step, instance and ReqData_f manually
# Use os.getcwd() to get the current working directory
current_dir = os.getcwd()
path = os.path.join(current_dir, 'Job-1_good_situation')
step = 'Step-1'
instance = 'WHOLE_MODEL'
ReqData_f = 'EIGFREQ'

# Appending '.odb' to the path
path = path + '.odb'

# Opening the Odb file
odb = openOdb(path=path)

# Creating a representation for the nth step
step_n = odb.steps[step]

# Getting the historical output area
region = step_n.historyRegions['Assembly ASSEMBLY']

# Getting frequency results
try:
    GetData = region.historyOutputs['EIGFREQ'].data
    GetData = np.mat(GetData)  # Convert the data into a numpy matrix
    np.savetxt(ReqData_f + '.txt', GetData, fmt='%.03f')  # Save as txt file and keep 3 decimal places
except:
    time.sleep(10)
    os.system('abaqus job=Job-1_good_situation ask_delete=OFF')
    time.sleep(110)
    odb = openOdb(path=path)
    step_n = odb.steps[step]
    region = step_n.historyRegions['Assembly ASSEMBLY']
    GetData = region.historyOutputs['EIGFREQ'].data
    GetData = np.mat(GetData)
    np.savetxt(ReqData_f + '.txt', GetData, fmt='%.03f')

# Define field of interest
field_region_bottom_surface = odb.rootAssembly.nodeSets['SET-NODE_BOTTOM']

# Get the mode result
GetData_shape = []  # Set an empty list

for m in range(2, 20):  # This value determines which order, 1-3 order
    for n in range(0, 19):  # This value determines how many points, 19 points
        GetData_shape_new = step_n.frames[m].fieldOutputs['U'].getSubset(region=field_region_bottom_surface).values[n].data
        GetData_shape = np.append(GetData_shape, GetData_shape_new[1])  # Append the new values to the list

np.savetxt('mode shape.txt', GetData_shape, fmt='%.05f')  # Save the data into a text file
