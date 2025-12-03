#' Fetch NatureServe Information for Species
#'
#' Fetches species conservation status information from NatureServe Canada.
#'
#' @param sp Species name (scientific name)
#'
#' @return Data frame with species information and conservation status
#' @export
#'
#' @examples
#' \dontrun{
#' info <- fetch_natserv_info("Salmo trutta")
#' }
fetch_natserv_info <- function(sp) {
  tryCatch(
    {
      ns_res <- natserv::ns_search_spp(text_adv = list(
        searchToken = sp,
        matchAgainst = "allNames", operator = "equals"
      ))
      
      id_subnation <- which(ns_res$results$nations[[1]]$nationCode == "CA")
      can_status <- ns_res$results$nations[[1]]$subnations[[id_subnation]]
      
      return(dplyr::bind_cols(species = sp, can_status))
    },
    error = function(e) {
      warning(paste("Error fetching data for species:", sp, "-", e$message))
      return(data.frame(species = sp))
    }
  )
}

#' Process Species Information from Multiple Sources
#'
#' Combines species information from NatureServe, ITIS, GBIF, and Catalogue of Life.
#'
#' @param species_list Data frame containing species data
#'
#' @return Data frame with enhanced species information including common names,
#'   conservation status, and external links
#' @export
#'
#' @examples
#' \dontrun{
#' enhanced_species <- process_species_info(species_list)
#' }
process_species_info <- function(species_list) {

  # Fetch NatureServ informations
  natserv_infos <- species_list |>
    purrr::map_df(.f = fetch_natserv_info) |>
    suppressWarnings() |>
    dplyr::mutate(subnationCode = convert_province_codes(subnationCode)) |>
    tidyr::pivot_wider(names_from = "subnationCode", values_from = "roundedSRank") |>
    dplyr::select(-dplyr::any_of("NA"))
  
  # Get ITIS common names
  itis_common_names <- taxize::sci2comm(species_list, db = "itis", simplify = FALSE, messages = FALSE) |>
    purrr::compact() |>
    dplyr::bind_rows(.id = "species") |>
    dplyr::filter(language %in% c("French", "English")) |>
    dplyr::mutate(commonName = stringr::str_replace_all(commonName, "queue \u00E0 tache noire", "queue \u00E0 t\u00E2che noire")) |>
    dplyr::distinct() |>
    dplyr::mutate(commonName = stringr::str_to_sentence(commonName)) |>
    tidyr::pivot_wider(names_from = "language", values_from = "commonName", values_fn = \(x) paste(x, collapse = "; ")) |>
    dplyr::mutate(
      itis_url = paste0(
        "https://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=Scientific_Name&search_value=",
        gsub(" ", "+", species)
      )
    )
  
  # Get Catalogue of Life informations
  col_infos <- taxize::gna_verifier(names = species_list, data_sources = 1) |>
    dplyr::mutate(col_url = paste0("https://www.catalogueoflife.org/data/taxon/", currentRecordId)) |>
    dplyr::select(species = submittedName, col_url)

  # Get GBIF informations
  gbif_infos <- data.frame(
    species = species_list, 
    gbif_url = taxize::get_gbifid(species_list, messages = FALSE) |> attr("uri")
  )
  
  # Combine all informations
  final_species_df <- data.frame(species = species_list) |>
    dplyr::left_join(itis_common_names, by = "species") |>
    dplyr::left_join(natserv_infos, by = "species") |>
    dplyr::left_join(gbif_infos, by = "species") |>
    dplyr::left_join(col_infos, by = "species") 

  final_species_df <- final_species_df |>
    dplyr::group_by(
      species,
      English,
      French,
      gbif_url,
      col_url,
      itis_url
    ) |>
    dplyr::summarise(
      Native_Quebec = any(native == TRUE & !is.na(Quebec)),
      Exotic_Quebec = any(exotic == TRUE & !is.na(Quebec)),
      .groups = "drop"
    )

  status_qc <- read.csv(system.file("extdata/QC_especes_en_peril.csv", package = "barqueReport"))
  status_ca <- read.csv(system.file("extdata/CA_especes_en_peril.csv", package = "barqueReport"))

  # Join conservation status data
  # Remove duplicates from conservation status files by keeping the first occurrence
  status_ca_unique <- status_ca |>
    dplyr::select(species = Nom.scientifique, status_ca = Statut.à.l.annexe.1) |>
    dplyr::distinct(species, .keep_all = TRUE)

  status_qc_unique <- status_qc |>
    dplyr::select(species = Nom_scientifique, status_qc = STATUT_LEMV) |>
    dplyr::distinct(species, .keep_all = TRUE)

  final_species_df <- final_species_df |>
    dplyr::left_join(
      status_ca_unique,
      by = c("species")
    ) |>
    dplyr::left_join(
      status_qc_unique,
      by = c("species")
    ) |>
    dplyr::mutate(
      status_ca = ifelse(status_ca == "Aucun statut", NA, status_ca),
      status_qc = ifelse(status_qc == "Non suivie", NA, status_qc)
    )

  return(final_species_df)
}
