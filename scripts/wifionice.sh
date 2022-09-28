
#if iwconfig wlp4so | grep -c "ESSID:\"WIFIonICE\""
#then
curl "https://www.ombord.info/hotspot/hotspot.cgi?connect=&method=login&realm=db_advanced_wifi"
#fi


