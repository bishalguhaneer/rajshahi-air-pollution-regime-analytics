* Encoding: UTF-8.


GET DATA
  /TYPE=XLSX
  /FILE='E:\Freelancing\GIS freelancing and Practing\Practice\Basics '+
    'Practice\rajshahi-air-pollution-regime-analytics\data\processed\rajshahi_daily_2022_2024.xlsx'
  /SHEET=name 'DAILY_ANALYTICAL'
  /CELLRANGE=RANGE 'A1:S1097'
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.
* ------------------------------------------------------------.
* Rajshahi Air-Pollution Regime Analytics.
* Stage 2 - SPSS analytical dataset setup.
* ------------------------------------------------------------.

VARIABLE LABELS
 Date "Calendar date"
 Year "Calendar year"
 Month_Num "Calendar month number"
 Month "Calendar month"
 Season "Season"
 PM2.5_ValidHours "Valid hourly PM2.5 observations"
 PM2.5_DailyMean "Daily mean PM2.5 concentration (ug/m3)"
 PM10_ValidHours "Valid hourly PM10 observations"
 PM10_DailyMean "Daily mean PM10 concentration (ug/m3)"
 NO2_ValidHours "Valid hourly NO2 observations"
 NO2_DailyMean "Daily mean NO2 concentration (ppb)"
 SO2_ValidHours "Valid hourly SO2 observations"
 SO2_DailyMean "Daily mean SO2 concentration (ppb)"
 CO_ValidHours "Valid hourly CO observations"
 CO_DailyMean "Daily mean CO concentration (ppm)"
 O3_ValidHours "Valid hourly O3 observations"
 O3_DailyMean "Daily mean O3 concentration (ppb)"
 All6_Pass75 "All-six pollutants meet >=18/24 hourly completeness"
 Core4_Pass75 "Core4 pollutants meet >=18/24 hourly completeness".

VALUE LABELS
 All6_Pass75
  0 "Fail"
  1 "Pass"
 /Core4_Pass75
  0 "Fail"
  1 "Pass".

VARIABLE LEVEL
 Date (SCALE)
 Year (NOMINAL)
 Month_Num (ORDINAL)
 Month (NOMINAL)
 Season (NOMINAL)
 PM2.5_ValidHours PM2.5_DailyMean
 PM10_ValidHours PM10_DailyMean
 NO2_ValidHours NO2_DailyMean
 SO2_ValidHours SO2_DailyMean
 CO_ValidHours CO_DailyMean
 O3_ValidHours O3_DailyMean (SCALE)
 All6_Pass75 Core4_Pass75 (NOMINAL).

EXECUTE.

DATASET ACTIVATE DataSet1.
EXAMINE VARIABLES=PM2.5_DailyMean PM10_DailyMean NO2_DailyMean SO2_DailyMean CO_DailyMean 
    O3_DailyMean
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE VARIABLES
  /PERCENTILES(5,10,25,50,75,90,95) HAVERAGE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING PAIRWISE
  /NOTOTAL.
