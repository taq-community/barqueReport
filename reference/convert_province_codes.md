# Convert Canadian Province Codes to Full Names

Converts Canadian province/territory codes to their full names using a
standardized lookup table.

## Usage

``` r
convert_province_codes(codes)
```

## Arguments

- codes:

  Character vector of province/territory codes

## Value

Character vector of full province/territory names. Unknown codes return
NA.

## Examples

``` r
convert_province_codes(c("ON", "QC", "BC"))
#>                 ON                 QC                 BC 
#>          "Ontario"           "Quebec" "British Columbia" 
convert_province_codes(c("ON", "XX", "AB"))  # Unknown code returns NA
#>        ON      <NA>        AB 
#> "Ontario"        NA "Alberta" 
```
