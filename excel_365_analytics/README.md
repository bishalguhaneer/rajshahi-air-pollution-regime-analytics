# Rajshahi Air Pollution | Excel 365 Analytics

**Power Query • Excel formulas • PivotTables and PivotCharts • Interactive dashboards**  
**Study period:** 2022–2024 | **Analytical focus:** PM2.5, NO2, CO and O3 (Core4)

I developed this Excel 365 workbook to turn finalized air-quality analytical results into a structured, refreshable and interactive reporting system. It brings five connected analytical domains into one workbook while demonstrating my work with Power Query, Excel Tables, formula-driven retrieval and calculations, PivotTables, PivotCharts, slicers and dashboard design.

The underlying research began with open-source monitoring datasets, followed by initial cleaning and analytical preparation in Excel, statistical analyses in IBM SPSS Statistics, and domain-specific result workbooks assembled from those outputs. **This component begins with those prepared result workbooks.** Its focus is the subsequent Excel-based data shaping, analytical reporting and visualization—not claiming that Excel performed the original SPSS tests or clustering.

*Part of the broader [Rajshahi Air Pollution research portfolio](../README.md).*

## Workflow and workbook design

```text
Prepared domain-result workbooks (SPSS-derived and data-quality summaries)
                  │
                  ▼
      source_data/ + Setup/ProjectFolder
                  │
                  ▼
      Power Query imports and transformations
      • extract relevant result blocks
      • promote headers, select/rename columns, set data types
      • separate source/reference queries from final output tables
                  │
                  ▼
      Structured tables in Data_D01–Data_D05
                  │
                  ▼
      Excel formulas, PivotTables and chart data
                  │
                  ▼
      D01–D05 reporting dashboards
      • slicer-driven views where useful
      • linked KPIs, titles, units and statistical summaries
```

The workbook separates **data and query outputs**, **supporting calculations/PivotTables**, and **presentation dashboards**. I use Connection Only for intermediate queries where worksheet output is unnecessary, and load cleaned reporting tables to designated supporting sheets. The saved workbook contains **5 dashboards, 12 worksheets, 40 Power Query definitions, 25 Excel Tables, 9 PivotTables, 16 charts (including 9 PivotCharts), and 6 slicers**.

## The five dashboards

| Dashboard | What it communicates | Excel implementation |
|---|---|---|
| **D01 — Data Readiness** (`D01_Readiness`) | Monitoring coverage, pollutant completeness, Core4/All6 screening and the retained analytical sample | Power Query coverage table, formula-based coverage KPIs, PivotTables, charts and year filtering |
| **D02 — Temporal Analytics** (`D02_Temporal`) | Annual, seasonal and pooled monthly pollutant variation, plus Kruskal–Wallis and adjusted pairwise results from SPSS | PivotCharts, independent pollutant selections, structured-reference and multi-condition `XLOOKUP`, dynamic-array `FILTER`, responsive labels |
| **D03 — Multivariate Analysis** (`D03_Multivariate`) | Raw versus log-transformed distribution diagnostics, Pearson/Spearman relationships and PCA suitability | Query-shaped statistical tables, comparison charts, pollutant-pair filtering, numerical display formulas and a clear PCA decision |
| **D04 — Pollution Regimes** (`D04_Regimes`) | Retained three-regime classification, standardized cluster centers, pollutant profiles and k=3 versus k=4 redistribution | Linked regime KPIs, calculated percentages, a pollutant-controlled PivotChart, dynamic units and stacked comparisons |
| **D05 — Regime Dynamics** (`D05_Dynamics`) | Annual, seasonal and monthly regime composition, temporal association and consecutive-regime episode summaries | Six compact source tables, three 100% stacked composition charts and `XLOOKUP`-linked statistical/persistence panels |

The workbook reports **723 retained Core4 days** in 2022–2024. In the retained k=3 classification, R1 accounts for 304 days, R2 for 284 and R3 for 135. D03 records an overall KMO of approximately **0.499**, so PCA was evaluated but **not retained**. D05 presents **187 regime episodes**, together with the imported year/season association statistics. These are findings carried forward from the earlier analytical stages, rather than recalculated from raw monitoring observations in this workbook.

## Excel 365 techniques demonstrated

### Power Query and reusable reporting tables

- **Multiple-file import:** `Excel.Workbook` and `File.Contents` read six prepared analytical-result files from `source_data/`.
- **Relative paths:** the `ProjectFolder` named range points to `Setup!B2`, allowing source references to follow the workbook folder rather than one fixed Windows location.
- **Extraction and cleaning of results:** `Table.Skip`, `Table.FirstN`, `Table.SelectRows`, `Table.SelectColumns`, `Table.RemoveColumns`, `Table.PromoteHeaders` and `Table.TransformColumnTypes` isolate relevant sections, remove unnecessary rows/columns and assign correct types.
- **Reporting transformations:** `Table.AddColumn`, `Table.RenameColumns` and `Table.ReplaceValue` support ordering, standardized labels and readable result tables.
- **Query dependencies and loading:** reusable source/reference queries feed final Excel Tables. D05's six outputs are loaded to one `Data_D05_Dynamics` sheet rather than six additional tabs.

A representative source pattern is:

```powerquery
ProjectFolder = Excel.CurrentWorkbook(){[Name="ProjectFolder"]}[Content]{0}[Column1],
Source = Excel.Workbook(
    File.Contents(ProjectFolder & "source_data\04_regime_analysis_results.xlsx"),
    null, true
),
```

