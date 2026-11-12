# nlmx generated project

**Model:** 1-compartment IV bolus. **Truth:** CL 3.2, V 42; IIV CL 30%, V 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 5 treatment group(s) (Group 1: 20 subjects, dose 20; Group 2: 20 subjects, dose 40; Group 3: 20 subjects, dose 80; Group 4: 20 subjects, dose 160; Group 5: 20 subjects, dose 320); 1 dose(s) every 24 h; 100 subjects; samples at [0.083, 0.25, 0.5, 1.0, 2.0, 4.0, 8.0, 12.0, 24.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.7.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -1530.811.
- `models/run102` — the true covariate model with its effects estimated, OFV -1569.423: CL~EGFR 0.7157 (truth 0.7).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
