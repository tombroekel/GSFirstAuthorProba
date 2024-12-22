#' Fetch Publications from Google Scholar
#'
#' This function retrieves publications using the `scholar` package.
#'
#' @param profile_id The Google Scholar profile ID.
#' @return A data frame of publications.
#' @export
fetch_publications <- function(profile_id) {
  get_publications(profile_id)
}
