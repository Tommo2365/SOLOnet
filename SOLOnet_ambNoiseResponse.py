#########################################  READ ME  #####################################################

# This software version deals with both single and double variabless at i.e ambient and target temperatures
## For ambient scans, if there is an odd number of data points in the orginal txt file - Delete the last data point.
###  To work in conjunction with Realterm. The 'display as' (In real Term) fucntion MUST be Acsii

#########################################  READ ME  #####################################################

import os
import re
import numpy as np
import pandas as pd
import string
import regex as rx
import time
from datetime import datetime
import array
import matplotlib.pyplot as plt
from matplotlib.pyplot import plot, draw, show, ion
import tkinter as tk
from tkinter import filedialog
import easygui
from easygui import msgbox, multenterbox

# input fields
fieldNames = ["Boolean Noise/Response?", "Boolean Ambient scan?"]
fieldValues = list(multenterbox(msg='Select Boolean(0/1) for Experiment Type', title='Enter', fields=(fieldNames)))

boolenNoiseResponse = (fieldValues[0])
booleanAmbientScan = (fieldValues[1])

############################################################################################## NOISE/RESPONSE ######################################################################################################################################

if boolenNoiseResponse == '1':
    root = tk.Tk()
    root.withdraw()

    # Open a diffrent directory
    path = r'C:\temp'
    os.chdir(path)
    print("Please select a .txt file..." )

    infile = filedialog.askopenfilename()

    # print(os.getcwd())              # where is this file?
    # print(os.listdir())             # list all the files in that directory

    # Create a timestamp on the save file
    now = datetime.now() 
    timestamp = now.strftime("%Y%m%d_%H_%M_%S_")

    # Open selected file and remove speical characters and spaces

    #infile = "txtfile.txt"
    outfile = timestamp + "Data.txt"

    delete_list = ["\x03", "\x02", "\x01", "*", " "] # choose strings to replace with, " "
    fin = open(infile)
    fout = open(outfile, "w+")
    for line in fin:
        for word in delete_list:
            line = line.replace(word, "")
        fout.write(line)
    fin.close()
    fout.close()

    # Reopen file

    newfile = timestamp + "Data.csv"

    refile = open(outfile)
    nfile =  open(newfile, "w+")

    # Keep track of number of lines
    lc = 0                                                            
    data = []

    # Create an array
    for row in refile:                              
        data.append(row) 
        lc+=1                                                       
    refile.seek(0)                                  
    nRows = len(data)

    output = np.array([])

    for index in range(0, nRows):
        thisElement = data[index]
        splitString = thisElement.split('x01')
        #print(thisElement)
        splitString2 = thisElement.split('\n')
        valueString = splitString2[0]
        #value = float(valueString)
        output = np.append(valueString,output)

    #output2 = np.reshape(output, (int(nRows/2),2))

    np.savetxt(timestamp + 'Data.csv', output, delimiter=',', fmt=['%s'], header=[])

    print("Done...")



############################################################################################## AMBIENT ######################################################################################################################################

if booleanAmbientScan == '1':
    root = tk.Tk()
    root.withdraw()

    # Open a diffrent directory
    path = r'C:\temp'
    os.chdir(path)
    print("Please select a .txt file with an even number of data points..." )

    infile = filedialog.askopenfilename()

    # print(os.getcwd())              # where is this file?
    # print(os.listdir())             # list all the files in that directory

    # Create a timestamp on the save file
    now = datetime.now() 
    timestamp = now.strftime("%Y%m%d_%H_%M_%S_")

    # Open selected file and remove speical characters and spaces

    #infile = "capture.txt"
    outfile = timestamp + "Data.txt"

    delete_list = ["*", "\x03", "\x02", "\x01"," "] # choose strings to replace with " "
    fin = open(infile)
    fout = open(outfile, "w+")
    for line in fin:
        for word in delete_list:
            line = line.replace(word, "")
        fout.write(line)
    fin.close()
    fout.close()

    # Reopen file

    newfile = timestamp + "Data.csv"

    refile = open(outfile)
    nfile =  open(newfile, "w+")

    # Keep track of number of lines
    lc = 0                                                            
    data = []

    # Create an array
    for row in refile:                              
        data.append(row) 
        lc+=1                                                       
    refile.seek(0)                                  
    nRows = len(data)

    # create array

    output = np.array([])

    for index in range(0, nRows):
        thisElement = data[index]
        splitString = thisElement.split('x01')
        #print(thisElement)
        splitString2 = thisElement.split('\n')
        valueString = splitString2[0]
        #value = float(valueString)
        output = np.append(valueString,output)
    
    # display error message if excemption thrown
    errorBox = msgbox(msg="Cannot reshape data into " + str(nRows/2) + " x 2 array." + "\n" +  "\n" + "Please delete the last data point from " + infile + " and try again.", title="ERROR", ok_button="OK")
   
    try:
        output2 = np.reshape(output, (int(nRows/2),2))
    except Exemption as errorBox:
       print(errorBox)

    np.savetxt(timestamp + 'Data.csv', output2, delimiter=',', fmt=['%s', '%s'], header=[])

    print("Done...")