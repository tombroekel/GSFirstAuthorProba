# Publication Analysis

## Overview

This project provides a comprehensive analysis of authorship patterns in multi-author publications. The package evaluates how often a specific author (placeholder: `AuthorName`) appears as the first author in their co-authored publications, compares this to the theoretical probability based on the alphabetical order of surnames, and performs statistical tests to assess the significance of these patterns.

The project uses:
- Author information fetched from Google Scholar.
- Surname distribution data from a reference dataset (e.g., US Census data).
- A journal mapping file to standardize journal names.

## Features

- **Alphabetical Analysis:** Determines the probability that an author is first based on alphabetical order of last names.
- **Observed vs. Expected Comparison:** Compares observed first authorship rates with theoretical expectations.
- **Statistical Tests:** Performs a binomial test to assess the significance of observed first authorship patterns.
- **Customizable Journal Filter:** Allows filtering of publications to include only those from a specified list of journals.

## Installation

You can install the package directly from GitHub:

```r
# Install the 'devtools' package if not already installed
install.packages("devtools")

# Install the GSFirstAuthorProba package
devtools::install_github("tombroekel/GSFirstAuthorProba")
```

## Prerequisites

Ensure the following R packages are installed:

```r
install.packages(c("scholar", "openxlsx", "tidyverse"))
```

## Files

- **R Functions:**
  - `analyze_first_author.R`: Main function to run the analysis.
  - `process_authorship.R`: Processes authorship data for analysis.
  - `standardize_journals.R`: Standardizes journal names.
  - `read_surname_distribution.R`: Reads and processes surname distribution data.
- **Data Files:**
  - `data/journal_mapping.xlsx`: Contains mappings for standardizing journal names.
  - `data/names.xlsx`: Surname distribution data (e.g., US Census data).
  - `data/scopus_list.xlsx`: List of Scopus-indexed journals for filtering publications.
- `.gitignore`: Ensures unnecessary files like `.DS_Store` are not included in the repository.

## Usage

1. **Load the Package:**
   ```r
   library(GSFirstAuthorProba)
   ```

2. **Run the Analysis:**
   Use the `analyze_first_author` function:
   ```r
   results <- analyze_first_author(
       profile_id = "jufWtGoAAAAJ",  # Replace with your Google Scholar profile ID
       last_name = "AuthorName"      # Replace with your last name
   )
   ```

3. **View Results:**
   ```r
   # Print summarized results
   print(results$Summary_Comparison)

   # Print binomial test
   print(results$Binomial_Test)
   ```

4. **Customize Journal Filtering:**
   - Update `data/journal_mapping.xlsx` to map journal names as needed.
   - Ensure `data/scopus_list.xlsx` contains the journals you want to include.

## Outputs

The analysis produces:
- **Statistical Summaries:** Mean observed and theoretical shares of co-authors alphabetically before the target author.
- **First Authorship Rates:** Observed and theoretical first authorship rates.
- **Binomial Test Results:** p-value and confidence intervals for significance testing.

## Example Workflow

```r
# Load the package
library(GSFirstAuthorProba)

# Run the analysis
results <- analyze_first_author(profile_id = "jufWtGoAAAAJ", last_name = "AuthorName")

# View summarized results
print(results$Summary_Comparison)
print(results$Binomial_Test)
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributions

Contributions are welcome! If you would like to improve this project, feel free to fork the repository, make changes, and submit a pull request.

## Author

This project was created and maintained by Tom Broekel. For any questions or suggestions, please reach out via GitHub or email.
