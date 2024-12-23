#' Read and Process Surname Distribution
#'
#' This function reads the surname distribution data from an Excel file and calculates
#' the percentage of names alphabetically before a specified name.
#'
#' @param placeholder_name The name to use for alphabetical comparison.
#' @return A list containing the distribution data and the percentage of names before the placeholder.
#' @export
read_surname_distribution <- function(placeholder_name) {
  # Locate the surname distribution file within the installed package
  file_path <- system.file("extdata", "names.xlsx", package = "GSFirstAuthorProba")

  # Read surname distribution data
  surname_data <- openxlsx::read.xlsx(file_path, sheet = 1)

  # Calculate distribution percentages
  distribution <- surname_data %>%
    group_by(name) %>%
    summarise(Total_Count = sum(count)) %>%
    mutate(Percentage = Total_Count / sum(Total_Count) * 100)

  # Calculate the percentage of names alphabetically before the placeholder name
  before_placeholder_percentage <- distribution %>%
    filter(name < placeholder_name) %>%
    summarise(Percentage_Before = sum(Percentage)) %>%
    pull(Percentage_Before) / 100

  return(list(
    distribution = distribution,
    before_placeholder_percentage = before_placeholder_percentage
  ))
}

