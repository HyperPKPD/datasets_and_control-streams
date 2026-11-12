# nlmx generated project

**Model:** 2-compartment IV infusion. **Truth:** CL 6, V1 20, Q 8, V2 25; IIV CL 30%, V1 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 5 treatment group(s) (Group 1: 20 subjects, dose 500; Group 2: 20 subjects, dose 750; Group 3: 20 subjects, dose 1000; Group 4: 20 subjects, dose 1500; Group 5: 20 subjects, dose 2000); 9 dose(s) every 8 h; 100 subjects; 4 samples per subject drawn from [0.5, 1.0, 2.0, 4.0, 6.0, 8.0] h. LLOQ 0.5 (BLQ = 1, MDV = 1).

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (CRCL/95)^0.85, V1 ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV 1612.588.
- `models/run102` — the true covariate model with its effects estimated, OFV 1515.065: CL~CRCL 0.8872 (truth 0.85), V1~WT 0.9805 (truth 1).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
