# Environment & Coding Style

## 1. R Environment
- **Package Manager:** Use `renv` if possible, otherwise standard `install.packages()`.
- **Core Libraries:** - Data Wrangling: `tidyverse`
  - Modeling: `tidymodels`, `xgboost`, `randomForest`
  - Econometrics/Tables: `fixest`, `modelsummary`
  - LaTeX Output: `stargazer` or `xtable`

## 2. Coding Style
- **Naming:** Use `snake_case` for all variables and functions.
- **Pipe:** Use the native R pipe `|>` or `%>%`.
- **Comments:** Every code block must begin with a `# Purpose:` comment.
- **Robustness:** Wrap data loading in `tryCatch()` to handle missing files gracefully.

## 3. LaTeX Requirements
- All generated tables must use the `booktabs` package style.
- Ensure all mathematical symbols in table headers are wrapped in `$...$`.
- Use `cat()` in R to export `.tex` files directly to the `/output` folder.