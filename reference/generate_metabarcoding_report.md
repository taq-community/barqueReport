# Generate Metabarcoding Report

Renders a metabarcoding report using the package template with specified
parameters.

## Usage

``` r
generate_metabarcoding_report(
  barque_output_folder,
  samples_ids,
  output_file = "metabarcoding_report.html",
  output_dir = getwd(),
  title = "🧬 Rapport de métabarcoding",
  subtitle = "",
  author = "",
  illumina_quality_file = NULL,
  blank_lab = NULL,
  blank_field = NULL,
  open_report = TRUE
)
```

## Arguments

- barque_output_folder:

  Path to the barque output folder

- samples_ids:

  Vector of sample IDs to include in the analysis

- output_file:

  Output file name (default: "metabarcoding_report.html")

- output_dir:

  Output directory (default: current working directory)

- title:

  Report title (default: "Rapport de metabarcoding")

- subtitle:

  Report subtitle (default: "")

- author:

  Report author(s) (default: "")

- illumina_quality_file:

  Path to Illumina quality file (optional)

- blank_lab:

  Laboratory blank sample ID (optional)

- blank_field:

  Field blank sample ID (optional)

- open_report:

  Logical, whether to open the report after rendering (default: TRUE)

## Value

Path to the generated report file

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage

# With all parameters
generate_metabarcoding_report(
  barque_output_folder = "/path/to/barque/output",
  samples_ids = c("ST1", "ST2", "ST3", "ST4"),
  title = "Marine Biodiversity Assessment",
  subtitle = "Lake Superior Study",
  author = "Research Team",
  output_file = "lake_superior_report.html",
  blank_lab = "LAB_BLANK",
  blank_field = "FIELD_BLANK"
)
} # }
```
