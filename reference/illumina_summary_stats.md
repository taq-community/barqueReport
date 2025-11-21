# Calculate Illumina Summary Statistics

Processes Illumina quality metrics data to calculate median quality
scores for specified samples.

## Usage

``` r
illumina_summary_stats(path = NULL, sample_ids = NULL)
```

## Arguments

- path:

  Character. Path to the Illumina Quality_Metrics.csv file.

- sample_ids:

  Character vector. Sample IDs to filter and analyze.

## Value

A data frame with columns:

- SampleID:

  Sample identifier

- mu_pf:

  Median Mean Quality Score (PF) for each sample

- mu_q30:

  Median percentage of Q30 bases for each sample

## Details

This function reads Illumina sequencing quality metrics and calculates
median values for two key quality indicators:

- Mean Quality Score (PF): Quality score for reads passing filter

- % Q30: Percentage of bases with quality score ≥30 (99.9% accuracy)

## Examples

``` r
if (FALSE) { # \dontrun{
stats <- illumina_summary_stats(
  path = "path/to/Quality_Metrics.csv",
  sample_ids = c("Sample1", "Sample2", "Sample3")
)
} # }
```
