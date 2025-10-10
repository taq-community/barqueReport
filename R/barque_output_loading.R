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
    dplyr::filter(rlang::.data$Group != "Total") |>
    dplyr::select(rlang::.data$Group, rlang::.data$Genus, rlang::.data$Species, dplyr::all_of(samples_ids)) |>
    dplyr::mutate(Species = paste(rlang::.data$Genus, rlang::.data$Species)) |>
    dplyr::select(-rlang::.data$Genus)
  
  # Separate single hits from multi-hits
  single_hits <- species_data |>
    dplyr::filter(rlang::.data$Group != "zMultiple")
  
  multi_hits <- species_data |>
    dplyr::filter(rlang::.data$Group == "zMultiple")
  
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
#' stats <- barque_summary_stats(single_hits, multi_hits, samples_ids)
#' }
barque_summary_stats <- function(single_hits, multi_hits, samples_ids) {
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

#' Load and Process Sequence Dropout Data
#'
#' Loads the sequence dropout data from barque output and processes it for plotting
#' by filtering samples and reshaping the data into long format.
#'
#' @param barque_output_folder Path to the barque output folder
#' @param samples_ids Vector of sample IDs to include in the analysis
#'
#' @return A data frame in long format ready for plotting with columns:
#'   Sample, step, sequences
#' @export
#'
#' @examples
#' \dontrun{
#' dropout_data <- load_dropout_data("/path/to/barque/output", c("ST1", "ST2", "ST3"))
#' }
load_dropout_data <- function(barque_output_folder, samples_ids) {
  # Read the sequence dropout data
  dropout_data <- readr::read_csv(file.path(barque_output_folder, "12_results", "sequence_dropout.csv"))
  
  # Filter data to keep only sample_ids from params
  dropout_filtered <- dropout_data |>
    dplyr::filter(rlang::.data$Sample %in% samples_ids)
  
  # Reshape data for plotting
  dropout_long <- dropout_filtered |>
    tidyr::pivot_longer(
      cols = -rlang::.data$Sample,
      names_to = "step",
      values_to = "sequences"
    )
  
  return(dropout_long)
}
