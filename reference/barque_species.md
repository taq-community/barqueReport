# Extract Species List from Barque Output

Extracts and cleans the species list from barque output, handling both
single hits and multiple hits (where species are separated by " : ").

## Usage

``` r
barque_species(path = NULL)
```

## Arguments

- path:

  Path to the barque species table CSV file

## Value

A data frame with columns: Group, Genus, Species (distinct values only)

## Examples

``` r
if (FALSE) { # \dontrun{
species <- barque_species("/path/to/barque/output/12s200pb_species_table.csv")
} # }
```
