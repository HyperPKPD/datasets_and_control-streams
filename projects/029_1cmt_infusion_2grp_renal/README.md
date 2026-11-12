# nlmx generated project

**Model:** 1-compartment IV infusion. **Truth:** CL 3.2, V 42; IIV CL 30%, V 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 2 treatment group(s) (Group 1: 50 subjects, dose 100; Group 2: 50 subjects, dose 200); 1 dose(s) every 24 h; 100 subjects; samples at [0.5, 1.0, 1.25, 1.5, 2.0, 4.0, 8.0, 12.0, 24.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.9, V ∝ (WT/70)^0.8.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -652.866.
- `models/run102` — the true covariate model with its effects estimated, OFV -782.507: CL~EGFR 0.9878 (truth 0.9), V~WT 0.9066 (truth 0.8).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
