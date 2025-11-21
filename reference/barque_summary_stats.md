# Calculate Summary Statistics

Calculate comprehensive statistics for metabarcoding data including
number of samples, species, reads, and percentages.

## Usage

``` r
barque_summary_stats(single_hits, multi_hits, samples_ids)
```

## Arguments

- single_hits:

  Data frame of single hit species

- multi_hits:

  Data frame of multi-hit species

- samples_ids:

  Vector of sample IDs

## Value

List of summary statistics

## Examples

``` r
if (FALSE) { # \dontrun{
stats <- barque_summary_stats(single_hits, multi_hits, samples_ids)
} # }
```