### Formulas, calculations and analytical retrieval

| Technique | How I used it | Workbook evidence |
|---|---|---|
| **Aggregation and ratios** — `SUM` | Calculate coverage and total classified days using structured or linked source ranges | `D01_Readiness!O5`; `D04_Regimes!B6` |
| **Single-criterion lookup** — `XLOOKUP` | Retrieve pollutant-specific descriptive values or named statistical results | D02 baseline summary; D05 association and persistence panels |
| **Multi-condition lookup** — `XLOOKUP` with logical criteria | Match both temporal scale and selected pollutant to the corresponding SPSS-derived test statistic/effect size | `D02_Temporal!V28:AB29` |
| **Dynamic-array filtering** — `FILTER` | Display only the relevant adjusted pairwise comparisons for independent annual/seasonal selections | `D02_Temporal!R33`, `X33` |
| **Conditional results and error handling** — `IF`, `IFERROR`, `VALUE`, `TEXT` | Convert imported p-value text/numbers and generate readable significance summaries | D02 pairwise result panels |
| **Numeric and text presentation** — `ROUND`, `TEXT`, concatenation (`&`) | Format diagnostics and build linked count/percentage KPI labels | D03 diagnostics; `D04_Regimes!H6`, `N6`, `T6` |
| **Dynamic unit selection** — `IF`, `ISNUMBER`, `SEARCH` | Update pollutant concentration units when the selected pollutant changes | `Data_D04_Regimes!AM10` |
| **Workbook-relative path formula** — `CELL`, `LEFT`, `FIND` | Derive the current saved workbook folder for Power Query | `Setup!B2` |
| **Structured and anchored references** | Keep formulas understandable and selection cells stable while linking source tables to dashboard outputs | D01–D05 |

Selected formulas from the workbook:

**Core4 coverage** — `D01_Readiness!O5`

```excel
=SUM(tbl_D01_Coverage[Core4_Pass_Days])/SUM(tbl_D01_Coverage[Calendar_Days])
```

**Two-condition statistical lookup** — `D02_Temporal!V28`

```excel
=XLOOKUP(1,(tbl_D02_KruskalWallis[Temporal_Scale]="Annual")*(tbl_D02_KruskalWallis[Pollutant]=Data_D02_Temporal!$BT$1),tbl_D02_KruskalWallis[Kruskal_Wallis_H],"N/A")
```

**Dynamic regime count and percentage** — `D04_Regimes!H6`

```excel
=Data_D04_Regimes!K2&" ("&TEXT(Data_D04_Regimes!K2/$B$6,"0.0%")&")"
```

**Named-result lookup** — `D05_Dynamics!F31`

```excel
=XLOOKUP("Pearson Chi-Square",Data_D05_Dynamics!AE:AE,Data_D05_Dynamics!AF:AF)
```

Aggregation uses `SUM` and PivotTable summaries, while the original SPSS statistics are imported rather than recalculated in Excel.

### PivotTables, PivotCharts and interactive reporting

I use PivotTables to summarize imported reporting fields by time period or pollutant, and PivotCharts to make those summaries explorable. Slicers support year, pollutant and pollutant-pair selections where applicable. Formula-linked chart titles, units and KPI displays respond to the corresponding selections, including D02's independent annual/seasonal controls and D04's concentration-profile selector. D05 deliberately retains all three regimes in its 100% stacked charts so temporal composition remains directly comparable instead of being filtered by a slicer.

## File structure

```text
Excel_365_Analytics/
├── README.md
├── Rajshahi_Air_Pollution_Excel365_Analytics.xlsx
└── source_data/
    ├── data_quality_summary.xlsx
    ├── pollutant_baseline_results.xlsx
    ├── temporal_pollutant_results.xlsx
    ├── multivariate_structure_assessment.xlsx
    ├── 04_regime_analysis_results.xlsx
    └── 05_regime_temporal_results.xlsx
```

The `source_data` files contain the prepared summaries and analytical outputs used by Power Query. The original datasets, cleaning records and SPSS project files are organized in the parent research portfolio.

## How to use the workbook

1. **Download the complete `Excel_365_Analytics` folder**, keeping the six workbooks inside `source_data/` next to the main `.xlsx` file. Do not move the workbook alone if you intend to refresh it.
2. **Open `Rajshahi_Air_Pollution_Excel365_Analytics.xlsx` in Microsoft Excel 365 desktop.** The saved dashboards can be inspected immediately; GitHub's file preview does not reproduce their Excel interactivity.
3. **Explore `D01_Readiness` through `D05_Dynamics`.** Use the available slicers to change the relevant year, pollutant or pollutant pair; observe the linked charts, titles, units and summary values. D05's composition views are intentionally unfiltered.
4. **To refresh**, confirm that `Setup!B2` shows the workbook's current folder and that `source_data/` contains all six files. If needed, save the workbook and press **Ctrl + Alt + F9** to recalculate, then select **Data → Refresh All**.
5. **After refreshing**, check that queries finish without errors and review the dashboard outputs. Keep the workbook and `source_data/` together when relocating the project.

The dashboards present analysis from available screened monitoring days; percentages within D05's annual/seasonal/monthly charts use their respective period totals. Statistical associations are not causal claims, and episode summaries follow the definitions used in the upstream analysis.
