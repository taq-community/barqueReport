#' Calculate Illumina Summary Statistics
#'
#' Processes Illumina quality metrics data to calculate median quality scores
#' for specified samples.
#'
#' @param path Character. Path to the Illumina Quality_Metrics.csv file.
#' @param sample_ids Character vector. Sample IDs to filter and analyze.
#'
#' @return A data frame with columns:
#'   \describe{
#'     \item{SampleID}{Sample identifier}
#'     \item{mu_pf}{Median Mean Quality Score (PF) for each sample}
#'     \item{mu_q30}{Median percentage of Q30 bases for each sample}
#'   }
#'
#' @details
#' This function reads Illumina sequencing quality metrics and calculates
#' median values for two key quality indicators:
#' - Mean Quality Score (PF): Quality score for reads passing filter
#' - % Q30: Percentage of bases with quality score ≥30 (99.9% accuracy)
#'
#' @examples
#' \dontrun{
#' stats <- illumina_summary_stats(
#'   path = "path/to/Quality_Metrics.csv",
#'   sample_ids = c("Sample1", "Sample2", "Sample3")
#' )
#' }
#'
#' @export
illumina_summary_stats <- function(path = NULL, sample_ids = NULL) {
    if (is.null(path) || !file.exists(path)) {
        stop("Path to Illumina quality metrics file is required and must exist")
    }
    
    if (is.null(sample_ids) || length(sample_ids) == 0) {
        stop("Sample IDs are required")
    }
    
    return(readr::read_csv(path, show_col_types = FALSE) |>
        dplyr::filter(rlang::.data$SampleID %in% sample_ids) |>
        dplyr::group_by(rlang::.data$SampleID) |>
        dplyr::summarise(
            mu_pf = stats::median(rlang::.data$`Mean Quality Score (PF)`, na.rm = TRUE),
            mu_q30 = stats::median(rlang::.data$`% Q30`, na.rm = TRUE),
            .groups = "drop"
        ))
}
