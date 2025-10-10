#' Generate Metabarcoding Report
#'
#' Renders a metabarcoding report using the package template with specified parameters.
#'
#' @param barque_output_folder Path to the barque output folder
#' @param samples_ids Vector of sample IDs to include in the analysis
#' @param output_file Output file name (default: "metabarcoding_report.html")
#' @param output_dir Output directory (default: current working directory)
#' @param title Report title (default: "Rapport de metabarcoding")
#' @param subtitle Report subtitle (default: "")
#' @param author Report author(s) (default: "")
#' @param illumina_quality_file Path to Illumina quality file (optional)
#' @param blank_lab Laboratory blank sample ID (optional)
#' @param blank_field Field blank sample ID (optional)
#' @param open_report Logical, whether to open the report after rendering (default: TRUE)
#'
#' @return Path to the generated report file
#' @export
#'
#' @examples
#' \dontrun{
#' # Basic usage
#' 
#' # With all parameters
#' generate_metabarcoding_report(
#'   barque_output_folder = "/path/to/barque/output",
#'   samples_ids = c("ST1", "ST2", "ST3", "ST4"),
#'   title = "Marine Biodiversity Assessment",
#'   subtitle = "Lake Superior Study",
#'   author = "Research Team",
#'   output_file = "lake_superior_report.html",
#'   blank_lab = "LAB_BLANK",
#'   blank_field = "FIELD_BLANK"
#' )
#' }
generate_metabarcoding_report <- function(
  barque_output_folder,
  samples_ids,
  output_file = "metabarcoding_report.html",
  output_dir = getwd(),
  title = "\U0001F9EC Rapport de m\u00E9tabarcoding",
  subtitle = "",
  author = "",
  illumina_quality_file = NULL,
  blank_lab = NULL,
  blank_field = NULL,
  open_report = TRUE
) {
  
  # Validate inputs
  if (!dir.exists(barque_output_folder)) {
    stop("barque_output_folder does not exist: ", barque_output_folder)
  }
  
  if (!dir.exists(output_dir)) {
    stop("output_dir does not exist: ", output_dir)
  }
  
  if (length(samples_ids) == 0) {
    stop("samples_ids cannot be empty")
  }
  
  # Find the template file
  template_path <- system.file("quarto/barque_template.qmd", package = "barqueReport")
  
  if (template_path == "") {
      stop("Could not find barque_report.qmd")
  }
  
  # Prepare parameters
  params <- list(
    barque_output_folder = barque_output_folder,
    samples_ids = samples_ids,
    illumina_quality_file = illumina_quality_file,
    blank_lab = blank_lab,
    blank_field = blank_field
  )
  
  # Read the template
  template_content <- readLines(template_path)
  
  # Find YAML front matter boundaries
  yaml_start <- which(template_content == "---")[1]
  yaml_end <- which(template_content == "---")[2]
  
  # Update YAML front matter
  yaml_lines <- template_content[(yaml_start + 1):(yaml_end - 1)]
  
  # Replace title, subtitle, author if provided
  title_line <- grep("^title:", yaml_lines)
  if (length(title_line) > 0) {
    yaml_lines[title_line] <- paste0('title: "', title, '"')
  }
  
  subtitle_line <- grep("^subtitle:", yaml_lines)
  if (length(subtitle_line) > 0) {
    yaml_lines[subtitle_line] <- paste0('subtitle: "', subtitle, '"')
  }
  
  author_line <- grep("^author:", yaml_lines)
  if (length(author_line) > 0) {
    yaml_lines[author_line] <- paste0('author: "', author, '"')
  }
  
  # Create timestamped QMD file
  timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
  qmd_filename <- paste0("barque_report_", timestamp, ".qmd")
  qmd_path <- file.path(output_dir, qmd_filename)
  
  # Write modified template
  writeLines(c(
    template_content[1:yaml_start],
    yaml_lines,
    template_content[yaml_end:length(template_content)]
  ), qmd_path)
  
  # Render the report
  output_path <- file.path(output_dir, output_file)
  
  message("Rendering metabarcoding report...")
  message("Template: ", template_path)
  message("QMD file: ", qmd_path)
  message("Output: ", output_path)
  
  quarto::quarto_render(
    input = qmd_path,
    output_file = output_file,
    execute_params = params
  )
  
  # Open report if requested
  if (open_report && interactive()) {
    utils::browseURL(output_path)
  }
  
  message("Report generated successfully: ", output_path)
  message("QMD file saved: ", qmd_path)
  return(invisible(list(html = output_path, qmd = qmd_path)))
}
