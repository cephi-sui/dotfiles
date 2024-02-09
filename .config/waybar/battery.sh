#! /bin/sh
if [ $# -eq 0 ]; then echo "Missing battery argument!"; exit 1; fi

# Initial data collection.
upower -i /org/freedesktop/UPower/devices/battery_$1 | 
awk '/state/ {printf "{\"alt\": " "\"" $2 "\", ";
              printf "\"class\": " "\"" $2 "\", "} 
     /time to/ {printf "\"tooltip\": " "\"" $4 " " $5 "\", "} 
     /percentage/ {gsub("%","",$2);
                   printf "\"percentage\": " $2 ", ";
                   printf "\"text\": " "\"" $2 "\"}";
                   print ""}'

# Listen for battery events and output JSON.
upower -i /org/freedesktop/UPower/devices/battery_$1 --monitor-detail | 
awk '/state/ {printf "{\"alt\": " "\"" $2 "\", ";
              printf "\"class\": " "\"" $2 "\", "} 
     /time to/ {printf "\"tooltip\": " "\"" $4 " " $5 "\", "} 
     /percentage/ {gsub("%","",$2);
                   printf "\"percentage\": " $2 ", ";
                   printf "\"text\": " "\"" $2 "\"}";
                   print ""}'
