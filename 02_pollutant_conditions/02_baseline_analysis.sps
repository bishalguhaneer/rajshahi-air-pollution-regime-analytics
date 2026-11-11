* Encoding: UTF-8.
* ============================================================.
* Rajshahi Air-Pollution Regime Analytics.
* Stage 2 - Pollutant Conditions and Temporal Dynamics.
* Baseline pollutant distributions and descriptive statistics.
* ============================================================.
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