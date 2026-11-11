* Encoding: UTF-8.


*Nonparametric Tests: Independent Samples. 
NPTESTS 
  /INDEPENDENT TEST (PM2.5_DailyMean PM10_DailyMean NO2_DailyMean SO2_DailyMean CO_DailyMean 
    O3_DailyMean) GROUP (Year) KRUSKAL_WALLIS(COMPARE=PAIRWISE) 
  /MISSING SCOPE=ANALYSIS USERMISSING=EXCLUDE
  /CRITERIA ALPHA=0.05  CILEVEL=95.
