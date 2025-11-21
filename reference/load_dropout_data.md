# Load and Process Sequence Dropout Data

Loads the sequence dropout data from barque output and processes it for
plotting by filtering samples and reshaping the data into long format.

## Usage

``` r
load_dropout_data(barque_output_folder, samples_ids)
```

## Arguments

- barque_output_folder:

  Path to the barque output folder

- samples_ids:

  Vector of sample IDs to include in the analysis

## Value

A data frame in long format ready for plotting with columns: Sample,
step, sequences

## Examples

``` r
if (FALSE) { # \dontrun{
dropout_data <- load_dropout_data("/path/to/barque/output", c("ST1", "ST2", "ST3"))
} # }
```
