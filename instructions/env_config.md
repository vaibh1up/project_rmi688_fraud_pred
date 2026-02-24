# Environment & Coding Style

## 1. R Environment
- **Package Manager:** Use `renv` if possible, otherwise standard `install.packages()`.
- **Core Libraries:** - Data Wrangling: `tidyverse`, `datatable`
  - Modeling: `tidymodels`, `randomForest`
  - Econometrics/Tables: `fixest`, `modelsummary`
  - LaTeX Output: `stargazer` or `xtable`
  - Plotting: always use ggplot

## 2. Package Installation Fail-safe (Bootstrap)
- **Primary Method:** Use `pacman::p_load()` for all library loading.
- **Dependency:** If `pacman` is not installed, install it using: 
  `install.packages("pacman", repos = "https://cran.rstudio.com")`.
- **Repository Setting:** Always explicitly set the CRAN mirror at the start of any setup script to avoid connection timeouts:
  `options(repos = c(CRAN = "https://cran.rstudio.com"))`.

## 3. Coding Style
- **Naming:** Use `snake_case` for all variables and functions.
- **Pipe:** Use the native R pipe `|>` or `%>%`.
- **Comments:** Every code block must begin with a `# Purpose:` comment.
- **Robustness:** Wrap data loading in `tryCatch()` to handle missing files gracefully.

## 4. LaTeX Requirements
- All generated tables must use the `booktabs` package style.
- Ensure all mathematical symbols in table headers are wrapped in `$...$`.
- Use `cat()` in R to export `.tex` files directly to the `/output` folder.