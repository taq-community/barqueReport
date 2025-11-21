# Process Species Information from Multiple Sources

Combines species information from NatureServe, ITIS, GBIF, and Catalogue
of Life.

## Usage

``` r
process_species_info(species_list)
```

## Arguments

- species_list:

  Data frame containing species data

## Value

Data frame with enhanced species information including common names,
conservation status, and external links

## Examples

``` r
if (FALSE) { # \dontrun{
enhanced_species <- process_species_info(species_list)
} # }
```
