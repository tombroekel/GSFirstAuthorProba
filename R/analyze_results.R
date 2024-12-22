#' Analyze Results
#'
#' This function calculates summary statistics and performs statistical tests on the processed publications data.
#'
#' @param publications A data frame of processed publications.
#' @return A list of results including observed vs theoretical shares, first authorship analysis, and binomial test.
#' @export
analyze_results <- function(publications) {
  summary_comparison <- publications %>%
    summarise(
      Mean_Observed_Share = mean(Observed_Share_Before, na.rm = TRUE),
      Expected_Share = before_placeholder_percentage,
      Difference = Mean_Observed_Share - Expected_Share,
      Aggregated_Probability_Not_First = mean(Probability_Placeholder_Not_First, na.rm = TRUE)
    )

  observed_first_authorship <- publications %>%
    summarise(
      Observed_First_Count = sum(Is_First_Author, na.rm = TRUE),
      Total_Coauthored_Publications = n(),
      Observed_First_Author_Share = Observed_First_Count / Total_Coauthored_Publications
    )

  binomial_test <- binom.test(
    x = observed_first_authorship$Observed_First_Count,
    n = observed_first_authorship$Total_Coauthored_Publications,
    p = mean(publications$Probability_Placeholder_First, na.rm = TRUE),
    alternative = "two.sided"
  )

  list(
    Summary_Comparison = summary_comparison,
    Observed_First_Authorship = observed_first_authorship,
    Binomial_Test = binomial_test
  )
}
