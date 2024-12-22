#' Extract Last Names
#'
#' A helper function to extract the last name from a full author name.
#'
#' @param author A string representing the full name of an author.
#' @return The last name of the author.
#' @export
extract_last_name <- function(author) {
  name_parts <- strsplit(author, "\\s+")[[1]]
  if (length(name_parts) >= 2) {
    return(name_parts[2])
  } else {
    return(NA)
  }
}
