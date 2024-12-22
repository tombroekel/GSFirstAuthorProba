#' Filter Journals by Whitelist
#'
#' This function filters publications to include only those from a predefined whitelist.
#'
#' @param publications A data frame of publications.
#' @return A filtered data frame of publications.
#' @export
filter_journals <- function(publications) {
  # Locate the scopus_list.xlsx file within the installed package
  file_path <- system.file("extdata", "scopus_list.xlsx", package = "GSFirstAuthorProba")

  # Read the journal whitelist
  journal_list <- openxlsx::read.xlsx(file_path)

  # Extract the list of journals
  journals <- tolower(unique(journal_list$Source.Title))

  # Filter the publications based on the whitelist
  filtered_publications <- publications %>%
    filter(tolower(journal) %in% journals)

  return(filtered_publications)
}
