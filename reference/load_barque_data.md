# Load and Process Barque Output Data

This function loads the species table from barque output and processes
it by removing totals and separating single hits from multi-hits.

## Usage

``` r
load_barque_data(barque_output_folder, samples_ids)
```

## Arguments

- barque_output_folder:

  Path to the barque output folder

- samples_ids:

  Vector of sample IDs to include in the analysis

## Value

A list containing single_hits and multi_hits data frames

## Examples

``` r
if (FALSE) { # \dontrun{
data <- load_barque_data("/path/to/barque/output", c("ST1", "ST2", "ST3"))
} # }
```
