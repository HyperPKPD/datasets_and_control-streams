# nlmx generated project

**Model:** 2-compartment IV infusion. **Truth:** CL 3.2, V1 42, Q 5, V2 80; IIV CL 30%, V1 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 5 treatment group(s) (Group 1: 10 subjects, dose 50; Group 2: 10 subjects, dose 100; Group 3: 20 subjects, dose 200; Group 4: 30 subjects, dose 400; Group 5: 40 subjects, dose 800); 1 dose(s) every 24 h; 110 subjects; samples at [0.5, 1.0, 1.25, 1.5, 2.0, 4.0, 8.0, 12.0, 24.0, 48.0, 72.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.6, CL ∝ (WT/70)^0.75, V1 ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -475.803.
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base); every file name ends with the run and its role, for example `gof_dv_pred_run101_base.png`.
- `nlmx.covar`, `nlmx.vpc` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
```
