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
    tidyr::pivot_wider(names_from = "language", values_from = "commonName", values_fn = \(x) paste(x, collapse = "; "))
  
  # Get Catalogue of Life informations
  col_infos <- taxize::gna_verifier(names = species_list, data_sources = 1) |>
    dplyr::mutate(col_link = paste0("https://www.catalogueoflife.org/data/taxon/", currentRecordId)) |>
    dplyr::select(species = submittedName, col_link)
  
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
    dplyr::left_join(col_infos, by = "species") |>
    dplyr::mutate(
      itis_url = paste0("https://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=", tsn),
      display_name = ifelse(!is.na(French), French, "Nom vernaculaire inconnu"),
      species_formatted = paste0(
        display_name,
        " <br><small><em>", species, "</em></small>",
        ifelse(!is.na(gbif_url), paste0(" <a href='", gbif_url, "' target='_blank' title='GBIF'>[GBIF]</a>"), ""),
        ifelse(!is.na(col_link), paste0(" <a href='", col_link, "' target='_blank' title='Catalogue of Life'>[CoL]</a>"), ""),
        ifelse(!is.na(itis_url), paste0(" <a href='", itis_url, "' target='_blank' title='ITIS'>[ITIS]</a>"), "")
      )
    )
  
  return(final_species_df)
}
