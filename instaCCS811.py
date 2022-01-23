#!/usr/bin/python
#this example reads and prints CO2 equiv. measurement, TVOC measurement, and temp every 2 seconds

from time import sleep
from Adafruit_CCS811 import Adafruit_CCS811
output = open("/tmp/CCS811", "w")

ccs =  Adafruit_CCS811()

#while not ccs.available():
#	pass
temp = ccs.calculateTemperature()
ccs.tempOffset = temp - 25.0

while(1):
	if ccs.checkError():
		print "Jews"
		ccs.SWReset()
	if ccs.available():
	    temp = ccs.calculateTemperature()
	    temp = 9.0/5.0 * temp + 32
	    eco2 = ccs.geteCO2()
	    tvoc = ccs.getTVOC()
	    if not ccs.readData():
	      output = open("/tmp/CCS811", "w")
	      output.write("eco2=%s,tvoc=%s,barotemp=%s" % (eco2,tvoc,temp))
 	      output.close()
	      print "CO2: ", eco2, "ppm, TVOC: ", tvoc, " temp: ", temp

	    else:
	      print "ERROR!"
	      while(1):
	      	pass
	sleep(2)
