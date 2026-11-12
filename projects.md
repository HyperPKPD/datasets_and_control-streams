# The 100 benchmark projects

Every project in this collection is made by one `nlmx generate` command. This page lists the 100 commands, from the simplest design to the most complex, with what each one mirrors. Run them from this folder (`benchmarks/`); each writes its own folder under `projects/`.

## Problem statement

Population PK methods and software are hard to compare and hard to teach because realistic test projects are scarce. Real clinical datasets cannot be shared. Published examples are few, they come in different formats, and the true parameter values behind them are unknown, so an estimate cannot be judged right or wrong. Most of them also cover only the easy cases: a one- or two-compartment oral model with rich sampling and no censoring.

An analyst who wants to know whether an estimation method recovers the truth, whether a covariate search finds the real effects and rejects the false ones, or whether a workflow survives sparse sampling, BLQ data, repeated dosing and differential-equation models needs many projects that:

* span the structures met in practice: one, two and three compartments; oral (with and without a lag), IV bolus and infusion; analytic ADVANs and the same systems written as `$DES`;
* span the designs: 2 to 6 treatment groups, 8 to 400 subjects per arm (balanced and unbalanced), single and repeated dosing (QD, BID, q8h, q3w), rich and sparse sampling, LLOQ censoring;
* span the variability and error structures: additive, proportional and combined residual error; low and high IIV; random effects on absorption and distribution;
* carry **known true covariate effects** (weight, age, sex, eGFR, and CRCL as a near-copy of eGFR), including none at all and effects too weak to detect;
* are fitted with each estimation method (FO, FOCE, FOCE-I, Laplace, SAEM), so the methods can be compared on identical data;
* are complete and reproducible: dataset, true model, fitted NONMEM control streams with their `.ext`/`.cov`/`.phi`, goodness-of-fit plots, and ready settings for the next analysis steps, all regenerated bit for bit from one command and a seed.

These 100 commands provide that. Each project has a fixed seed and a named author, so its files are identical wherever and whenever it is generated.

## How the commands are built

* **Output.** `--output projects/NNN_description`: the number orders the projects from simplest to most complex, and the description names the structure, the route, the number of groups and the main feature.
* **Groups.** Every project has 2 to 6 treatment groups (`--groups`, `--doses`, and sometimes `--group-names` and `--subjects-per-group`).
* **Goodness-of-fit plots.** Every command has `--gof-plots`. The plots of the base model go to `gof/`, and those of the true covariate model too when `--covariate-model` is given. With `--plot-format both` they are also written as SVG in `gof/svg/`.
* **Author.** Every project has its own randomly generated author (`--author`), named in the header of each control stream.
* **Seed.** `--seed 20261001` to `--seed 20261100`, so the data of every project differ.
* **Quoting.** Every list is in double quotes (`--doses "50,100"`), so each command works unchanged in Windows `cmd`, PowerShell and bash (PowerShell reads an unquoted `50,100` as a list, not as one value).
* **Units.** Doses are amounts (mg), times are hours and concentrations are mg/L, so clearances are in L/h and volumes in L. When `--typical` is not given, the true values are CL 3.2, V 42, Q 5, VP 80, Q2 1.5, VP2 120, KA 1.1 and ALAG 0.5. The default IIV is 30 % on CL and 25 % on V, and the default covariate effects are CL~WT 0.75, V~WT 1 and CL~EGFR 0.6.

## Before you run them

* `nlmx` must be on your `PATH`. Otherwise replace `nlmx` with the full path to the executable, for example `..\target\release\nlmx.exe`.
* Run the commands from the `benchmarks/` folder.
* `generate` refuses to write into a folder that is not empty. To make a project again, delete its folder first, or add `--overwrite` to its command.
* All 100 commands were run with nlmx before this page was written (versions 4.18.3 to 4.18.6, whose program code is identical). Each one finished with exit code 0, fitted its models and wrote its goodness-of-fit plots. Together they took 23 minutes on two CPU cores. Most projects take a few seconds; the slowest are 098 (119 s), 070 (112 s), 100 (70 s), 096 (70 s), 099 (68 s). The run time of each project is given below.
* `run.R` reads this page and runs the 100 commands one by one (`Rscript run.R`, or `Rscript run.R 1 5 12` for some of them). It skips projects whose folder already exists, keeps the output of each command in `logs/` and writes `run_summary.csv`. `run_all.ps1` (PowerShell) and `run_all.sh` (bash) do the same without R.

## Overview

