
# === Load Necessary Libraries === #
library(scholar)       # For fetching Google Scholar data
library(openxlsx)      # For reading Excel files
library(tidyverse)     # For data manipulation

# === Define Global Variables === #
profile_id <- "jufWtGoAAAAJ"  # Google Scholar profile ID

# Name to be analyzed last name
placeholder_name <- "Broekel"
scopus_list_path <- "data/scopus_list.xlsx"  # Path to journal whitelist
surname_distribution_path <- "data/names.xlsx"  # Path to surname distribution
journal_mapping_path <- "data/journal_mapping.xlsx"  # Path to journal name mapping

# === Fetch Google Scholar Publications === #
publications <- get_publications(profile_id)

# === Standardize Journal Names Using Mapping File === #
# Load journal name mapping
journal_mapping <- read.xlsx(journal_mapping_path)

# Apply the journal name mapping
publications <- publications %>%
  mutate(journal = case_when(
    journal %in% journal_mapping$original_name ~ journal_mapping$standardized_name[match(journal, journal_mapping$original_name)],
    TRUE ~ journal  # Retain original journal name if not in mapping
  ))

# === Filter by Journal Whitelist === #
journal_list <- read.xlsx(scopus_list_path)
journals <- tolower(unique(journal_list$Source.Title))

# Identify journals to exclude
journals.out <- publications %>%
  filter(!tolower(journal) %in% journals) %>%
  pull(journal) %>%
  unique()

# Filter publications by whitelist
publications <- publications %>%
  filter(tolower(journal) %in% journals)

# === Process Multi-Author Publications === #
# Split author names and count the number of authors
publications <- publications %>%
  mutate(
    Author_Names = strsplit(author, ",\\s|\\s&\\s"),
    Num_Authors = sapply(Author_Names, length)
  ) %>%
  filter(Num_Authors > 1)  # Keep only multi-author publications

# === Extract Last Names === #
extract_last_name <- function(author) {
  name_parts <- strsplit(author, "\\s+")[[1]]
  if (length(name_parts) >= 2) {
    return(name_parts[2])  # Return last name
  } else {
    return(NA)  # Handle edge cases
  }
}

# Apply last name extraction
publications <- publications %>%
  mutate(Last_Names = lapply(Author_Names, function(authors) {
    sapply(authors, extract_last_name)
  }))

# === Load Surname Distribution === #
names <- read.xlsx(surname_distribution_path, sheet = 1)

# Calculate surname frequencies
distribution <- names %>%
  group_by(name) %>%
  summarise(Total_Count = sum(count)) %>%
  mutate(Percentage = Total_Count / sum(Total_Count) * 100)

# Percentage of surnames alphabetically before the placeholder
before_placeholder_percentage <- distribution %>%
  filter(name < placeholder_name) %>%
  summarise(Percentage_Before = sum(Percentage)) %>%
  pull(Percentage_Before) / 100

# === Analyze Alphabetical Position and Authorship === #
publications <- publications %>%
  mutate(
    Num_Coauthors = Num_Authors - 1,  # Exclude placeholder name
    Num_Alphabetically_Before = sapply(
      Last_Names,
      function(last_names) sum(last_names < placeholder_name, na.rm = TRUE)
    ),
    Observed_Share_Before = Num_Alphabetically_Before / Num_Coauthors,
    Probability_Placeholder_First = (1 - before_placeholder_percentage)^Num_Coauthors,
    Probability_Placeholder_Not_First = 1 - Probability_Placeholder_First,
    Is_First_Author = sapply(
      Last_Names,
      function(last_names) {
        if (length(last_names) > 0) {
          return(last_names[1] == placeholder_name)
        }
        return(FALSE)
      }
    )
  )

# === Summarize Results === #
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

aggregated_theoretical_probability <- publications %>%
  summarise(Aggregated_Probability_Placeholder_First = mean(Probability_Placeholder_First, na.rm = TRUE)) %>%
  pull(Aggregated_Probability_Placeholder_First)

binomial_test <- binom.test(
  x = observed_first_authorship$Observed_First_Count,
  n = observed_first_authorship$Total_Coauthored_Publications,
  p = aggregated_theoretical_probability,
  alternative = "two.sided"
)

# === Output Results === #
cat("=== Observed vs. Theoretical Shares ===\n")
print(summary_comparison)

cat("\n=== First Authorship Analysis ===\n")
cat("Observed First Authorship Rate:", observed_first_authorship$Observed_First_Author_Share, "\n")
cat("Theoretical First Authorship Rate:", aggregated_theoretical_probability, "\n")
cat("\n=== Binomial Test Results ===\n")
print(binomial_test)
