# Population PK Open Benchmarks & Models Repository

Welcome to the **Population PK Models & Benchmarks** repository. This repository serves as a collection of fully reproducible, end-to-end Population Pharmacokinetic (PopPK) modeling projects. 

Each directory represents an independent, self-contained modeling project complete with simulated datasets, NONMEM control streams, model diagnostics/fitted results, and `nlmx` project configurations. All code, datasets, and configurations in this repository are open and free to use for benchmarking, educational, and research purposes.

---

## 📁 Repository Structure

The repository is organized by individual project directories. Aside from a shared or project-level `plots/` directory, each project folder adheres to a standardized structure:

```text
.
├── project_name/
│   ├── data/
│   │   ├── analysis.csv     # Simulated analysis dataset (GROUP and DOSE identify treatment groups)
│   │   └── groups.csv       # Group definitions and metadata mapping
│   ├── models/
│   │   ├── run101.ctl       # Base model control stream (no covariates)
│   │   ├── run101.lst       # Base model output / results (OFV, parameter estimates)
│   │   ├── run102.ctl       # Full/Covariate model control stream with estimated effects
│   │   └── run102.lst       # Covariate model output
│   ├── truth.ctl            # Simulation control stream (ground truth model with true parameters)
│   ├── nlmx.covar           # nlmx configuration for covariate analysis
│   ├── nlmx.vpc             # nlmx configuration for Visual Predictive Checks (VPC)
│   ├── nlmx.forest          # nlmx configuration for forest plot generation
│   ├── nlmx.gen             # Design configuration file to regenerate/reproduce the project
│   └── plots/               # Generated Goodness-of-Fit (GOF), VPCs, and forest plots
```

---

## 🔬 What Each Project Contains

Every project folder includes the following standardized components:

1. **Dataset (`data/`)**:
   - `analysis.csv`: Complete simulated PK dataset. Columns like `GROUP` and `DOSE` categorize treatment arms.
   - `groups.csv`: Lookup table for treatment group labels and descriptions.

2. **Simulation Model (`truth.ctl`)**:
   - The exact NONMEM control stream used to simulate the dataset, specifying true parameter values and structural covariate relationships (e.g., clearance $CL$ or central volume $V_2$ weight-based scaling).

3. **Fitted NONMEM Models (`models/`)**:
   - **Base Model (`run101`)**: Structural model without covariate effects, establishing the reference Objective Function Value (OFV).
   - **Covariate Model (`run102`)**: Model with estimated covariate parameters (e.g., estimating power/allometric exponents relative to ground truth).

4. **`nlmx` Configurations**:
   - Pre-configured `nlmx` files (`nlmx.covar`, `nlmx.vpc`, `nlmx.forest`, `nlmx.gen`) to rapidly run automated diagnostics, goodness-of-fit assessments, covariate searches, and project generation.

5. **Diagnostics & Visualizations (`plots/`)**:
   - Includes standard Goodness-of-Fit (GOF) plots (DV vs. PRED/IPRED, CWRES vs. TIME/PRED), Visual Predictive Checks (VPC), and forest plots summarizing covariate effects.

---

## 🚀 Getting Started

### Prerequisites

To execute the NONMEM control streams and `nlmx` workflows, ensure you have the following installed:
* **NONMEM** (v7.3 or higher recommended)
* **Perl-speaks-NONMEM (PsN)** (Optional, but recommended for model execution)
* **nlmx** environment / tools configured for your workflow

### Running a Model

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/your-repo-name.git
   cd your-repo-name/project_name
   ```

2. **Execute Control Streams in NONMEM**:
   Using PsN:
   ```bash
   execute models/run101.ctl
   execute models/run102.ctl
   ```

3. **Reproduce or Re-run using `nlmx`**:
   Execute project steps using the pre-configured `nlmx` files:
   ```bash
   # Regenerate project design
   nlmx nlmx.gen

   # Run VPCs or Covariate analyses
   nlmx nlmx.vpc
   nlmx nlmx.covar
   ```

---

## 📊 Example Project Summary

| Model Run | Description | Key Parameters / Covariates | OFV |
| :--- | :--- | :--- | :--- |
| `run101` | Base Model | Structural parameters without covariates | `-124760.221` |
| `run102` | Final Covariate Model | $CL_{WT} = 0.7493$ (Truth: 0.75)<br>$V2_{WT} = 0.9218$ (Truth: 1.00) | `-125853.224` |

---

## 📜 License & Usage

All models, code, and datasets in this repository are free and open-source. Feel free to use, adapt, and share them for educational, research, or benchmarking purposes.
