#' Filter Journals by Whitelist
#'
#' This function filters publications to include only those from a predefined whitelist.
#'
#' @param publications A data frame of publications.
#' @return A filtered data frame of publications.
#' @export
filter_journals <- function(publications) {
  journal_list <- read.xlsx(here::here("data", "scopus_list.xlsx"))
  journals <- tolower(unique(journal_list$Source.Title))
  publications %>%
    filter(tolower(journal) %in% journals)
}
