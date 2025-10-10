
<!-- README.md is generated from README.Rmd. Please edit that file -->

# barqueReport

<!-- badges: start -->

[![R-CMD-check](https://github.com/taq-community/barqueReport/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/taq-community/barqueReport/actions/workflows/R-CMD-check.yaml)
[![pkgdown](https://github.com/taq-community/barqueReport/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/taq-community/barqueReport/actions/workflows/pkgdown.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Installation

### Installing barqueReport

You can install the development version of barqueReport from
[GitHub](https://github.com/) with:

``` r
install.packages("remotes")
remotes::install_github("taq-community/barqueReport")
```

## Quick Start

### Generate a Metabarcoding Report

The main function generates an interactive HTML report from barque
pipeline output:

``` r
library(barqueReport)

# Interactive file selection (recommended for beginners)
generate_metabarcoding_report(
  barque_output_folder = file.choose(),  # Select barque output folder
  samples_ids = c("ST1", "ST2", "ST3", "ST4"),
  title = "Marine Biodiversity Assessment",
  subtitle = "Lake Superior Study",
  author = "Research Team",
  illumina_quality_file = file.choose(),  # Select Quality_Metrics.csv file
  blank_lab = "LAB_BLANK",
  blank_field = "FIELD_BLANK"
)

# Alternative: specify paths directly
generate_metabarcoding_report(
  barque_output_folder = "/path/to/barque/output",
  samples_ids = c("ST1", "ST2", "ST3", "ST4"),
  illumina_quality_file = "/path/to/Quality_Metrics.csv"
)
```

### Process Species Information

Enhance species data with taxonomic and conservation information:

``` r
# Load your species list
species_list <- c("Salmo trutta", "Oncorhynchus mykiss", "Perca flavescens")

# Fetch comprehensive species information
enhanced_species <- process_species_info(species_list)

# View the results
head(enhanced_species)
```

What does this function?

- Fetches conservation status from NatureServe Canada
- Retrieves common names from ITIS (French and English)
- Adds links to GBIF, Catalogue of Life, and ITIS databases
- Creates formatted species names with external links

## File Structure Requirements

Your barque output folder should contain:

    barque_output/
    ├── 12_results/
    │   ├── 12s200pb_species_table.csv
    │   └── sequence_dropout.csv
    └── [other pipeline outputs]

For Illumina quality analysis, provide the `Quality_Metrics.csv` file
from your sequencer.
