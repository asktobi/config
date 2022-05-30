#! /bin/bash 
# tjh
# bin/bat

print "BAT1 : "
cat /sys/class/power_supply/BAT1/capacity
print "%, "
cat /sys/class/power_supply/BAT1/status
print " \n"
