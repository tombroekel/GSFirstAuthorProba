#' Process Authorship Data
#'
#' This function processes authorship information for each publication, calculating co-author statistics
#' and probabilities of first authorship based on alphabetical order.
#'
#' @param publications A data frame containing publication data.
#' @param last_name The last name of the author being analyzed (e.g., "Broekel").
#' @param before_placeholder_percentage The percentage of surnames alphabetically before the author's last name.
#' @return A data frame with additional columns for authorship analysis.
#' @export
process_authorship <- function(publications, last_name, before_placeholder_percentage) {
  # Check if `Last_Names` column exists
  if (!"Last_Names" %in% names(publications)) {
    stop("Column `Last_Names` is missing in the `publications` data frame.")
  }

  # Ensure `Num_Authors` exists
  if (!"Num_Authors" %in% names(publications)) {
    stop("Column `Num_Authors` is missing in the `publications` data frame.")
  }

  # Process authorship data
  publications <- publications %>%
    mutate(
      # Number of co-authors excluding the analyzed author
      Num_Coauthors = Num_Authors - 1,

      # Count the number of co-authors alphabetically before the analyzed author
      Num_Alphabetically_Before = sapply(
        Last_Names,
        function(last_names) sum(last_names < last_name, na.rm = TRUE)
      ),

      # Calculate observed share of co-authors alphabetically before the analyzed author
      Observed_Share_Before = Num_Alphabetically_Before / Num_Coauthors,

      # Theoretical probability the analyzed author is the first author
      Probability_Placeholder_First = (1 - before_placeholder_percentage)^Num_Coauthors,

      # Theoretical probability the analyzed author is not the first author
      Probability_Placeholder_Not_First = 1 - Probability_Placeholder_First,

      # Determine if the analyzed author is the first author
      Is_First_Author = sapply(
        Last_Names,
        function(last_names) {
          if (length(last_names) > 0) {
            return(last_names[1] == last_name)
          }
          return(FALSE)
        }
      )
    )

  return(publications)
}
