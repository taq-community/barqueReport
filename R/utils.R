#' Canadian Province Code Lookup Table
#'
#' A named vector mapping Canadian province/territory codes to full names.
#'
#' @format A named character vector with 14 elements:
#' \describe{
#'   \item{ON}{Ontario}
#'   \item{QC}{Quebec}
#'   \item{LB}{Labrador}
#'   \item{NB}{New Brunswick}
#'   \item{NT}{Northwest Territories}
#'   \item{NF}{Newfoundland}
#'   \item{YT}{Yukon}
#'   \item{PE}{Prince Edward Island}
#'   \item{NU}{Nunavut}
#'   \item{SK}{Saskatchewan}
#'   \item{MB}{Manitoba}
#'   \item{NS}{Nova Scotia}
#'   \item{AB}{Alberta}
#'   \item{BC}{British Columbia}
#' }
#' @export
province_codes <- c(
  "ON" = "Ontario",
  "QC" = "Quebec", 
  "LB" = "Labrador",
  "NB" = "New Brunswick",
  "NT" = "Northwest Territories",
  "NF" = "Newfoundland",
  "YT" = "Yukon",
  "PE" = "Prince Edward Island",
  "NU" = "Nunavut",
  "SK" = "Saskatchewan",
  "MB" = "Manitoba",
  "NS" = "Nova Scotia",
  "AB" = "Alberta",
  "BC" = "British Columbia"
)

#' Convert Canadian Province Codes to Full Names
#'
#' Converts Canadian province/territory codes to their full names using
#' a standardized lookup table.
#'
#' @param codes Character vector of province/territory codes
#'
#' @return Character vector of full province/territory names. Unknown codes
#'   return NA.
#' @export
#'
#' @examples
#' convert_province_codes(c("ON", "QC", "BC"))
#' convert_province_codes(c("ON", "XX", "AB"))  # Unknown code returns NA
convert_province_codes <- function(codes) {
  province_codes[codes]
}