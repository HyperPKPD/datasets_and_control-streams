# nlmx generated project

**Model:** 2-compartment oral (first-order absorption) with lag time. **Truth:** CL 4, V2 40, Q 4, V3 60, KA 1.3, ALAG1 0.4; IIV CL 35%, V2 25%, Q 25%, V3 30%, KA 45%; residual error proportional 18% + additive SD 0.01.

**Design:** 6 treatment group(s) (A: 15 subjects, dose 10; B: 15 subjects, dose 20; C: 20 subjects, dose 40; D: 20 subjects, dose 80; E: 25 subjects, dose 160; F: 25 subjects, dose 320); 10 dose(s) every 12 h; 120 subjects; 5 samples per subject drawn from [0.5, 1.0, 1.5, 2.0, 3.0, 4.0, 6.0, 8.0, 12.0] h. LLOQ 0.05 (BLQ = 1, MDV = 1).

**Covariates:** WT, AGE, SEX, EGFR, CRCL (CRCL is a near-copy of EGFR). True effects: CL ∝ (EGFR/95)^0.5, CL ∝ (WT/70)^0.75, KA ∝ (AGE/45)^-0.2, V2 ∝ (WT/70)^1.

Files:

- `data/analysis.csv` — the simulated dataset (GROUP and DOSE identify the treatment group; `groups.csv` has the names);
- `truth.ctl` — the model the data were simulated from (with the covariate effects);
- `models/run101` — base model (no covariates), OFV -802.760.
- `models/run102` — the true covariate model with its effects estimated, OFV -912.849: CL~EGFR 0.5197 (truth 0.5), CL~WT 0.7226 (truth 0.75), KA~AGE -0.2084 (truth -0.2), V2~WT 1.0013 (truth 1).
- `gof/` — goodness-of-fit plots (DV vs PRED, DV vs IPRED, CWRES vs TIME, CWRES vs PRED, IWRES vs IPRED; PNG; `--plot-format svg` or `both` also writes `svg/`) of run101 (base) and run102 (truth); every file name ends with the run and its role, for example `gof_dv_pred_run102_truth.png`.
- `nlmx.covar`, `nlmx.vpc`, `nlmx.forest` — ready configurations;
- `nlmx.gen` — the design, to generate the project again.

```
nlmx cov      -c nlmx.covar                  # covariate analysis of run101
nlmx vpc      -c nlmx.vpc --plots              # predictive check of the base model
nlmx fit      models/run101.ctl               # refit the base model
nlmx forest   -c nlmx.forest                   # forest plot of the covariate model run102
```
