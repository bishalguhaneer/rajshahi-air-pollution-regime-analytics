* Encoding: UTF-8.

EXAMINE VARIABLES=PM2.5_DailyMean PM10_DailyMean NO2_DailyMean SO2_DailyMean CO_DailyMean 
    O3_DailyMean BY Month_Num
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING PAIRWISE
  /NOTOTAL.
