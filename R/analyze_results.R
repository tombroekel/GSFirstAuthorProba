#' Analyze Results
#'
#' This function summarizes the results of the authorship analysis, comparing observed vs. theoretical shares,
#' first authorship rates, and performing a binomial test.
#'
#' @param publications A data frame containing processed publication data.
#' @param before_placeholder_percentage The percentage of names alphabetically before the target name.
#' @return A list of results, including statistical summaries and tests.
#' @importFrom dplyr summarise mutate
#' @export
analyze_results <- function(publications, before_placeholder_percentage) {
  # Summarize observed vs. theoretical shares
  summary_comparison <- publications %>%
    dplyr::summarise(
      Mean_Observed_Share = mean(Observed_Share_Before, na.rm = TRUE),
      Expected_Share = before_placeholder_percentage,
      Difference = Mean_Observed_Share - Expected_Share,
      Aggregated_Probability_Not_First = mean(Probability_Placeholder_Not_First, na.rm = TRUE)
    )

  # Analyze first authorship
  observed_first_authorship <- publications %>%
    dplyr::summarise(
      Observed_First_Count = sum(Is_First_Author, na.rm = TRUE),
      Total_Coauthored_Publications = n(),
      Observed_First_Author_Share = Observed_First_Count / Total_Coauthored_Publications
    )

  # Aggregate theoretical probability of being first
  aggregated_theoretical_probability <- publications %>%
    dplyr::summarise(
      Aggregated_Probability_Placeholder_First = mean(Probability_Placeholder_First, na.rm = TRUE)
    ) %>%
    dplyr::pull(Aggregated_Probability_Placeholder_First)

  # Perform binomial test
  binomial_test <- binom.test(
    x = observed_first_authorship$Observed_First_Count,
    n = observed_first_authorship$Total_Coauthored_Publications,
    p = aggregated_theoretical_probability,
    alternative = "two.sided"
  )

  return(list(
    Summary_Comparison = summary_comparison,
    Observed_First_Authorship = observed_first_authorship,
    Binomial_Test = binomial_test
  ))
}
