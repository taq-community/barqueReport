#' Load and Process Barque Output Data
#'
#' This function loads the species table from barque output and processes it
#' by removing totals and separating single hits from multi-hits.
#'
#' @param barque_output_folder Path to the barque output folder
#' @param samples_ids Vector of sample IDs to include in the analysis
#'
#' @return A list containing single_hits and multi_hits data frames
#' @export
#'
#' @examples
#' \dontrun{
#' data <- load_barque_data("/path/to/barque/output", c("ST1", "ST2", "ST3"))
#' }
load_barque_data <- function(barque_output_folder, samples_ids) {
  # Load the species table
  species_data <- utils::read.csv(file.path(barque_output_folder, "12_results", "12s200pb_species_table.csv"))
  
  # Remove the total row and process
  species_data <- species_data |>
    dplyr::filter(Group != "Total") |>
    dplyr::select(Group, Genus, Species, dplyr::all_of(samples_ids)) |>
    dplyr::mutate(Species = paste(Genus, Species)) |>
    dplyr::select(-Genus)
  
  # Separate single hits from multi-hits
  single_hits <- species_data |>
    dplyr::filter(Group != "zMultiple")
  
  multi_hits <- species_data |>
    dplyr::filter(Group == "zMultiple")
  
  return(list(
    single_hits = single_hits,
    multi_hits = multi_hits
  ))
}

#' Calculate Summary Statistics
#'
#' Calculate comprehensive statistics for metabarcoding data including
#' number of samples, species, reads, and percentages.
#'
#' @param single_hits Data frame of single hit species
#' @param multi_hits Data frame of multi-hit species
#' @param samples_ids Vector of sample IDs
#'
#' @return List of summary statistics
#' @export
#'
#' @examples
#' \dontrun{
#' stats <- calculate_summary_stats(single_hits, multi_hits, samples_ids)
#' }
calculate_summary_stats <- function(single_hits, multi_hits, samples_ids) {
  stats <- list(
    samples = length(samples_ids),
    single_species = nrow(single_hits),
    multi_groups = nrow(multi_hits),
    single_reads = sum(single_hits[, samples_ids], na.rm = TRUE),
    multi_reads = sum(multi_hits[, samples_ids], na.rm = TRUE),
    total_species = nrow(single_hits) + nrow(multi_hits),
    total_reads = sum(single_hits[, samples_ids], na.rm = TRUE) + sum(multi_hits[, samples_ids], na.rm = TRUE)
  )
  
  # Add percentages
  stats$single_pct <- round((stats$single_reads / stats$total_reads) * 100, 1)
  stats$multi_pct <- round((stats$multi_reads / stats$total_reads) * 100, 1)
  
  return(stats)
}
