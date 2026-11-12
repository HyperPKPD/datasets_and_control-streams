# nlmx generated project

**Model:** 3-compartment oral (first-order absorption) with lag time, $DES (ADVAN13). **Truth:** CL 3.2, V 42, Q 5, VP 80, Q2 1.5, VP2 120, KA 1.1, ALAG1 0.5; IIV CL 30%, V 25%, KA 40%; residual error proportional 15% + additive SD 0.02.

**Design:** 6 treatment group(s) (A: 15 subjects, dose 10; B: 15 subjects, dose 20; C: 15 subjects, dose 40; D: 15 subjects, dose 80; E: 15 subjects, dose 160; F: 15 subjects, dose 320); 7 dose(s) every 24 h; 90 subjects; 6 samples per subject drawn from [0.5, 1.0, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0, 24.0] h. LLOQ 0.02 (BLQ = 1, MDV = 1).

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (AGE/45)^-0.2, CL ∝ (EGFR/95)^0.6, CL × 0.85 for SEX = 1, CL ∝ (WT/70)^0.75, V ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -1385.842.
- `models/run102` — the true covariate model with its effects estimated, OFV -1442.801: CL~AGE -0.28 (truth -0.2), CL~EGFR 0.4081 (truth 0.6), CL~SEX -0.0525 (truth -0.15), CL~WT 0.7643 (truth 0.75), V~WT 0.8105 (truth 1).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
