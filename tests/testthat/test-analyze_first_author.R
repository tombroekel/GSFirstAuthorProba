# Load the package and testthat
library(testthat)
library(GSFirstAuthorProba)

test_that("analyze_first_author works as expected", {
  # Run the main function
  results <- analyze_first_author(profile_id = "jufWtGoAAAAJ", last_name = "Broekel")

  # Check if results are a list
  expect_type(results, "list")

  # Test if the list contains expected elements
  expect_named(results, c("Summary_Comparison", "Observed_First_Authorship", "Binomial_Test"))

  # Validate the structure of Summary_Comparison
  expect_true(is.data.frame(results$Summary_Comparison))
  expect_named(
    results$Summary_Comparison,
    c("Mean_Observed_Share", "Expected_Share", "Difference", "Aggregated_Probability_Not_First")
  )

  # Validate Observed_First_Authorship structure
  expect_true(is.data.frame(results$Observed_First_Authorship))
  expect_named(
    results$Observed_First_Authorship,
    c("Observed_First_Count", "Total_Coauthored_Publications", "Observed_First_Author_Share")
  )
  expect_gt(results$Observed_First_Authorship$Observed_First_Author_Share, 0)

  # Validate the Binomial Test result
  expect_s3_class(results$Binomial_Test, "htest")
  expect_true(results$Binomial_Test$p.value > 0)  # p-value should be numeric and positive
})

