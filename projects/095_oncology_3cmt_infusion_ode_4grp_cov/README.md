# nlmx generated project

**Model:** 3-compartment IV infusion, $DES (ADVAN13). **Truth:** CL 3.2, V 42, Q 5, VP 80, Q2 1.5, VP2 120; IIV CL 30%, V 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 4 treatment group(s) (Group 1: 25 subjects, dose 100; Group 2: 25 subjects, dose 150; Group 3: 25 subjects, dose 200; Group 4: 25 subjects, dose 250); 3 dose(s) every 504 h; 100 subjects; samples at [0.5, 1.0, 2.0, 4.0, 8.0, 24.0, 72.0, 168.0, 504.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (AGE/45)^-0.2, CL ∝ (WT/70)^0.75, V ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -5051.911.
- `models/run102` — the true covariate model with its effects estimated, OFV -5158.255: CL~AGE -0.2311 (truth -0.2), CL~WT 0.728 (truth 0.75), V~WT 1.0626 (truth 1).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
