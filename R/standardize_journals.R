#' Standardize Journal Names
#'
#' This function standardizes journal names using a mapping file.
#'
#' @param publications A data frame of publications.
#' @return A data frame with standardized journal names.
#' @export
standardize_journals <- function(publications) {
  journal_mapping <- read.xlsx(here::here("data", "journal_mapping.xlsx"))
  publications %>%
    mutate(journal = case_when(
      journal %in% journal_mapping$original_name ~
        journal_mapping$standardized_name[match(journal, journal_mapping$original_name)],
      TRUE ~ journal
    ))
}
