# nlmx generated project

**Model:** 2-compartment oral (first-order absorption). **Truth:** CL 3.2, V2 42, Q 5, V3 80, KA 1.1; IIV CL 30%, V2 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 4 treatment group(s) (Group 1: 25 subjects, dose 25; Group 2: 25 subjects, dose 50; Group 3: 25 subjects, dose 100; Group 4: 25 subjects, dose 200); 1 dose(s) every 24 h; 100 subjects; samples at [0.5, 1.0, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0, 24.0, 48.0, 72.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.2, CL ∝ (WT/70)^0.3, V2 ∝ (WT/70)^0.3.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -3849.046.
- `models/run102` — the true covariate model with its effects estimated, OFV -3859.840: CL~EGFR 0.207 (truth 0.2), CL~WT 0.2425 (truth 0.3), V2~WT 0.2489 (truth 0.3).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
