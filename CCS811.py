#!/usr/bin/python
#this example reads and prints CO2 equiv. measurement, TVOC measurement, and temp every 2 seconds

from time import sleep
from Adafruit_CCS811 import Adafruit_CCS811

ccs =  Adafruit_CCS811()
#ccs.SWReset()

"""
CCS811_DRIVE_MODE_IDLE  = 0
CCS811_DRIVE_MODE_1SEC  = 1
CCS811_DRIVE_MODE_10SEC = 2
CCS811_DRIVE_MODE_60SEC = 3
CCS811_DRIVE_MODE_250MS = 4
"""

ccs.setDriveMode(1)


#while not ccs.available():
#        pass
temp = ccs.calculateTemperature()
ccs.tempOffset = temp - 25.0

while(1):
    if ccs.checkError():
        ccs.SWReset()
    co2s = []
    temps = []
    tvocs = []
    reads = 0
    while reads < 60:
        try:
            if ccs.available():
                if not ccs.readData():
                    temp = ccs.calculateTemperature()
                    eco2 = float(ccs.geteCO2())
                    tvoc = ccs.getTVOC()
#                    if eco2 < 1:
#                        continue
                    temp = 9.0/5.0 * temp + 32
                        # output = open("/tmp/CCS811", "w")
                        # output.write("eco2=%s,tvoc=%s,barotemp=%s" % (eco2,tvoc,temp))
                        # print "eco2=%s,tvoc=%s,barotemp=%s" % (eco2,tvoc,temp)
                        # output.close()
                        #print "CO2: ", ccs.geteCO2(), "ppm, TVOC: ", ccs.getTVOC(), " temp: ", temp
                    co2s.append(eco2)
                    temps.append(temp)
                    tvocs.append(tvoc)
		    reads += 1
                else:
                        print "ERROR!"
        except IOError:
            pass
    output = open("/tmp/CCS811", "w")

    results = "eco2=%s,tvoc=%s,barotemp=%s" % (sum(co2s)/reads , sum(tvocs)/reads , sum(temps)/reads)
    output.write(results)
    print results
    output.close()
