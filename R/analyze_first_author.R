#' Analyze First Authorship Probability
#'
#' This main function analyzes authorship patterns and calculates probabilities of being first author based on alphabetical order.
#' It combines helper functions to process publications and produce results.
#'
#' @param profile_id The Google Scholar profile ID.
#' @param last_name The last name of the author to analyze (e.g., "Broekel").
#' @return A list of results including observed vs theoretical shares, first authorship analysis, and binomial test.
#' @export
analyze_first_author <- function(profile_id, last_name) {
  # Fetch publications from Google Scholar
  publications <- fetch_publications(profile_id)

  # Standardize journal names
  publications <- standardize_journals(publications)

  # Filter publications by journal whitelist
  publications <- filter_journals(publications)

  publications <- publications %>%
    mutate(
      Author_Names = strsplit(author, ",\\s|\\s&\\s"),
      Num_Authors = sapply(Author_Names, length)
    ) %>%
    filter(Num_Authors > 1)  # Keep only multi-author publications


  # Extract last names of authors
  extract_last_name <- function(author) {
    name_parts <- strsplit(author, "\\s+")[[1]]
    if (length(name_parts) >= 2) {
      return(name_parts[2])  # Return last name
    } else {
      return(NA)  # Handle edge cases
    }
  }

  publications <- publications %>%
    mutate(Last_Names = lapply(Author_Names, function(authors) {
      sapply(authors, extract_last_name)
    }))

  # Read and process surname distribution
  surname_info <- read_surname_distribution("names.xlsx", last_name)
  before_placeholder_percentage <- surname_info$before_placeholder_percentage

  # Process authorship information
  publications <- process_authorship(publications, last_name, before_placeholder_percentage)

  # Analyze results
  results <- analyze_results(publications)

  return(results)
}
