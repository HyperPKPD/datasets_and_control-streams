# nlmx generated project

**Model:** 1-compartment oral (first-order absorption). **Truth:** CL 0.6, V 70, KA 0.8; IIV CL 30%, V 25%; residual error proportional 15% + additive SD 0.02.

**Design:** 3 treatment group(s) (Group 1: 34 subjects, dose 10; Group 2: 33 subjects, dose 20; Group 3: 33 subjects, dose 40); 1 dose(s) every 24 h; 100 subjects; samples at [1.0, 2.0, 4.0, 8.0, 24.0, 48.0, 72.0, 120.0, 168.0, 240.0] h.

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.6, CL ∝ (WT/70)^0.75, V ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -5158.078.
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base); every file name ends with the run and its role, for example `gof_dv_pred_run101_base.png`.
- `nlmx.covar`, `nlmx.vpc` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
```
