* Encoding: UTF-8.

* ============================================================.
* STAGE 5.4 - CONSECUTIVE-CALENDAR-DAY PERSISTENCE.
* Unit at entry = one Core4-complete analytical day.
* Persistence requires the same retained regime on consecutive
* calendar dates. Missing/unavailable calendar days break episodes.
* ============================================================.


* ------------------------------------------------------------.
* Step 5.4.1 - Ensure chronological ordering.
* ------------------------------------------------------------.

SORT CASES BY Date(A).
EXECUTE.


* ------------------------------------------------------------.
* Step 5.4.2 - Retrieve previous analytical date and regime.
* ------------------------------------------------------------.

COMPUTE PrevDate = LAG(Date).
COMPUTE PrevRegime = LAG(Regime3).

FORMATS PrevDate (DATE11).

VARIABLE LABELS
 PrevDate 'Calendar date of previous retained analytical observation'
 PrevRegime 'Regime of previous retained analytical observation'.

EXECUTE.


* ------------------------------------------------------------.
* Step 5.4.3 - Identify true consecutive-calendar-day continuation.
*
* Continuation requires BOTH:
* 1. exactly one calendar day since the previous retained
*    observation; and
* 2. the same retained k=3 regime.
*
* SPSS date differences are expressed in seconds;
* 86400 seconds = one calendar day.
* Missing calendar days therefore break an episode.
* ------------------------------------------------------------.

COMPUTE SameRegimeNextDay = 0.

IF ((Date - PrevDate) = 86400 AND Regime3 = PrevRegime)
 SameRegimeNextDay = 1.

IF (MISSING(PrevDate))
 SameRegimeNextDay = 0.

VARIABLE LABELS SameRegimeNextDay
 '1 = same regime as immediately preceding calendar day; 0 = new/broken episode'.

VALUE LABELS SameRegimeNextDay
 0 'No continuation'
 1 'Consecutive-day continuation'.

FORMATS SameRegimeNextDay (F8.0).

EXECUTE.


* QA: continuation versus episode-breaking observations.

FREQUENCIES VARIABLES=SameRegimeNextDay
 /ORDER=ANALYSIS.


* ------------------------------------------------------------.
* Step 5.4.4 - Construct consecutive-calendar-day episode IDs.
*
* Every observation that is not a continuation starts a new
* episode. EpisodeID is the cumulative number of episode starts.
* CREATE is used because CSUM is an SPSS series function.
* ------------------------------------------------------------.

COMPUTE EpisodeStart = (SameRegimeNextDay = 0).

VARIABLE LABELS EpisodeStart
 '1 = start of a new consecutive-calendar-day regime episode; 0 = continuation'.

VALUE LABELS EpisodeStart
 0 'Continuation'
 1 'New episode'.

FORMATS EpisodeStart (F8.0).

EXECUTE.


CREATE EpisodeID = CSUM(EpisodeStart).

VARIABLE LABELS EpisodeID
 'Sequential ID for consecutive-calendar-day regime episodes'.

FORMATS EpisodeID (F8.0).

EXECUTE.


* QA: verify episode starts and resulting EpisodeID range.

FREQUENCIES VARIABLES=EpisodeStart
 /ORDER=ANALYSIS.

DESCRIPTIVES VARIABLES=EpisodeID
 /STATISTICS=MIN MAX.


* ------------------------------------------------------------.
* Step 5.4.5 - Calculate episode length.
*
* EpisodeLength is temporarily added to every day belonging to
* the same EpisodeID. Therefore, descriptive means calculated
* from this day-level variable would be day-weighted and are NOT
* used as final episode-duration statistics.
* ------------------------------------------------------------.

AGGREGATE
 /OUTFILE=* MODE=ADDVARIABLES
 /BREAK=EpisodeID
 /EpisodeLength=N.

VARIABLE LABELS EpisodeLength
 'Number of consecutive calendar days in the regime episode'.

FORMATS EpisodeLength (F8.0).

EXECUTE.


* QA only: verify range of episode lengths at day level.
* Final persistence statistics are calculated after conversion
* to one record per episode.

DESCRIPTIVES VARIABLES=EpisodeLength
 /STATISTICS=MIN MAX.


* ============================================================.
* Step 5.4.6 - CREATE EPISODE-LEVEL DATASET.
*
* One record is written for each consecutive-calendar-day
* regime episode. The active 723-day working dataset is not
* collapsed or replaced by this OUTFILE operation.
*
* For public reproducibility, set the output location to the
* appropriate project directory before execution.
* ============================================================.

AGGREGATE
 /OUTFILE='05_regime_episode_level.sav'
 /BREAK=EpisodeID
 /Regime3=FIRST(Regime3)
 /EpisodeStartDate=MIN(Date)
 /EpisodeEndDate=MAX(Date)
 /EpisodeLength=FIRST(EpisodeLength).


* ============================================================.
* Step 5.4.7 - ACTIVATE AND DOCUMENT EPISODE-LEVEL DATASET.
*
* The AGGREGATE OUTFILE command above creates the SAV but does
* not automatically make it the active dataset. Open the derived
* episode-level file before executing the remaining commands.
* ============================================================.

GET FILE='05_regime_episode_level.sav'.

DATASET NAME EpisodeLevel.

VARIABLE LABELS
 EpisodeID 'Sequential ID for consecutive-calendar-day regime episodes'
 Regime3 'Retained k=3 pollution regime'
 EpisodeStartDate 'First calendar date of regime episode'
 EpisodeEndDate 'Last calendar date of regime episode'
 EpisodeLength 'Number of consecutive calendar days in regime episode'.

FORMATS
 EpisodeID (F8.0)
 Regime3 (F8.0)
 EpisodeStartDate EpisodeEndDate (DATE11)
 EpisodeLength (F8.0).

VALUE LABELS Regime3
 1 'PM2.5/NO2-elevated, lower-O3 profile'
 2 'CO-elevated, comparatively low-NO2 profile'
 3 'O3-elevated, low-CO profile'.

EXECUTE.


* QA: episode-level dataset should contain one record per EpisodeID.

DESCRIPTIVES VARIABLES=EpisodeID EpisodeLength
 /STATISTICS=MIN MAX.

FREQUENCIES VARIABLES=Regime3
 /ORDER=ANALYSIS.


* ============================================================.
* Step 5.4.8 - EPISODE PERSISTENCE BY RETAINED REGIME.
*
* Unit of analysis = one consecutive-calendar-day regime episode.
* Because episode-duration distributions are right-skewed,
* medians, IQRs and percentiles are emphasized alongside
* conventional descriptive statistics.
* ============================================================.

SORT CASES BY Regime3(A).

EXAMINE VARIABLES=EpisodeLength BY Regime3
 /PLOT BOXPLOT
 /COMPARE GROUPS
 /PERCENTILES(25,50,75,90,95) HAVERAGE
 /STATISTICS DESCRIPTIVES
 /CINTERVAL 95
 /MISSING LISTWISE
 /NOTOTAL.

FREQUENCIES VARIABLES=Regime3
 /ORDER=ANALYSIS.
