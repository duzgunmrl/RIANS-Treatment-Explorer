# RIANS Treatment Explorer

## Overview

RIANS Treatment Explorer is an interactive Shiny application designed to explore ATM–ApoE dynamics within the RIANS model in the context of Alzheimer's disease.

The application combines numerical simulations and decision-support tools to investigate the effects of irradiation and treatment strategies on the perinuclear crown and ATM nuclear translocation.

---

## Main Features

### Simulation module

The simulation module allows the user to:

- study ATM–ApoE dynamics over time;
- apply irradiation at a chosen time and dose;
- introduce treatment effects through antioxidants and statins;
- visualize the evolution of:

  - cytoplasmic dimers (DC);
  - cytoplasmic monomers (MC);
  - perinuclear monomers (MA);
  - nuclear monomers (MN);
  - free ApoE;
  - ApoE–ATM complexes (CA);
  - perinuclear dimers (DA);
  - total perinuclear crown (PC).

The application automatically generates graphical outputs and summary indicators.

---

### Decision-support module

The decision-support module explores combinations of irradiation and treatment intensities in order to identify effective therapeutic strategies.

The treatment is represented by a global dose simultaneously affecting antioxidants and statins. This global treatment combines several biological effects:

- reduction of oxidative stress;
- limitation of ATM–ApoE trapping;
- inhibition of perinuclear crown reformation;
- enhancement of ATM nuclear translocation.

Simulation results are classified according to the evolution of the perinuclear crown before irradiation, immediately after irradiation and at long term.

---

## Biological Outputs

The application provides several biologically relevant indicators.

### Perinuclear crown

- maximum crown level;
- post-irradiation crown level;
- long-term crown level;
- immediate crown destruction;
- long-term maintenance or reformation.

### ApoE

- minimum free ApoE concentration;
- long-term free ApoE concentration.

### Nuclear ATM

- maximum nuclear ATM concentration;
- long-term nuclear ATM concentration.

A global conclusion indicating therapeutic success or failure is also provided.

---

## PDF Export

A PDF report can be generated automatically.

The report contains:

- the simulated scenario;
- biological indicators;
- graphical outputs.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/duzgunmrl/RIANS-Treatment-Explorer.git

cd RIANS-Treatment-Explorer
````

Launch R:

```bash
R
```

Install `renv` (**only once**):

```r
install.packages("renv")
```

If prompted, answer:

```text
Yes
```

Restore the project environment (**only once**):

```r
renv::restore()
```

Launch the application:

```r
shiny::runApp()
```

---

## Subsequent Uses

Once the environment has been installed, the application can simply be started with:

```r
shiny::runApp()
```

No additional installation steps are required.

---

## Author

**Duzguncan Meral**

Master of Bioinformatics

Université Claude Bernard Lyon 1

2026

