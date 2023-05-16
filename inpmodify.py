# coding: utf-8
# In[ ]:
#! /user/bin/python
#- -coding: UTF-8-*-
import os
import time

# Define the current directory path
current_directory = os.path.dirname(os.path.realpath(__file__))

# Define all file paths and strings
PATH = os.path.join(current_directory, 'C_EB_2D')
FILE_NAME = os.path.join(PATH, 'Job-1_good_situation.inp')
NEWDATA_FILE = os.path.join(PATH, 'NewData.txt')
MODIFYSTR = '*Material, name=Material-concrete1'

# Load the new data file
with open(NEWDATA_FILE, "r") as f:
    line_newdata = f.readlines()
index = 0

# Load the existing inp file
with open(FILE_NAME, "r") as f:
    file_lines = f.readlines()

# Initialize result variable
result = ""

# Iterate over the lines in the inp file
i = 0
while i < len(file_lines): 
    line = file_lines[i]
    if index >= len(line_newdata):
        result += line
        i += 1
        continue

    if MODIFYSTR in line:  
        # Skip two lines
        result += line + file_lines[i+1] + file_lines[i+2] + file_lines[i+3] + line_newdata[index]
        index += 1
        i += 5

        # Repeat this pattern for the next 9 blocks
        for m in range(9):
            result += file_lines[i] + file_lines[i+1] + file_lines[i+2] + line_newdata[index]
            index += 1
            i += 4
            
    else:
        result += line
        i += 1

# Write the result to the inp file
with open(FILE_NAME, "w") as f:
    f.write(result)
