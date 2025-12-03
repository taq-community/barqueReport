# Generate Client Report (PDF)

Renders a client-focused metabarcoding report in PDF format for 12S
analysis using the package template with specified parameters.

## Usage

``` r
generate_client_report(
  barque_output_folder,
  samples_ids,
  output_file = "client_report.pdf",
  output_dir = getwd(),
  title = "Rapport d'Analyse Métagénomique - 12S",
  subtitle = "",
  lab_author = "",
  bioinfo_author = "",
  report_author = "",
  extraction_author = "",
  title_short = "Rapport 12S",
  client_name = "",
  geographic_region = "",
  target_species = "Espèces aquatiques (poissons)",
  config_file = NULL,
  primer_file = NULL,
  citation_note = NULL
)
```

## Arguments

- barque_output_folder:

  Path to the barque output folder

- samples_ids:

  Vector of sample IDs to include in the analysis

- output_file:

  Output file name (default: "client_report.pdf")

- output_dir:

  Output directory (default: current working directory)

- title:

  Report title (default: "Rapport d'Analyse Metagenomique - 12S")

- subtitle:

  Report subtitle (default: "")

- lab_author:

  Laboratory analysis author(s) (default: "")

- bioinfo_author:

  Bioinformatics analysis author(s) (default: "")

- report_author:

  Report writing author(s) (default: "")

- extraction_author:

  DNA extraction author(s) (default: "")

- title_short:

  Short title for headers (default: "Rapport 12S")

- client_name:

  Client name (default: "")

- geographic_region:

  Geographic region of sampling (default: "")

- target_species:

  Target species description (default: "Especes aquatiques (poissons)")

- config_file:

  Path to barque config file (optional)

- primer_file:

  Path to primers CSV file (optional)

- citation_note:

  Citation note for the report (optional)

## Value

Path to the generated report file

## Details

The function automatically looks for a cover image in the package
directory at inst/images/cover.jpg or inst/images/cover.png. If no cover
image is found, a default gradient background will be used in the PDF
report.

## Examples

``` r
if (FALSE) { # \dontrun{
# Basic usage
generate_client_report(
  barque_output_folder = "/path/to/barque/output",
  samples_ids = c("ST1", "ST2", "ST3", "ST4"),
  client_name = "Valerie Langlois",
  geographic_region = "Province du Quebec",
  lab_author = "Julie Couillard",
  bioinfo_author = "Steve Vissault",
  report_author = "Tuan Ahn To"
)
} # }
```
