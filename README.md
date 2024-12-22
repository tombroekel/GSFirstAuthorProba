# Publication Analysis

## Overview

This project provides a comprehensive analysis of authorship patterns in multi-author publications. The script evaluates how often a specific author (placeholder: `AuthorName`) appears as the first author in their co-authored publications, compares this to the theoretical probability based on the alphabetical order of surnames, and performs statistical tests to assess the significance of these patterns.

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

1. Clone the repository:
   ```bash
   git clone git@github.com:tombroekel/GSFirstAuthorProba.git
   ```
2. Open the project in RStudio.

## Prerequisites

Ensure the following R packages are installed:

```R
install.packages(c("scholar", "openxlsx", "tidyverse"))
```

## Files

- `first_author_prob.R`: The main R script for the analysis.
- `data/journal_mapping.xlsx`: Contains mappings for standardizing journal names.
- `data/names.xlsx`: Surname distribution data (e.g., US Census data).
- `data/scopus_list.xlsx`: List of Scopus-indexed journals for filtering publications.
- `.gitignore`: Ensures unnecessary files like `.DS_Store` are not included in the repository.

## Usage

1. **Set Up Google Scholar Profile ID:**
   - Replace the placeholder `profile_id` in `first_author_prob.R` with your Google Scholar profile ID.

2. **Customize Journal Filtering:**
   - Update `data/journal_mapping.xlsx` to map journal names as needed.
   - Ensure `data/scopus_list.xlsx` contains the journals you want to include.

3. **Run the Script:**
   - Open `first_author_prob.R` in RStudio.
   - Execute the script to generate results.

## Outputs

The script produces:
- **Statistical Summaries:** Mean observed and theoretical shares of co-authors alphabetically before the target author.
- **First Authorship Rates:** Observed and theoretical first authorship rates.
- **Binomial Test Results:** p-value and confidence intervals for significance testing.

## Example Workflow

```R
# Load and run the script
source("first_author_prob.R")

# View summarized results
print(summary_comparison)
print(binomial_test)
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributions

Contributions are welcome! If you would like to improve this project, feel free to fork the repository, make changes, and submit a pull request.

## Author

This project was created and maintained by Tom Broekel. For any questions or suggestions, please reach out via GitHub or email.
