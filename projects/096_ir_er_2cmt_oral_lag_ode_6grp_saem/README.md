# nlmx generated project

**Model:** 2-compartment oral (first-order absorption) with lag time, $DES (ADVAN13). **Truth:** CL 3.2, V 42, Q 5, VP 80, KA 1.1, ALAG1 0.5; IIV CL 30%, V 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 6 treatment group(s) (Group 1: 12 subjects, dose 10; Group 2: 12 subjects, dose 20; Group 3: 12 subjects, dose 40; Group 4: 12 subjects, dose 80; Group 5: 12 subjects, dose 160; Group 6: 12 subjects, dose 320); 1 dose(s) every 24 h; 72 subjects; 6 samples per subject drawn from [0.5, 1.0, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0, 24.0, 48.0, 72.0] h. Estimation method: SAEM.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.6, CL ∝ (WT/70)^0.75, V ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -1662.521.
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base); every file name ends with the run and its role, for example `gof_dv_pred_run101_base.png`.
- `nlmx.covar`, `nlmx.vpc` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
```