| # | Project | Structure | Groups | Subjects | Doses/subject | Method | Run time |
|---|---|---|---|---|---|---|---|
| 001 | [`001_1cmt_oral_2grp_minimal`](#001_1cmt_oral_2grp_minimal) | 1cmt-oral | 2 | 100 | 1 | foce-i | 2 s |
| 002 | [`002_1cmt_oral_3grp_large_n`](#002_1cmt_oral_3grp_large_n) | 1cmt-oral | 3 | 900 | 1 | foce-i | 20 s |
| 003 | [`003_1cmt_oral_2grp_proportional_error`](#003_1cmt_oral_2grp_proportional_error) | 1cmt-oral | 2 | 100 | 1 | foce-i | 2 s |
| 004 | [`004_1cmt_oral_2grp_additive_error`](#004_1cmt_oral_2grp_additive_error) | 1cmt-oral | 2 | 100 | 1 | foce-i | 2 s |
| 005 | [`005_1cmt_oral_4grp_unbalanced`](#005_1cmt_oral_4grp_unbalanced) | 1cmt-oral | 4 | 84 | 1 | foce-i | 2 s |
| 006 | [`006_1cmt_oral_3grp_fast_absorption`](#006_1cmt_oral_3grp_fast_absorption) | 1cmt-oral | 3 | 100 | 1 | foce-i | 3 s |
| 007 | [`007_1cmt_oral_3grp_flip_flop`](#007_1cmt_oral_3grp_flip_flop) | 1cmt-oral | 3 | 100 | 1 | foce-i | 4 s |
| 008 | [`008_1cmt_oral_2grp_ka_variability`](#008_1cmt_oral_2grp_ka_variability) | 1cmt-oral | 2 | 100 | 1 | foce-i | 6 s |
| 009 | [`009_1cmt_oral_5grp_high_clearance`](#009_1cmt_oral_5grp_high_clearance) | 1cmt-oral | 5 | 100 | 1 | foce-i | 3 s |
| 010 | [`010_1cmt_oral_3grp_long_half_life`](#010_1cmt_oral_3grp_long_half_life) | 1cmt-oral | 3 | 100 | 1 | foce-i | 2 s |
| 011 | [`011_1cmt_oral_2grp_no_covariates`](#011_1cmt_oral_2grp_no_covariates) | 1cmt-oral | 2 | 100 | 1 | foce-i | 3 s |
| 012 | [`012_1cmt_oral_6grp_wide_dose_range`](#012_1cmt_oral_6grp_wide_dose_range) | 1cmt-oral | 6 | 90 | 1 | foce-i | 2 s |
| 013 | [`013_1cmt_oral_lag_3grp`](#013_1cmt_oral_lag_3grp) | 1cmt-oral-lag | 3 | 100 | 1 | foce-i | 10 s |
| 014 | [`014_1cmt_oral_4grp_qd_7days`](#014_1cmt_oral_4grp_qd_7days) | 1cmt-oral | 4 | 100 | 7 | foce-i | 5 s |
| 015 | [`015_1cmt_oral_3grp_bid_steady_state`](#015_1cmt_oral_3grp_bid_steady_state) | 1cmt-oral | 3 | 100 | 14 | foce-i | 8 s |
| 016 | [`016_1cmt_oral_3grp_sparse_3`](#016_1cmt_oral_3grp_sparse_3) | 1cmt-oral | 3 | 180 | 1 | foce-i | 2 s |
| 017 | [`017_1cmt_oral_4grp_blq`](#017_1cmt_oral_4grp_blq) | 1cmt-oral | 4 | 100 | 1 | foce-i | 2 s |
| 018 | [`018_1cmt_oral_2grp_low_variability`](#018_1cmt_oral_2grp_low_variability) | 1cmt-oral | 2 | 100 | 1 | foce-i | 7 s |
| 019 | [`019_1cmt_iv_bolus_2grp_large_n`](#019_1cmt_iv_bolus_2grp_large_n) | 1cmt-iv | 2 | 600 | 1 | foce-i | 10 s |
| 020 | [`020_1cmt_iv_bolus_3grp_proportional`](#020_1cmt_iv_bolus_3grp_proportional) | 1cmt-iv | 3 | 100 | 1 | foce-i | 1 s |
| 021 | [`021_1cmt_iv_bolus_4grp_q8h`](#021_1cmt_iv_bolus_4grp_q8h) | 1cmt-iv | 4 | 100 | 9 | foce-i | 4 s |
| 022 | [`022_1cmt_infusion_2grp_1h`](#022_1cmt_infusion_2grp_1h) | 1cmt-infusion | 2 | 100 | 1 | foce-i | 2 s |
| 023 | [`023_1cmt_infusion_3grp_aminoglycoside`](#023_1cmt_infusion_3grp_aminoglycoside) | 1cmt-infusion | 3 | 100 | 1 | foce-i | 2 s |
| 024 | [`024_1cmt_infusion_4grp_4h`](#024_1cmt_infusion_4grp_4h) | 1cmt-infusion | 4 | 100 | 1 | foce-i | 3 s |
| 025 | [`025_1cmt_infusion_5grp_q12h`](#025_1cmt_infusion_5grp_q12h) | 1cmt-infusion | 5 | 100 | 6 | foce-i | 4 s |
| 026 | [`026_1cmt_iv_bolus_6grp_sparse_blq`](#026_1cmt_iv_bolus_6grp_sparse_blq) | 1cmt-iv | 6 | 120 | 1 | foce-i | 1 s |
| 027 | [`027_1cmt_infusion_3grp_additive`](#027_1cmt_infusion_3grp_additive) | 1cmt-infusion | 3 | 100 | 1 | foce-i | 1 s |
| 028 | [`028_1cmt_iv_bolus_3grp_sex_effect`](#028_1cmt_iv_bolus_3grp_sex_effect) | 1cmt-iv | 3 | 100 | 1 | foce-i | 2 s |
| 029 | [`029_1cmt_infusion_2grp_renal`](#029_1cmt_infusion_2grp_renal) | 1cmt-infusion | 2 | 100 | 1 | foce-i | 5 s |
| 030 | [`030_1cmt_iv_bolus_4grp_age_effect`](#030_1cmt_iv_bolus_4grp_age_effect) | 1cmt-iv | 4 | 100 | 1 | foce-i | 2 s |
| 031 | [`031_2cmt_oral_2grp_large_n`](#031_2cmt_oral_2grp_large_n) | 2cmt-oral | 2 | 600 | 1 | foce-i | 29 s |
| 032 | [`032_2cmt_oral_3grp_dose_escalation`](#032_2cmt_oral_3grp_dose_escalation) | 2cmt-oral | 3 | 100 | 1 | foce-i | 4 s |
| 033 | [`033_2cmt_oral_lag_3grp`](#033_2cmt_oral_lag_3grp) | 2cmt-oral-lag | 3 | 100 | 1 | foce-i | 7 s |
| 034 | [`034_2cmt_oral_4grp_qd_multiple`](#034_2cmt_oral_4grp_qd_multiple) | 2cmt-oral | 4 | 100 | 10 | foce-i | 7 s |
| 035 | [`035_2cmt_oral_3grp_peripheral_iiv`](#035_2cmt_oral_3grp_peripheral_iiv) | 2cmt-oral | 3 | 100 | 1 | foce-i | 8 s |
| 036 | [`036_2cmt_oral_5grp_sparse_4`](#036_2cmt_oral_5grp_sparse_4) | 2cmt-oral | 5 | 150 | 1 | foce-i | 3 s |
| 037 | [`037_2cmt_oral_3grp_slow_distribution`](#037_2cmt_oral_3grp_slow_distribution) | 2cmt-oral | 3 | 100 | 1 | foce-i | 4 s |
| 038 | [`038_2cmt_iv_bolus_2grp_large_n`](#038_2cmt_iv_bolus_2grp_large_n) | 2cmt-iv | 2 | 600 | 1 | foce-i | 19 s |
| 039 | [`039_2cmt_iv_bolus_3grp_rich`](#039_2cmt_iv_bolus_3grp_rich) | 2cmt-iv | 3 | 100 | 1 | foce-i | 3 s |
| 040 | [`040_2cmt_iv_bolus_4grp_proportional`](#040_2cmt_iv_bolus_4grp_proportional) | 2cmt-iv | 4 | 100 | 1 | foce-i | 2 s |
| 041 | [`041_2cmt_infusion_3grp_vancomycin_like`](#041_2cmt_infusion_3grp_vancomycin_like) | 2cmt-infusion | 3 | 100 | 8 | foce-i | 4 s |
| 042 | [`042_2cmt_infusion_2grp_mab_single`](#042_2cmt_infusion_2grp_mab_single) | 2cmt-infusion | 2 | 100 | 1 | foce-i | 5 s |
| 043 | [`043_2cmt_infusion_4grp_mab_q3w`](#043_2cmt_infusion_4grp_mab_q3w) | 2cmt-infusion | 4 | 100 | 4 | foce-i | 4 s |
| 044 | [`044_2cmt_oral_6grp_blq`](#044_2cmt_oral_6grp_blq) | 2cmt-oral | 6 | 90 | 1 | foce-i | 4 s |
| 045 | [`045_2cmt_oral_3grp_effect_on_ka`](#045_2cmt_oral_3grp_effect_on_ka) | 2cmt-oral | 3 | 100 | 1 | foce-i | 6 s |
| 046 | [`046_2cmt_oral_4grp_full_allometry`](#046_2cmt_oral_4grp_full_allometry) | 2cmt-oral | 4 | 100 | 1 | foce-i | 5 s |
| 047 | [`047_2cmt_iv_bolus_3grp_additive`](#047_2cmt_iv_bolus_3grp_additive) | 2cmt-iv | 3 | 100 | 1 | foce-i | 2 s |
| 048 | [`048_2cmt_infusion_5grp_unbalanced`](#048_2cmt_infusion_5grp_unbalanced) | 2cmt-infusion | 5 | 110 | 1 | foce-i | 4 s |
| 049 | [`049_2cmt_oral_lag_4grp_bid`](#049_2cmt_oral_lag_4grp_bid) | 2cmt-oral-lag | 4 | 100 | 12 | foce-i | 14 s |
| 050 | [`050_2cmt_oral_2grp_high_iiv`](#050_2cmt_oral_2grp_high_iiv) | 2cmt-oral | 2 | 100 | 1 | foce-i | 4 s |
| 051 | [`051_3cmt_iv_bolus_2grp_large_n`](#051_3cmt_iv_bolus_2grp_large_n) | 3cmt-iv | 2 | 500 | 1 | foce-i | 56 s |
| 052 | [`052_3cmt_iv_bolus_3grp_rich`](#052_3cmt_iv_bolus_3grp_rich) | 3cmt-iv | 3 | 100 | 1 | foce-i | 9 s |
| 053 | [`053_3cmt_infusion_3grp_deep_tissue`](#053_3cmt_infusion_3grp_deep_tissue) | 3cmt-infusion | 3 | 100 | 1 | foce-i | 6 s |
| 054 | [`054_3cmt_infusion_4grp_4h`](#054_3cmt_infusion_4grp_4h) | 3cmt-infusion | 4 | 100 | 1 | foce-i | 11 s |
| 055 | [`055_3cmt_oral_2grp_large_n`](#055_3cmt_oral_2grp_large_n) | 3cmt-oral | 2 | 500 | 1 | foce-i | 62 s |
| 056 | [`056_3cmt_oral_lag_3grp`](#056_3cmt_oral_lag_3grp) | 3cmt-oral-lag | 3 | 100 | 1 | foce-i | 26 s |
| 057 | [`057_3cmt_iv_bolus_5grp_multiple`](#057_3cmt_iv_bolus_5grp_multiple) | 3cmt-iv | 5 | 100 | 5 | foce-i | 24 s |
| 058 | [`058_3cmt_oral_4grp_sparse_blq`](#058_3cmt_oral_4grp_sparse_blq) | 3cmt-oral | 4 | 120 | 1 | foce-i | 10 s |
| 059 | [`059_3cmt_infusion_6grp_covariates`](#059_3cmt_infusion_6grp_covariates) | 3cmt-infusion | 6 | 90 | 1 | foce-i | 9 s |
| 060 | [`060_3cmt_iv_bolus_3grp_low_iiv`](#060_3cmt_iv_bolus_3grp_low_iiv) | 3cmt-iv | 3 | 100 | 1 | foce-i | 9 s |
| 061 | [`061_1cmt_oral_ode_2grp`](#061_1cmt_oral_ode_2grp) | 1cmt-oral ($DES) | 2 | 100 | 1 | foce-i | 4 s |
| 062 | [`062_1cmt_iv_ode_3grp`](#062_1cmt_iv_ode_3grp) | 1cmt-iv ($DES) | 3 | 100 | 1 | foce-i | 3 s |
| 063 | [`063_1cmt_infusion_ode_3grp`](#063_1cmt_infusion_ode_3grp) | 1cmt-infusion ($DES) | 3 | 100 | 1 | foce-i | 5 s |
| 064 | [`064_1cmt_oral_lag_ode_4grp`](#064_1cmt_oral_lag_ode_4grp) | 1cmt-oral-lag ($DES) | 4 | 100 | 1 | foce-i | 8 s |
| 065 | [`065_2cmt_oral_ode_3grp`](#065_2cmt_oral_ode_3grp) | 2cmt-oral ($DES) | 3 | 100 | 1 | foce-i | 10 s |
| 066 | [`066_2cmt_iv_ode_2grp`](#066_2cmt_iv_ode_2grp) | 2cmt-iv ($DES) | 2 | 100 | 1 | foce-i | 6 s |
| 067 | [`067_2cmt_infusion_ode_4grp_multiple`](#067_2cmt_infusion_ode_4grp_multiple) | 2cmt-infusion ($DES) | 4 | 100 | 4 | foce-i | 15 s |
| 068 | [`068_2cmt_oral_lag_ode_5grp_sparse`](#068_2cmt_oral_lag_ode_5grp_sparse) | 2cmt-oral-lag ($DES) | 5 | 125 | 1 | foce-i | 9 s |
| 069 | [`069_3cmt_iv_ode_3grp`](#069_3cmt_iv_ode_3grp) | 3cmt-iv ($DES) | 3 | 100 | 1 | foce-i | 21 s |
| 070 | [`070_3cmt_oral_ode_3grp`](#070_3cmt_oral_ode_3grp) | 3cmt-oral ($DES) | 3 | 100 | 1 | foce-i | 112 s |
| 071 | [`071_3cmt_infusion_ode_6grp`](#071_3cmt_infusion_ode_6grp) | 3cmt-infusion ($DES) | 6 | 90 | 1 | foce-i | 23 s |
| 072 | [`072_2cmt_oral_ode_4grp_blq_bid`](#072_2cmt_oral_ode_4grp_blq_bid) | 2cmt-oral ($DES) | 4 | 100 | 10 | foce-i | 22 s |
| 073 | [`073_1cmt_oral_3grp_fo`](#073_1cmt_oral_3grp_fo) | 1cmt-oral | 3 | 100 | 1 | fo | 1 s |
| 074 | [`074_1cmt_oral_3grp_foce`](#074_1cmt_oral_3grp_foce) | 1cmt-oral | 3 | 100 | 1 | foce | 2 s |
| 075 | [`075_1cmt_oral_3grp_laplace`](#075_1cmt_oral_3grp_laplace) | 1cmt-oral | 3 | 100 | 1 | laplace | 3 s |
| 076 | [`076_1cmt_oral_3grp_saem`](#076_1cmt_oral_3grp_saem) | 1cmt-oral | 3 | 90 | 1 | saem | 23 s |
| 077 | [`077_2cmt_oral_3grp_fo`](#077_2cmt_oral_3grp_fo) | 2cmt-oral | 3 | 100 | 1 | fo | 1 s |
| 078 | [`078_2cmt_iv_3grp_laplace`](#078_2cmt_iv_3grp_laplace) | 2cmt-iv | 3 | 100 | 1 | laplace | 5 s |
| 079 | [`079_2cmt_oral_3grp_saem`](#079_2cmt_oral_3grp_saem) | 2cmt-oral | 3 | 90 | 1 | saem | 44 s |
| 080 | [`080_1cmt_oral_4grp_all_covariates_model`](#080_1cmt_oral_4grp_all_covariates_model) | 1cmt-oral | 4 | 100 | 1 | foce-i | 8 s |
| 081 | [`081_2cmt_oral_3grp_sex_age_model`](#081_2cmt_oral_3grp_sex_age_model) | 2cmt-oral | 3 | 100 | 1 | foce-i | 11 s |
| 082 | [`082_1cmt_iv_5grp_correlated_covariates`](#082_1cmt_iv_5grp_correlated_covariates) | 1cmt-iv | 5 | 100 | 1 | foce-i | 5 s |
| 083 | [`083_2cmt_infusion_4grp_covariate_model_laplace`](#083_2cmt_infusion_4grp_covariate_model_laplace) | 2cmt-infusion | 4 | 100 | 1 | laplace | 12 s |
| 084 | [`084_1cmt_oral_3grp_covariate_model_saem`](#084_1cmt_oral_3grp_covariate_model_saem) | 1cmt-oral | 3 | 90 | 1 | saem | 67 s |
| 085 | [`085_3cmt_iv_3grp_covariate_model`](#085_3cmt_iv_3grp_covariate_model) | 3cmt-iv | 3 | 100 | 1 | foce-i | 27 s |
| 086 | [`086_2cmt_oral_4grp_weak_effects`](#086_2cmt_oral_4grp_weak_effects) | 2cmt-oral | 4 | 100 | 1 | foce-i | 10 s |
| 087 | [`087_1cmt_oral_6grp_vector_plots`](#087_1cmt_oral_6grp_vector_plots) | 1cmt-oral | 6 | 72 | 1 | foce-i | 2 s |
| 088 | [`088_2cmt_iv_2grp_foce_proportional`](#088_2cmt_iv_2grp_foce_proportional) | 2cmt-iv | 2 | 100 | 1 | foce | 3 s |
| 089 | [`089_phase1_sad_2cmt_oral_6grp`](#089_phase1_sad_2cmt_oral_6grp) | 2cmt-oral | 6 | 48 | 1 | foce-i | 2 s |
| 090 | [`090_phase1_mad_2cmt_oral_5grp`](#090_phase1_mad_2cmt_oral_5grp) | 2cmt-oral | 5 | 50 | 14 | foce-i | 4 s |
| 091 | [`091_phase2_1cmt_oral_4grp_sparse_blq`](#091_phase2_1cmt_oral_4grp_sparse_blq) | 1cmt-oral | 4 | 200 | 1 | foce-i | 3 s |
| 092 | [`092_phase3_2cmt_oral_3grp_sparse`](#092_phase3_2cmt_oral_3grp_sparse) | 2cmt-oral | 3 | 300 | 14 | foce-i | 16 s |
| 093 | [`093_icu_antibiotic_2cmt_infusion_5grp`](#093_icu_antibiotic_2cmt_infusion_5grp) | 2cmt-infusion | 5 | 100 | 9 | foce-i | 8 s |
| 094 | [`094_mab_q2w_2cmt_infusion_ode_3grp`](#094_mab_q2w_2cmt_infusion_ode_3grp) | 2cmt-infusion ($DES) | 3 | 100 | 6 | foce-i | 13 s |
| 095 | [`095_oncology_3cmt_infusion_ode_4grp_cov`](#095_oncology_3cmt_infusion_ode_4grp_cov) | 3cmt-infusion ($DES) | 4 | 100 | 3 | foce-i | 61 s |
| 096 | [`096_ir_er_2cmt_oral_lag_ode_6grp_saem`](#096_ir_er_2cmt_oral_lag_ode_6grp_saem) | 2cmt-oral-lag ($DES) | 6 | 72 | 1 | saem | 70 s |
| 097 | [`097_1cmt_oral_lag_ode_5grp_laplace_blq`](#097_1cmt_oral_lag_ode_5grp_laplace_blq) | 1cmt-oral-lag ($DES) | 5 | 100 | 1 | laplace | 10 s |
| 098 | [`098_3cmt_oral_lag_ode_4grp_multiple_blq`](#098_3cmt_oral_lag_ode_4grp_multiple_blq) | 3cmt-oral-lag ($DES) | 4 | 100 | 7 | foce-i | 119 s |
| 099 | [`099_2cmt_oral_lag_6grp_everything`](#099_2cmt_oral_lag_6grp_everything) | 2cmt-oral-lag | 6 | 120 | 10 | foce-i | 68 s |
| 100 | [`100_3cmt_oral_lag_ode_6grp_everything`](#100_3cmt_oral_lag_ode_6grp_everything) | 3cmt-oral-lag ($DES) | 6 | 90 | 7 | foce-i | 70 s |

## A. One-compartment oral models (ADVAN2), single and repeated dosing (001–018)

### 001_1cmt_oral_2grp_minimal

**The smallest design.** Two dose groups, defaults everywhere else: the reference point of the whole collection. Author: Tariq Romano.

```
nlmx generate --output projects/001_1cmt_oral_2grp_minimal --structure 1cmt-oral --groups 2 --doses "50,100" --gof-plots --author "Tariq Romano" --seed 20261001
```

### 002_1cmt_oral_3grp_large_n

**Large dose-escalation study.** Low/mid/high arms with 200, 300 and 400 subjects (900 in all): a large-sample one-compartment oral study. Author: Lucia Larsen.

```
nlmx generate --output projects/002_1cmt_oral_3grp_large_n --structure 1cmt-oral --groups 3 --group-names "Low,Mid,High" --doses "25,50,100" --subjects-per-group "200,300,400" --gof-plots --author "Lucia Larsen" --seed 20261002
```

### 003_1cmt_oral_2grp_proportional_error

**Proportional residual error.** Bioanalytical error that scales with concentration (20 % CV), no additive part. Author: Andres Farouk.

```
nlmx generate --output projects/003_1cmt_oral_2grp_proportional_error --structure 1cmt-oral --groups 2 --doses "100,200" --error proportional --prop-error 20 --gof-plots --author "Andres Farouk" --seed 20261003
```

### 004_1cmt_oral_2grp_additive_error

**Additive residual error.** Constant-variance assay error, typical of a narrow concentration range. Author: Elif Qureshi.

```
nlmx generate --output projects/004_1cmt_oral_2grp_additive_error --structure 1cmt-oral --groups 2 --doses "100,200" --error additive --add-error 0.05 --gof-plots --author "Elif Qureshi" --seed 20261004
```

### 005_1cmt_oral_4grp_unbalanced

**Unbalanced arms.** Four arms of different sizes (12 to 36 subjects), as after an adaptive expansion of the top doses. Author: Hannah Kowalski.

```
nlmx generate --output projects/005_1cmt_oral_4grp_unbalanced --structure 1cmt-oral --groups 4 --doses "10,30,100,300" --subjects-per-group "12,12,24,36" --gof-plots --author "Hannah Kowalski" --seed 20261005
```

### 006_1cmt_oral_3grp_fast_absorption

**Fast absorption.** A rapidly absorbed oral solution (KA 4.5 /h) with dense early sampling to catch the peak. Author: Clara Costa.

```
nlmx generate --output projects/006_1cmt_oral_3grp_fast_absorption --structure 1cmt-oral --groups 3 --doses "40,80,160" --typical "CL=4,V=35,KA=4.5" --sample-times "0.25,0.5,0.75,1,1.5,2,4,8,12,24" --gof-plots --author "Clara Costa" --seed 20261006
```

### 007_1cmt_oral_3grp_flip_flop

**Flip-flop kinetics.** An extended-release product: absorption (KA 0.15 /h) is slower than elimination, so the terminal slope is absorption. Author: Mateo Cruz.

```
nlmx generate --output projects/007_1cmt_oral_3grp_flip_flop --structure 1cmt-oral --groups 3 --doses "100,200,400" --typical "CL=8,V=30,KA=0.15" --iiv "CL=30,V=25,KA=35" --sample-times "1,2,4,8,12,24,36,48,72" --gof-plots --author "Mateo Cruz" --seed 20261007
```

### 008_1cmt_oral_2grp_ka_variability

**Variability on absorption.** Food- and formulation-driven variability: a third random effect on KA (50 % CV). Author: Adaeze Hosseini.

```
nlmx generate --output projects/008_1cmt_oral_2grp_ka_variability --structure 1cmt-oral --groups 2 --doses "100,200" --iiv "CL=30,V=25,KA=50" --gof-plots --author "Adaeze Hosseini" --seed 20261008
```

### 009_1cmt_oral_5grp_high_clearance

**High-clearance drug.** A high-extraction drug (CL 25 L/h, V 120 L) given over a five-level dose range with a short sampling window. Author: Yara Holm.

```
nlmx generate --output projects/009_1cmt_oral_5grp_high_clearance --structure 1cmt-oral --groups 5 --doses "100,200,300,400,500" --typical "CL=25,V=120,KA=2" --sample-times "0.25,0.5,1,1.5,2,3,4,6,8,12" --gof-plots --author "Yara Holm" --seed 20261009
```

### 010_1cmt_oral_3grp_long_half_life

**Long half-life.** A slowly cleared drug (half-life about 80 h) sampled over ten days after a single dose. Author: Greta Fischer.

```
nlmx generate --output projects/010_1cmt_oral_3grp_long_half_life --structure 1cmt-oral --groups 3 --doses "10,20,40" --typical "CL=0.6,V=70,KA=0.8" --sample-times "1,2,4,8,24,48,72,120,168,240" --gof-plots --author "Greta Fischer" --seed 20261010
```

### 011_1cmt_oral_2grp_no_covariates

**No covariate effects.** Variability with no explanation in the covariates: a negative control for covariate searches. Author: Gabriel Weber.

```
nlmx generate --output projects/011_1cmt_oral_2grp_no_covariates --structure 1cmt-oral --groups 2 --doses "50,150" --no-covariate-effects --gof-plots --author "Gabriel Weber" --seed 20261011
```

### 012_1cmt_oral_6grp_wide_dose_range

**Six-arm wide dose range.** A first-in-human single ascending dose range across almost two orders of magnitude. Author: Chiara Goldberg.

```
nlmx generate --output projects/012_1cmt_oral_6grp_wide_dose_range --structure 1cmt-oral --groups 6 --doses "5,10,25,50,100,250" --subjects-per-group 15 --gof-plots --author "Chiara Goldberg" --seed 20261012
```

### 013_1cmt_oral_lag_3grp

**Absorption lag time.** An enteric-coated tablet: absorption starts after a 0.75 h lag. Author: Samuel Costa.

```
nlmx generate --output projects/013_1cmt_oral_lag_3grp --structure 1cmt-oral-lag --groups 3 --doses "50,100,200" --typical "CL=3.5,V=40,KA=1.2,ALAG=0.75" --gof-plots --author "Samuel Costa" --seed 20261013
```

### 014_1cmt_oral_4grp_qd_7days

**Once daily for a week.** Repeated dosing (7 doses every 24 h) with profiles after the first and the last dose. Author: Rosa Osei.

```
nlmx generate --output projects/014_1cmt_oral_4grp_qd_7days --structure 1cmt-oral --groups 4 --doses "25,50,100,200" --n-doses 7 --dose-interval 24 --gof-plots --author "Rosa Osei" --seed 20261014
```

### 015_1cmt_oral_3grp_bid_steady_state

**Twice daily to steady state.** Fourteen doses every 12 h: accumulation and a steady-state profile. Author: Ravi Zhang.

```
nlmx generate --output projects/015_1cmt_oral_3grp_bid_steady_state --structure 1cmt-oral --groups 3 --doses "50,100,200" --n-doses 14 --dose-interval 12 --sample-times "0.5,1,2,3,4,6,8,12" --gof-plots --author "Ravi Zhang" --seed 20261015
```

### 016_1cmt_oral_3grp_sparse_3

**Sparse sampling.** A late-phase design: three random samples per subject, 60 subjects per arm. 3 samples per subject. Author: Chloe Cruz.

```
nlmx generate --output projects/016_1cmt_oral_3grp_sparse_3 --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 60 --sparse-samples 3 --gof-plots --author "Chloe Cruz" --seed 20261016
```

### 017_1cmt_oral_4grp_blq

**Samples below the LLOQ.** An assay with LLOQ 0.1: the late samples of the low doses are BLQ (flagged, MDV = 1). LLOQ 0.1. Author: Mira Navarro.

```
nlmx generate --output projects/017_1cmt_oral_4grp_blq --structure 1cmt-oral --groups 4 --doses "10,25,50,100" --lloq 0.1 --gof-plots --author "Mira Navarro" --seed 20261017
```

### 018_1cmt_oral_2grp_low_variability

**Low variability.** A tightly controlled population (10 % IIV, 5 % residual error): parameters should be recovered closely. Author: Noor Haddad.

```
nlmx generate --output projects/018_1cmt_oral_2grp_low_variability --structure 1cmt-oral --groups 2 --doses "100,200" --iiv "CL=10,V=10" --prop-error 5 --add-error 0.005 --gof-plots --author "Noor Haddad" --seed 20261018
```

## B. One-compartment intravenous models: bolus (ADVAN1) and infusion (019–030)

### 019_1cmt_iv_bolus_2grp_large_n

**IV bolus, large sample.** A bolus into the central compartment, 250 and 350 subjects per arm. Author: Hannah Bauer.

```
nlmx generate --output projects/019_1cmt_iv_bolus_2grp_large_n --structure 1cmt-iv --groups 2 --doses "50,100" --subjects-per-group "250,350" --gof-plots --author "Hannah Bauer" --seed 20261019
```

### 020_1cmt_iv_bolus_3grp_proportional

**IV bolus, proportional error.** Three bolus doses with a purely proportional residual error. Author: Emeka Horvat.

```
nlmx generate --output projects/020_1cmt_iv_bolus_3grp_proportional --structure 1cmt-iv --groups 3 --doses "25,50,100" --error proportional --prop-error 12 --gof-plots --author "Emeka Horvat" --seed 20261020
```

### 021_1cmt_iv_bolus_4grp_q8h

**IV bolus every 8 hours.** Nine bolus doses every 8 h, sampled after the first and the last. Author: Ayumi Hosseini.

```
nlmx generate --output projects/021_1cmt_iv_bolus_4grp_q8h --structure 1cmt-iv --groups 4 --doses "20,40,80,160" --n-doses 9 --dose-interval 8 --sample-times "0.25,0.5,1,2,4,6,8" --gof-plots --author "Ayumi Hosseini" --seed 20261021
```

### 022_1cmt_infusion_2grp_1h

**One-hour infusion.** A one-hour intravenous infusion at two dose levels. Author: Sana Hoffmann.

```
nlmx generate --output projects/022_1cmt_infusion_2grp_1h --structure 1cmt-infusion --groups 2 --doses "100,200" --infusion-duration 1 --gof-plots --author "Sana Hoffmann" --seed 20261022
```

### 023_1cmt_infusion_3grp_aminoglycoside

**Aminoglycoside-like.** A renally cleared antibiotic: 30-min infusion, clearance driven by creatinine clearance. Author: Pavel Park.

```
nlmx generate --output projects/023_1cmt_infusion_3grp_aminoglycoside --structure 1cmt-infusion --groups 3 --doses "240,360,480" --infusion-duration 0.5 --typical "CL=5,V=18" --effects "CL~CRCL=0.8,V~WT=1" --sample-times "0.5,1,2,4,6,8,12,24" --gof-plots --author "Pavel Park" --seed 20261023
```

### 024_1cmt_infusion_4grp_4h

**Four-hour infusion.** A slow infusion (4 h) where the peak is at the end of the infusion. Author: Erik Park.

```
nlmx generate --output projects/024_1cmt_infusion_4grp_4h --structure 1cmt-infusion --groups 4 --doses "100,200,300,400" --infusion-duration 4 --sample-times "1,2,3,4,5,6,8,12,24" --gof-plots --author "Erik Park" --seed 20261024
```

### 025_1cmt_infusion_5grp_q12h

**Infusion every 12 hours.** Six one-hour infusions every 12 h in five dose groups. Author: Gabriel Bello.

```
nlmx generate --output projects/025_1cmt_infusion_5grp_q12h --structure 1cmt-infusion --groups 5 --doses "50,100,150,200,250" --n-doses 6 --dose-interval 12 --infusion-duration 1 --sample-times "0.5,1,2,4,6,8,12" --gof-plots --author "Gabriel Bello" --seed 20261025
```

### 026_1cmt_iv_bolus_6grp_sparse_blq

**Bolus, sparse and BLQ.** Six arms, four random samples each, and an LLOQ that censors the low-dose tails. 4 samples per subject; LLOQ 0.05. Author: Lina Johansson.

```
nlmx generate --output projects/026_1cmt_iv_bolus_6grp_sparse_blq --structure 1cmt-iv --groups 6 --doses "5,10,20,40,80,160" --subjects-per-group 20 --sparse-samples 4 --lloq 0.05 --gof-plots --author "Lina Johansson" --seed 20261026
```

### 027_1cmt_infusion_3grp_additive

**Infusion, additive error.** A one-hour infusion with a constant-variance error model. Author: Kaito Osei.

```
nlmx generate --output projects/027_1cmt_infusion_3grp_additive --structure 1cmt-infusion --groups 3 --doses "100,200,400" --error additive --add-error 0.1 --gof-plots --author "Kaito Osei" --seed 20261027
```

### 028_1cmt_iv_bolus_3grp_sex_effect

**Sex effect on clearance.** Clearance 25 % lower in SEX = 1, on top of allometric weight effects. Author: Jonah Whitfield.

```
nlmx generate --output projects/028_1cmt_iv_bolus_3grp_sex_effect --structure 1cmt-iv --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~SEX=0.75" --gof-plots --author "Jonah Whitfield" --seed 20261028
```

### 029_1cmt_infusion_2grp_renal

**Renally eliminated drug.** Clearance proportional to eGFR, with the true covariate model fitted as run102. true covariate model fitted as run102. Author: Valentina Menon.

```
nlmx generate --output projects/029_1cmt_infusion_2grp_renal --structure 1cmt-infusion --groups 2 --doses "100,200" --effects "CL~EGFR=0.9,V~WT=0.8" --covariate-model --gof-plots --author "Valentina Menon" --seed 20261029
```

### 030_1cmt_iv_bolus_4grp_age_effect

**Age effect on clearance.** Clearance falling with age (exponent -0.4) in an adult population of 18 to 85 years. Author: Tomasz Cruz.

```
nlmx generate --output projects/030_1cmt_iv_bolus_4grp_age_effect --structure 1cmt-iv --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,CL~AGE=-0.4,V~WT=1" --gof-plots --author "Tomasz Cruz" --seed 20261030
```

## C. Two-compartment models (ADVAN3/ADVAN4) (031–050)

### 031_2cmt_oral_2grp_large_n

**Two-compartment oral, large sample.** The standard biexponential oral model with 200 and 400 subjects per arm. Author: Pavel Rahman.

```
nlmx generate --output projects/031_2cmt_oral_2grp_large_n --structure 2cmt-oral --groups 2 --doses "50,100" --subjects-per-group "200,400" --gof-plots --author "Pavel Rahman" --seed 20261031
```

### 032_2cmt_oral_3grp_dose_escalation

**Two-compartment dose escalation.** Low/mid/high arms of a two-compartment drug. Author: Kaito Kapoor.

```
nlmx generate --output projects/032_2cmt_oral_3grp_dose_escalation --structure 2cmt-oral --groups 3 --group-names "Low,Mid,High" --doses "50,100,200" --gof-plots --author "Kaito Kapoor" --seed 20261032
```

### 033_2cmt_oral_lag_3grp

**Two-compartment with lag.** A delayed-release tablet with distribution into a peripheral compartment. Author: Chidi Holm.

```
nlmx generate --output projects/033_2cmt_oral_lag_3grp --structure 2cmt-oral-lag --groups 3 --doses "50,100,200" --gof-plots --author "Chidi Holm" --seed 20261033
```

### 034_2cmt_oral_4grp_qd_multiple

**Two-compartment, once daily.** Ten daily doses with first- and last-dose profiles. Author: Priya Novak.

```
nlmx generate --output projects/034_2cmt_oral_4grp_qd_multiple --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --n-doses 10 --dose-interval 24 --gof-plots --author "Priya Novak" --seed 20261034
```

### 035_2cmt_oral_3grp_peripheral_iiv

**Variability on distribution.** Random effects on Q and VP as well as CL and V. Author: Ingrid Romano.

```
nlmx generate --output projects/035_2cmt_oral_3grp_peripheral_iiv --structure 2cmt-oral --groups 3 --doses "50,100,200" --iiv "CL=30,V=25,Q=30,VP=30" --gof-plots --author "Ingrid Romano" --seed 20261035
```

### 036_2cmt_oral_5grp_sparse_4

**Two-compartment, sparse.** Four random samples per subject across five arms. 4 samples per subject. Author: Linnea MacLeod.

```
nlmx generate --output projects/036_2cmt_oral_5grp_sparse_4 --structure 2cmt-oral --groups 5 --doses "20,40,80,160,320" --subjects-per-group 30 --sparse-samples 4 --gof-plots --author "Linnea MacLeod" --seed 20261036
```

### 037_2cmt_oral_3grp_slow_distribution

**Slow, deep distribution.** A small Q and a large VP: a long distribution phase sampled out to 7 days. Author: Yara Alvarez.

```
nlmx generate --output projects/037_2cmt_oral_3grp_slow_distribution --structure 2cmt-oral --groups 3 --doses "50,100,200" --typical "CL=3,V=30,Q=1,VP=150,KA=1" --sample-times "0.5,1,2,4,8,12,24,48,96,168" --gof-plots --author "Yara Alvarez" --seed 20261037
```

### 038_2cmt_iv_bolus_2grp_large_n

**Two-compartment IV bolus, large sample.** A bolus with a visible distribution phase, 300 subjects per arm. Author: Chiara Tanaka.

```
nlmx generate --output projects/038_2cmt_iv_bolus_2grp_large_n --structure 2cmt-iv --groups 2 --doses "50,100" --subjects-per-group "300,300" --gof-plots --author "Chiara Tanaka" --seed 20261038
```

### 039_2cmt_iv_bolus_3grp_rich

**Rich IV sampling.** Twelve samples per subject, from 5 minutes to 48 hours. Author: Kofi Nakamura.

```
nlmx generate --output projects/039_2cmt_iv_bolus_3grp_rich --structure 2cmt-iv --groups 3 --doses "25,50,100" --sample-times "0.083,0.25,0.5,1,2,4,6,8,12,24,36,48" --gof-plots --author "Kofi Nakamura" --seed 20261039
```

### 040_2cmt_iv_bolus_4grp_proportional

**Two-compartment IV, proportional error.** Four bolus dose levels with a proportional error model. Author: Rosa Kobayashi.

```
nlmx generate --output projects/040_2cmt_iv_bolus_4grp_proportional --structure 2cmt-iv --groups 4 --doses "10,30,100,300" --error proportional --prop-error 15 --gof-plots --author "Rosa Kobayashi" --seed 20261040
```

### 041_2cmt_infusion_3grp_vancomycin_like

**Vancomycin-like.** One-hour infusions every 12 h (8 doses), clearance driven by creatinine clearance. Author: Erik Nilsen.

```
nlmx generate --output projects/041_2cmt_infusion_3grp_vancomycin_like --structure 2cmt-infusion --groups 3 --doses "750,1000,1500" --n-doses 8 --dose-interval 12 --infusion-duration 1 --typical "CL=4,V=30,Q=6,VP=40" --effects "CL~CRCL=0.75,V~WT=1" --sample-times "0.5,1,2,4,6,8,12" --gof-plots --author "Erik Nilsen" --seed 20261041
```

### 042_2cmt_infusion_2grp_mab_single

**Monoclonal antibody, single dose.** Linear mAb kinetics (CL 0.01 L/h, V 3 L) sampled for 8 weeks after a 2-hour infusion. Author: Ngozi Reddy.

```
nlmx generate --output projects/042_2cmt_infusion_2grp_mab_single --structure 2cmt-infusion --groups 2 --doses "200,400" --infusion-duration 2 --typical "CL=0.01,V=3,Q=0.02,VP=2.5" --iiv "CL=35,V=20" --sample-times "1,2,6,24,72,168,336,504,672,1008,1344" --gof-plots --author "Ngozi Reddy" --seed 20261042
```

### 043_2cmt_infusion_4grp_mab_q3w

**Monoclonal antibody every 3 weeks.** Four infusions every 504 h; profiles after the first and the fourth. Author: Wanjiru Yilmaz.

```
nlmx generate --output projects/043_2cmt_infusion_4grp_mab_q3w --structure 2cmt-infusion --groups 4 --doses "100,200,400,800" --n-doses 4 --dose-interval 504 --infusion-duration 1.5 --typical "CL=0.012,V=3.2,Q=0.02,VP=2.8" --iiv "CL=30,V=20" --sample-times "1,24,72,168,336,504" --gof-plots --author "Wanjiru Yilmaz" --seed 20261043
```

### 044_2cmt_oral_6grp_blq

**Six arms with BLQ.** Six oral dose levels; low doses fall below the LLOQ late in the profile. LLOQ 0.05. Author: Henrik Cohen.

```
nlmx generate --output projects/044_2cmt_oral_6grp_blq --structure 2cmt-oral --groups 6 --doses "5,10,20,50,100,200" --subjects-per-group 15 --lloq 0.05 --gof-plots --author "Henrik Cohen" --seed 20261044
```

### 045_2cmt_oral_3grp_effect_on_ka

**Covariate on absorption.** Absorption slowing with age (KA~AGE) besides weight on CL and V. Author: Nadia Ek.

```
nlmx generate --output projects/045_2cmt_oral_3grp_effect_on_ka --structure 2cmt-oral --groups 3 --doses "50,100,200" --iiv "CL=30,V=25,KA=40" --effects "CL~WT=0.75,V~WT=1,KA~AGE=-0.3" --gof-plots --author "Nadia Ek" --seed 20261045
```

### 046_2cmt_oral_4grp_full_allometry

**Full allometry.** Weight on all four disposition parameters (0.75 on clearances, 1 on volumes). Author: Lucia Cohen.

```
nlmx generate --output projects/046_2cmt_oral_4grp_full_allometry --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,V~WT=1,Q~WT=0.75,VP~WT=1" --gof-plots --author "Lucia Cohen" --seed 20261046
```

### 047_2cmt_iv_bolus_3grp_additive

**Two-compartment IV, additive error.** A bolus with a constant-variance error model. Author: Rohan Dahl.

```
nlmx generate --output projects/047_2cmt_iv_bolus_3grp_additive --structure 2cmt-iv --groups 3 --doses "50,100,200" --error additive --add-error 0.05 --gof-plots --author "Rohan Dahl" --seed 20261047
```

### 048_2cmt_infusion_5grp_unbalanced

**Unbalanced infusion arms.** Five infusion arms of 10 to 40 subjects. Author: Astrid Patel.

```
nlmx generate --output projects/048_2cmt_infusion_5grp_unbalanced --structure 2cmt-infusion --groups 5 --doses "50,100,200,400,800" --subjects-per-group "10,10,20,30,40" --infusion-duration 1 --gof-plots --author "Astrid Patel" --seed 20261048
```

### 049_2cmt_oral_lag_4grp_bid

**Lag time, twice daily.** Twelve doses every 12 h of a delayed-release two-compartment drug. Author: Zara Moreau.

```
nlmx generate --output projects/049_2cmt_oral_lag_4grp_bid --structure 2cmt-oral-lag --groups 4 --doses "25,50,100,200" --n-doses 12 --dose-interval 12 --sample-times "0.5,1,1.5,2,3,4,6,8,12" --gof-plots --author "Zara Moreau" --seed 20261049
```

### 050_2cmt_oral_2grp_high_iiv

**High variability, no covariates.** 50 % IIV on CL and 40 % on V, with nothing in the covariates to explain it. Author: Felix Ferreira.

```
nlmx generate --output projects/050_2cmt_oral_2grp_high_iiv --structure 2cmt-oral --groups 2 --doses "100,200" --iiv "CL=50,V=40" --no-covariate-effects --gof-plots --author "Felix Ferreira" --seed 20261050
```

## D. Three-compartment models (ADVAN11/ADVAN12) (051–060)

### 051_3cmt_iv_bolus_2grp_large_n

**Three-compartment IV bolus, large sample.** A triexponential bolus profile, 200 and 300 subjects per arm. Author: Wanjiru Chukwu.

```
nlmx generate --output projects/051_3cmt_iv_bolus_2grp_large_n --structure 3cmt-iv --groups 2 --doses "50,100" --subjects-per-group "200,300" --gof-plots --author "Wanjiru Chukwu" --seed 20261051
```

### 052_3cmt_iv_bolus_3grp_rich

**Three-compartment, rich sampling.** Fourteen samples from 5 minutes to 96 hours resolve all three phases. Author: Chiara Okafor.

```
nlmx generate --output projects/052_3cmt_iv_bolus_3grp_rich --structure 3cmt-iv --groups 3 --doses "25,50,100" --sample-times "0.083,0.25,0.5,1,2,3,4,6,8,12,24,48,72,96" --gof-plots --author "Chiara Okafor" --seed 20261052
```

### 053_3cmt_infusion_3grp_deep_tissue

**Deep tissue compartment.** A short infusion of a drug with a slowly equilibrating deep compartment (VP2 200 L). Author: Chidi Nwosu.

```
nlmx generate --output projects/053_3cmt_infusion_3grp_deep_tissue --structure 3cmt-infusion --groups 3 --doses "100,200,400" --infusion-duration 0.5 --typical "CL=5,V=10,Q=15,VP=30,Q2=1,VP2=200" --sample-times "0.25,0.5,1,2,4,8,12,24,48,72" --gof-plots --author "Chidi Nwosu" --seed 20261053
```

### 054_3cmt_infusion_4grp_4h

**Three-compartment, long infusion.** A four-hour infusion in four dose groups. Author: Bilal Larsen.

```
nlmx generate --output projects/054_3cmt_infusion_4grp_4h --structure 3cmt-infusion --groups 4 --doses "100,200,300,400" --infusion-duration 4 --sample-times "1,2,4,5,6,8,12,24,48" --gof-plots --author "Bilal Larsen" --seed 20261054
```

### 055_3cmt_oral_2grp_large_n

**Three-compartment oral, large sample.** Oral absorption into a three-compartment system, 250 subjects per arm. Author: Ines MacLeod.

```
nlmx generate --output projects/055_3cmt_oral_2grp_large_n --structure 3cmt-oral --groups 2 --doses "100,200" --subjects-per-group "250,250" --gof-plots --author "Ines MacLeod" --seed 20261055
```

### 056_3cmt_oral_lag_3grp

**Three-compartment oral with lag.** Lag, first-order absorption and two peripheral compartments. Author: Leila Meyer.

```
nlmx generate --output projects/056_3cmt_oral_lag_3grp --structure 3cmt-oral-lag --groups 3 --doses "50,100,200" --gof-plots --author "Leila Meyer" --seed 20261056
```

### 057_3cmt_iv_bolus_5grp_multiple

**Three-compartment, repeated bolus.** Five daily bolus doses in five arms. Author: Viktor Ansah.

```
nlmx generate --output projects/057_3cmt_iv_bolus_5grp_multiple --structure 3cmt-iv --groups 5 --doses "20,40,80,160,320" --n-doses 5 --dose-interval 24 --gof-plots --author "Viktor Ansah" --seed 20261057
```

### 058_3cmt_oral_4grp_sparse_blq

**Three-compartment, sparse and BLQ.** Five random samples per subject and an LLOQ of 0.05. 5 samples per subject; LLOQ 0.05. Author: Nora Johansson.

```
nlmx generate --output projects/058_3cmt_oral_4grp_sparse_blq --structure 3cmt-oral --groups 4 --doses "25,50,100,200" --subjects-per-group 30 --sparse-samples 5 --lloq 0.05 --gof-plots --author "Nora Johansson" --seed 20261058
```

### 059_3cmt_infusion_6grp_covariates

**Three-compartment with covariates.** Six infusion arms, weight on clearances and volumes, eGFR on CL. Author: Pedro Fischer.

```
nlmx generate --output projects/059_3cmt_infusion_6grp_covariates --structure 3cmt-infusion --groups 6 --doses "25,50,100,200,300,400" --subjects-per-group 15 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5,VP~WT=1" --gof-plots --author "Pedro Fischer" --seed 20261059
```

### 060_3cmt_iv_bolus_3grp_low_iiv

**Three-compartment, low noise.** 10 % IIV and 8 % proportional error: identifiability with clean data. Author: Yuki Andersson.

```
nlmx generate --output projects/060_3cmt_iv_bolus_3grp_low_iiv --structure 3cmt-iv --groups 3 --doses "50,100,200" --error proportional --prop-error 8 --iiv "CL=10,V=10" --gof-plots --author "Yuki Andersson" --seed 20261060
```

## E. The same systems as differential equations ($DES, ADVAN13) (061–072)

### 061_1cmt_oral_ode_2grp

**One-compartment oral as $DES.** Project 001's model written as differential equations: compare the two. $DES (ADVAN13). Author: Maryam Holm.

```
nlmx generate --output projects/061_1cmt_oral_ode_2grp --structure 1cmt-oral --ode --groups 2 --doses "50,100" --gof-plots --author "Maryam Holm" --seed 20261061
```

### 062_1cmt_iv_ode_3grp

**One-compartment IV bolus as $DES.** A bolus model written as differential equations. $DES (ADVAN13). Author: Ruth Obi.

```
nlmx generate --output projects/062_1cmt_iv_ode_3grp --structure 1cmt-iv --ode --groups 3 --doses "25,50,100" --gof-plots --author "Ruth Obi" --seed 20261062
```

### 063_1cmt_infusion_ode_3grp

**One-compartment infusion as $DES.** A two-hour infusion written as differential equations. $DES (ADVAN13). Author: Tunde Costa.

```
nlmx generate --output projects/063_1cmt_infusion_ode_3grp --structure 1cmt-infusion --ode --groups 3 --doses "100,200,400" --infusion-duration 2 --gof-plots --author "Tunde Costa" --seed 20261063
```

### 064_1cmt_oral_lag_ode_4grp

**Lag model as $DES.** Absorption lag with the system written as differential equations. $DES (ADVAN13). Author: Viktor Petrova.

```
nlmx generate --output projects/064_1cmt_oral_lag_ode_4grp --structure 1cmt-oral-lag --ode --groups 4 --doses "25,50,100,200" --gof-plots --author "Viktor Petrova" --seed 20261064
```

### 065_2cmt_oral_ode_3grp

**Two-compartment oral as $DES.** The standard two-compartment oral model as differential equations. $DES (ADVAN13). Author: Lucia Horvat.

```
nlmx generate --output projects/065_2cmt_oral_ode_3grp --structure 2cmt-oral --ode --groups 3 --doses "50,100,200" --gof-plots --author "Lucia Horvat" --seed 20261065
```

### 066_2cmt_iv_ode_2grp

**Two-compartment IV as $DES.** A two-compartment bolus model as differential equations. $DES (ADVAN13). Author: Fatima Moreau.

```
nlmx generate --output projects/066_2cmt_iv_ode_2grp --structure 2cmt-iv --ode --groups 2 --doses "50,100" --gof-plots --author "Fatima Moreau" --seed 20261066
```

### 067_2cmt_infusion_ode_4grp_multiple

**Two-compartment infusions as $DES.** Four one-hour infusions every 24 h, as differential equations. $DES (ADVAN13). Author: Diego Brooks.

```
nlmx generate --output projects/067_2cmt_infusion_ode_4grp_multiple --structure 2cmt-infusion --ode --groups 4 --doses "50,100,200,400" --n-doses 4 --dose-interval 24 --infusion-duration 1 --gof-plots --author "Diego Brooks" --seed 20261067
```

### 068_2cmt_oral_lag_ode_5grp_sparse

**Two-compartment lag as $DES, sparse.** Five arms, five random samples per subject, written as differential equations. 5 samples per subject; $DES (ADVAN13). Author: Erik Adebayo.

```
nlmx generate --output projects/068_2cmt_oral_lag_ode_5grp_sparse --structure 2cmt-oral-lag --ode --groups 5 --doses "20,40,80,160,320" --subjects-per-group 25 --sparse-samples 5 --gof-plots --author "Erik Adebayo" --seed 20261068
```

### 069_3cmt_iv_ode_3grp

**Three-compartment IV as $DES.** A three-compartment bolus model as differential equations. $DES (ADVAN13). Author: Kwame Kowalski.

```
nlmx generate --output projects/069_3cmt_iv_ode_3grp --structure 3cmt-iv --ode --groups 3 --doses "25,50,100" --gof-plots --author "Kwame Kowalski" --seed 20261069
```

### 070_3cmt_oral_ode_3grp

**Three-compartment oral as $DES.** A three-compartment oral model as differential equations. $DES (ADVAN13). Author: Hye-jin Whitfield.

```
nlmx generate --output projects/070_3cmt_oral_ode_3grp --structure 3cmt-oral --ode --groups 3 --doses "50,100,200" --gof-plots --author "Hye-jin Whitfield" --seed 20261070
```

### 071_3cmt_infusion_ode_6grp

**Three-compartment infusion as $DES.** Six infusion arms, written as differential equations. $DES (ADVAN13). Author: Dmitri Hosseini.

```
nlmx generate --output projects/071_3cmt_infusion_ode_6grp --structure 3cmt-infusion --ode --groups 6 --doses "25,50,100,150,200,300" --subjects-per-group 15 --infusion-duration 1 --gof-plots --author "Dmitri Hosseini" --seed 20261071
```

### 072_2cmt_oral_ode_4grp_blq_bid

**Twice daily with BLQ as $DES.** Ten doses every 12 h, an LLOQ of 0.05, as differential equations. LLOQ 0.05; $DES (ADVAN13). Author: Ingrid Navarro.

```
nlmx generate --output projects/072_2cmt_oral_ode_4grp_blq_bid --structure 2cmt-oral --ode --groups 4 --doses "10,25,50,100" --n-doses 10 --dose-interval 12 --lloq 0.05 --sample-times "0.5,1,2,3,4,6,8,12" --gof-plots --author "Ingrid Navarro" --seed 20261072
```

## F. Estimation methods and true covariate models (073–088)

### 073_1cmt_oral_3grp_fo

**First-order (FO) estimation.** The design of 074-076, fitted by FO: expect the bias of a first-order method. Author: Linnea Okeke.

```
nlmx generate --output projects/073_1cmt_oral_3grp_fo --structure 1cmt-oral --groups 3 --doses "50,100,200" --approximation fo --gof-plots --author "Linnea Okeke" --seed 20261073
```

### 074_1cmt_oral_3grp_foce

**FOCE without interaction.** FOCE (METHOD=1) without INTERACTION, on a proportional-error model where interaction matters. Author: Tomasz Rossi.

```
nlmx generate --output projects/074_1cmt_oral_3grp_foce --structure 1cmt-oral --groups 3 --doses "50,100,200" --error proportional --approximation foce --gof-plots --author "Tomasz Rossi" --seed 20261074
```

### 075_1cmt_oral_3grp_laplace

**Laplace estimation.** The same design fitted by the Laplacian method. Author: Wanjiru Bakari.

```
nlmx generate --output projects/075_1cmt_oral_3grp_laplace --structure 1cmt-oral --groups 3 --doses "50,100,200" --approximation laplace --gof-plots --author "Wanjiru Bakari" --seed 20261075
```

### 076_1cmt_oral_3grp_saem

**SAEM estimation.** The same design fitted by SAEM, with the objective function value by importance sampling. Author: Babajide Holm.

```
nlmx generate --output projects/076_1cmt_oral_3grp_saem --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --approximation saem --gof-plots --author "Babajide Holm" --seed 20261076
```

### 077_2cmt_oral_3grp_fo

**Two-compartment, FO.** A two-compartment oral model fitted by first-order estimation. Author: Chiara Mensah.

```
nlmx generate --output projects/077_2cmt_oral_3grp_fo --structure 2cmt-oral --groups 3 --doses "50,100,200" --approximation fo --gof-plots --author "Chiara Mensah" --seed 20261077
```

### 078_2cmt_iv_3grp_laplace

**Two-compartment IV, Laplace.** A two-compartment bolus model fitted by the Laplacian method. Author: Saoirse Kealoha.

```
nlmx generate --output projects/078_2cmt_iv_3grp_laplace --structure 2cmt-iv --groups 3 --doses "50,100,200" --approximation laplace --gof-plots --author "Saoirse Kealoha" --seed 20261078
```

### 079_2cmt_oral_3grp_saem

**Two-compartment oral, SAEM.** SAEM on a two-compartment oral model with 30 subjects per arm. Author: Camila Hansen.

```
nlmx generate --output projects/079_2cmt_oral_3grp_saem --structure 2cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --approximation saem --gof-plots --author "Camila Hansen" --seed 20261079
```

### 080_1cmt_oral_4grp_all_covariates_model

**Every covariate, true model fitted.** All five covariates carry an effect; run102 is the true covariate model. true covariate model fitted as run102. Author: Kofi Kowalski.

```
nlmx generate --output projects/080_1cmt_oral_4grp_all_covariates_model --structure 1cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6,CL~AGE=-0.3,CL~SEX=0.8" --covariate-model --gof-plots --author "Kofi Kowalski" --seed 20261080
```

### 081_2cmt_oral_3grp_sex_age_model

**Sex and age, true model fitted.** Sex on V and age on CL in a two-compartment drug; run102 is the true model. true covariate model fitted as run102. Author: Chiara Eze.

```
nlmx generate --output projects/081_2cmt_oral_3grp_sex_age_model --structure 2cmt-oral --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.35,V~SEX=0.85" --covariate-model --gof-plots --author "Chiara Eze" --seed 20261081
```

### 082_1cmt_iv_5grp_correlated_covariates

**Correlated covariates.** Only eGFR acts on CL, but CRCL is a near-copy of it: a test of proxy selection. true covariate model fitted as run102. Author: Chiara Sato.

```
nlmx generate --output projects/082_1cmt_iv_5grp_correlated_covariates --structure 1cmt-iv --groups 5 --doses "20,40,80,160,320" --effects "CL~EGFR=0.7" --covariate-model --gof-plots --author "Chiara Sato" --seed 20261082
```

### 083_2cmt_infusion_4grp_covariate_model_laplace

**Covariate model, Laplace.** A true covariate model of an infused drug, fitted by the Laplacian method. true covariate model fitted as run102. Author: Ravi Diallo.

```
nlmx generate --output projects/083_2cmt_infusion_4grp_covariate_model_laplace --structure 2cmt-infusion --groups 4 --doses "50,100,200,400" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5" --covariate-model --approximation laplace --gof-plots --author "Ravi Diallo" --seed 20261083
```

### 084_1cmt_oral_3grp_covariate_model_saem

**Covariate model, SAEM.** Base and true covariate models both fitted by SAEM. true covariate model fitted as run102. Author: Nora Wagner.

```
nlmx generate --output projects/084_1cmt_oral_3grp_covariate_model_saem --structure 1cmt-oral --groups 3 --doses "50,100,200" --subjects-per-group 30 --effects "CL~WT=0.75,V~WT=1,CL~SEX=0.8" --covariate-model --approximation saem --gof-plots --author "Nora Wagner" --seed 20261084
```

### 085_3cmt_iv_3grp_covariate_model

**Three-compartment covariate model.** Weight and eGFR effects in a three-compartment model; run102 is the true model. true covariate model fitted as run102. Author: Henrik Schmidt.

```
nlmx generate --output projects/085_3cmt_iv_3grp_covariate_model --structure 3cmt-iv --groups 3 --doses "50,100,200" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6" --covariate-model --gof-plots --author "Henrik Schmidt" --seed 20261085
```

### 086_2cmt_oral_4grp_weak_effects

**Weak covariate effects.** Small exponents (0.2 to 0.3) that are hard to detect: a power test for covariate searches. true covariate model fitted as run102. Author: Priya Bauer.

```
nlmx generate --output projects/086_2cmt_oral_4grp_weak_effects --structure 2cmt-oral --groups 4 --doses "25,50,100,200" --effects "CL~WT=0.3,V~WT=0.3,CL~EGFR=0.2" --covariate-model --gof-plots --author "Priya Bauer" --seed 20261086
```

### 087_1cmt_oral_6grp_vector_plots

**Vector figures.** Six arms with the goodness-of-fit plots also written as SVG. Author: Wanjiru Herrera.

```
nlmx generate --output projects/087_1cmt_oral_6grp_vector_plots --structure 1cmt-oral --groups 6 --doses "10,20,40,80,160,320" --subjects-per-group 12 --plot-format both --gof-plots --author "Wanjiru Herrera" --seed 20261087
```

### 088_2cmt_iv_2grp_foce_proportional

**FOCE, proportional error.** A two-compartment bolus model with proportional error, fitted by FOCE without interaction. Author: Tomasz Joshi.

```
nlmx generate --output projects/088_2cmt_iv_2grp_foce_proportional --structure 2cmt-iv --groups 2 --doses "100,200" --error proportional --approximation foce --gof-plots --author "Tomasz Joshi" --seed 20261088
```

## G. Realistic clinical-study archetypes (089–100)

### 089_phase1_sad_2cmt_oral_6grp

**Phase 1 single ascending dose.** Six cohorts of 8 subjects, doses 1 to 300, rich sampling over 72 h. Author: Zara Fontaine.

```
nlmx generate --output projects/089_phase1_sad_2cmt_oral_6grp --structure 2cmt-oral --groups 6 --group-names "C1,C2,C3,C4,C5,C6" --doses "1,3,10,30,100,300" --subjects-per-group 8 --sample-times "0.25,0.5,1,1.5,2,3,4,6,8,12,24,48,72" --gof-plots --author "Zara Fontaine" --seed 20261089
```

### 090_phase1_mad_2cmt_oral_5grp

**Phase 1 multiple ascending dose.** Five cohorts of 10, 14 daily doses, profiles on day 1 and day 14. Author: Rohan Sokolov.

```
nlmx generate --output projects/090_phase1_mad_2cmt_oral_5grp --structure 2cmt-oral --groups 5 --group-names "MAD1,MAD2,MAD3,MAD4,MAD5" --doses "10,25,50,100,200" --subjects-per-group 10 --n-doses 14 --dose-interval 24 --gof-plots --author "Rohan Sokolov" --seed 20261090
```

### 091_phase2_1cmt_oral_4grp_sparse_blq

**Phase 2 dose finding.** Four arms of 50, three random samples each, BLQ data and covariate effects. 3 samples per subject; LLOQ 0.05. Author: Sebastian Bakari.

```
nlmx generate --output projects/091_phase2_1cmt_oral_4grp_sparse_blq --structure 1cmt-oral --groups 4 --group-names "D25,D50,D100,D200" --doses "25,50,100,200" --subjects-per-group 50 --sparse-samples 3 --lloq 0.05 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5" --gof-plots --author "Sebastian Bakari" --seed 20261091
```

### 092_phase3_2cmt_oral_3grp_sparse

**Phase 3 population PK.** Three arms of 100, three samples each at steady state (14 daily doses). 3 samples per subject. Author: Kenji Kobayashi.

```
nlmx generate --output projects/092_phase3_2cmt_oral_3grp_sparse --structure 2cmt-oral --groups 3 --doses "50,100,150" --subjects-per-group 100 --n-doses 14 --dose-interval 24 --sparse-samples 3 --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.25" --gof-plots --author "Kenji Kobayashi" --seed 20261092
```

### 093_icu_antibiotic_2cmt_infusion_5grp

**ICU antibiotic.** Five infusion regimens every 8 h, renal clearance, sparse samples and an LLOQ. true covariate model fitted as run102; 4 samples per subject; LLOQ 0.5. Author: Astrid Whitfield.

```
nlmx generate --output projects/093_icu_antibiotic_2cmt_infusion_5grp --structure 2cmt-infusion --groups 5 --doses "500,750,1000,1500,2000" --n-doses 9 --dose-interval 8 --infusion-duration 0.5 --sparse-samples 4 --lloq 0.5 --typical "CL=6,V=20,Q=8,VP=25" --effects "CL~CRCL=0.85,V~WT=1" --sample-times "0.5,1,2,4,6,8" --covariate-model --gof-plots --author "Astrid Whitfield" --seed 20261093
```

### 094_mab_q2w_2cmt_infusion_ode_3grp

**Antibody every two weeks, $DES.** Six infusions every 336 h of a monoclonal antibody, written as differential equations. $DES (ADVAN13). Author: Haruto Brooks.

```
nlmx generate --output projects/094_mab_q2w_2cmt_infusion_ode_3grp --structure 2cmt-infusion --ode --groups 3 --doses "150,300,600" --n-doses 6 --dose-interval 336 --infusion-duration 1 --typical "CL=0.01,V=3,Q=0.02,VP=2.5" --iiv "CL=30,V=20" --effects "CL~WT=0.75,V~WT=0.6" --sample-times "1,24,72,168,336" --gof-plots --author "Haruto Brooks" --seed 20261094
```

### 095_oncology_3cmt_infusion_ode_4grp_cov

**Oncology infusion, $DES, covariate model.** A three-compartment cytotoxic given as a 1-hour infusion every 3 weeks, true covariate model fitted. true covariate model fitted as run102; $DES (ADVAN13). Author: Tobias Cohen.

```
nlmx generate --output projects/095_oncology_3cmt_infusion_ode_4grp_cov --structure 3cmt-infusion --ode --groups 4 --doses "100,150,200,250" --n-doses 3 --dose-interval 504 --infusion-duration 1 --effects "CL~WT=0.75,V~WT=1,CL~AGE=-0.2" --covariate-model --sample-times "0.5,1,2,4,8,24,72,168,504" --gof-plots --author "Tobias Cohen" --seed 20261095
```

### 096_ir_er_2cmt_oral_lag_ode_6grp_saem

**Six formulations, SAEM on $DES.** Six formulation/dose arms with a lag, sparse samples, fitted by SAEM on differential equations. 6 samples per subject; $DES (ADVAN13). Author: Tobias Diallo.

```
nlmx generate --output projects/096_ir_er_2cmt_oral_lag_ode_6grp_saem --structure 2cmt-oral-lag --ode --groups 6 --doses "10,20,40,80,160,320" --subjects-per-group 12 --sparse-samples 6 --approximation saem --gof-plots --author "Tobias Diallo" --seed 20261096
```

### 097_1cmt_oral_lag_ode_5grp_laplace_blq

**Lag, BLQ, Laplace on $DES.** Five arms with a lag time and BLQ samples, fitted by Laplace on differential equations. LLOQ 0.05; $DES (ADVAN13). Author: Ingrid Rossi.

```
nlmx generate --output projects/097_1cmt_oral_lag_ode_5grp_laplace_blq --structure 1cmt-oral-lag --ode --groups 5 --doses "10,20,40,80,160" --lloq 0.05 --approximation laplace --gof-plots --author "Ingrid Rossi" --seed 20261097
```

### 098_3cmt_oral_lag_ode_4grp_multiple_blq

**Three-compartment lag, repeated, BLQ, $DES.** Seven daily doses of a three-compartment oral drug with a lag and an LLOQ, as differential equations. LLOQ 0.02; $DES (ADVAN13). Author: Pedro Okeke.

```
nlmx generate --output projects/098_3cmt_oral_lag_ode_4grp_multiple_blq --structure 3cmt-oral-lag --ode --groups 4 --doses "25,50,100,200" --n-doses 7 --dose-interval 24 --lloq 0.02 --gof-plots --author "Pedro Okeke" --seed 20261098
```

### 099_2cmt_oral_lag_6grp_everything

**Everything at once (analytic).** Six named arms, unbalanced, BID to steady state, sparse, BLQ, IIV on five parameters, four covariate effects, true model, SVG figures. true covariate model fitted as run102; 5 samples per subject; LLOQ 0.05. Author: Maryam Wagner.

```
nlmx generate --output projects/099_2cmt_oral_lag_6grp_everything --structure 2cmt-oral-lag --groups 6 --group-names "A,B,C,D,E,F" --doses "10,20,40,80,160,320" --subjects-per-group "15,15,20,20,25,25" --n-doses 10 --dose-interval 12 --sparse-samples 5 --lloq 0.05 --typical "CL=4,V=40,Q=4,VP=60,KA=1.3,ALAG=0.4" --iiv "CL=35,V=25,KA=45,Q=25,VP=30" --prop-error 18 --add-error 0.01 --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.5,KA~AGE=-0.2" --covariate-model --sample-times "0.5,1,1.5,2,3,4,6,8,12" --plot-format both --gof-plots --author "Maryam Wagner" --seed 20261099
```

### 100_3cmt_oral_lag_ode_6grp_everything

**Everything at once ($DES).** The most complex project: a three-compartment oral model with lag as differential equations, six arms, repeated dosing, sparse and BLQ samples, five covariate effects and the true model. true covariate model fitted as run102; 6 samples per subject; LLOQ 0.02; $DES (ADVAN13). Author: Sofia Ndlovu.

```
nlmx generate --output projects/100_3cmt_oral_lag_ode_6grp_everything --structure 3cmt-oral-lag --ode --groups 6 --group-names "A,B,C,D,E,F" --doses "10,20,40,80,160,320" --subjects-per-group 15 --n-doses 7 --dose-interval 24 --sparse-samples 6 --lloq 0.02 --iiv "CL=30,V=25,KA=40" --effects "CL~WT=0.75,V~WT=1,CL~EGFR=0.6,CL~AGE=-0.2,CL~SEX=0.85" --covariate-model --gof-plots --author "Sofia Ndlovu" --seed 20261100
```

## After generating

Every project folder holds `data/analysis.csv`, `truth.ctl`, `groups.csv`, the fitted `models/run101.*` (and `run102.*` with `--covariate-model`), the goodness-of-fit plots in `gof/`, the settings for the next steps (`nlmx.covar`, `nlmx.vpc`, `nlmx.forest` when there are covariates, and `nlmx.gen`, which makes the project again) and a `README.md`. For example:

```
cd projects/001_1cmt_oral_2grp_minimal
nlmx cov -c nlmx.covar --method frozen --output out_frozen
nlmx vpc -c nlmx.vpc --plots
nlmx fit models/run101.ctl --plots
```
