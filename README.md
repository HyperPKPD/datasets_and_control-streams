# Population PK Open Benchmarks & Models Repository

Welcome to the **Population PK Models & Benchmarks** repository. This repository is a collection of fully reproducible, end-to-end population pharmacokinetic (PopPK) modelling projects.

Each directory is an independent, self-contained modelling project with a simulated dataset, NONMEM control streams, fitted results and diagnostics, and `nlmx` project configurations. All code, datasets and configurations in this repository are open and free to use for benchmarking, education and research.

## What is here

| file | what it is |
|---|---|
| [`projects.md`](projects.md) | the problem statement and the 100 `nlmx generate` commands, from the simplest project to the most complex |
| [`run.R`](run.R) | runs the 100 commands of `projects.md` one by one from R (`Rscript run.R`), with a log per project and `run_summary.csv` |
| `run_all.ps1`, `run_all.sh` | the same 100 commands as one script (PowerShell, bash) |
| [`linkedin/`](linkedin/) | two LinkedIn posts announcing the collection, ten 4:5 cover images (1080 x 1350) and two looping GIFs |
| `projects/` | the generated projects, one folder each (made by the commands; not stored until you run them) |

## The collection

| set | projects | what it covers |
|---|---|---|
| A | 001–018 | One-compartment oral models (ADVAN2), single and repeated dosing |
| B | 019–030 | One-compartment intravenous models: bolus (ADVAN1) and infusion |
| C | 031–050 | Two-compartment models (ADVAN3/ADVAN4) |
| D | 051–060 | Three-compartment models (ADVAN11/ADVAN12) |
| E | 061–072 | The same systems as differential equations ($DES, ADVAN13) |
| F | 073–088 | Estimation methods and true covariate models |
| G | 089–100 | Realistic clinical-study archetypes |

Every project has 2 to 6 treatment groups, goodness-of-fit plots, its own seed and its own author. The true parameter values and covariate effects are known (`truth.ctl`), so estimates can be checked against the truth.

## Generating the projects

With `nlmx` on your `PATH`, from this folder:

```
Rscript run.R                                            # any system with R
powershell -ExecutionPolicy Bypass -File run_all.ps1     # Windows
bash run_all.sh                                          # Linux / macOS
```

or run any single command from [`projects.md`](projects.md). All 100 were run with nlmx 4.18 (Linux build) and took 23 minutes on two CPU cores.

## What each project folder holds

```
projects/NNN_description/
├── data/analysis.csv        the simulated dataset (NONMEM format)
├── groups.csv               the treatment groups: names, doses, sizes
├── truth.ctl                the true model the data were simulated from
├── models/run101.*          the base model, fitted (.ctl .ext .cov .cor .coi .phi)
├── models/run102.*          the true covariate model, fitted (with --covariate-model)
├── gof/                     goodness-of-fit plots (gof/svg/ with --plot-format both)
├── nlmx.covar, nlmx.vpc     settings for covariate analysis and predictive checks
├── nlmx.forest              forest-plot settings (designs with covariates)
├── nlmx.gen                 the settings that make the project again
├── checksums.sha256         SHA-256 of every file
└── README.md                the design, the true values and the next commands
```

## Reproducibility

A project is defined by its command. The same command and seed give the same dataset and the same fit on any machine and for any number of threads. `nlmx.gen` in each folder records every setting, and `nlmx generate -c nlmx.gen --output <folder>` makes the project again.

## License

The projects are synthetic: no patient data are involved. The datasets, control streams and configurations are free to use for benchmarking, education and research. `nlmx` itself is licensed under CC BY-ND 4.0 (`nlmx --license`).
