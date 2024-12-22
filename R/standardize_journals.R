#' Standardize Journal Names
#'
#' This function standardizes journal names using a mapping file.
#'
#' @param publications A data frame of publications.
#' @return A data frame with standardized journal names.
#' @export
standardize_journals <- function(publications) {
  # Locate the journal mapping file within the installed package
  file_path <- system.file("extdata", "journal_mapping.xlsx", package = "GSFirstAuthorProba")

  # Read the journal mapping file
  journal_mapping <- openxlsx::read.xlsx(file_path)

  # Standardize journal names
  publications %>%
    mutate(journal = case_when(
      journal %in% journal_mapping$original_name ~
        journal_mapping$standardized_name[match(journal, journal_mapping$original_name)],
      TRUE ~ journal
    ))
}
