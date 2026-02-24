# Purpose: Exploratory Analysis | Author: Codex Agent | Date: 2026-02-24

options(stringsAsFactors = FALSE)

# Purpose: Load raw data with error handling
raw_path <- file.path('data', 'raw', 'training_subsample_30- Inclass Dataset.csv')
read_result <- tryCatch({
  read.csv(raw_path, stringsAsFactors = FALSE)
}, error = function(e) {
  message('ERROR: failed to read raw data: ', e$message)
  NULL
})

if (is.null(read_result)) {
  quit(status = 1)
}

df <- read_result

# Purpose: Cleaning steps (no duplicate removal)
char_cols <- sapply(df, is.character)
if (any(char_cols)) {
  df[char_cols] <- lapply(df[char_cols], function(x) trimws(x))
  df[char_cols] <- lapply(df[char_cols], as.factor)
}

clean_df <- df[complete.cases(df), ]

# Purpose: Save cleaned data
clean_dir <- file.path('data', 'clean')
if (!dir.exists(clean_dir)) {
  dir.create(clean_dir, recursive = TRUE)
}
clean_path <- file.path(clean_dir, 'training_subsample_30_clean.csv')
write.csv(clean_df, clean_path, row.names = FALSE)

# Purpose: Summary statistics for numeric variables
num_cols <- sapply(clean_df, is.numeric)
stats <- data.frame(
  variable = names(clean_df),
  mean = NA_real_,
  median = NA_real_,
  min = NA_real_,
  max = NA_real_,
  p25 = NA_real_,
  p75 = NA_real_,
  stringsAsFactors = FALSE
)

for (i in seq_along(clean_df)) {
  if (num_cols[i]) {
    x <- clean_df[[i]]
    stats[i, 'mean'] <- mean(x, na.rm = TRUE)
    stats[i, 'median'] <- median(x, na.rm = TRUE)
    stats[i, 'min'] <- min(x, na.rm = TRUE)
    stats[i, 'max'] <- max(x, na.rm = TRUE)
    stats[i, 'p25'] <- quantile(x, 0.25, na.rm = TRUE, names = FALSE)
    stats[i, 'p75'] <- quantile(x, 0.75, na.rm = TRUE, names = FALSE)
  }
}

# Purpose: Save summary table to LaTeX
output_dir <- file.path('output', 'tables')
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}
summary_tex <- file.path(output_dir, 'eda_summary.tex')
cost_tex <- file.path(output_dir, 'cost_benefit.tex')

fmt_num <- function(x) {
  if (is.na(x)) {
    return('NA')
  }
  sprintf('%.2f', x)
}

header <- paste0(
  "\\begin{table}[ht]\\centering\n",
  "\\caption{Summary Statistics}\\label{tab:eda_summary}\n",
  "\\begin{tabular}{lrrrrrr}\\toprule\n",
  "Variable & Mean & Median & Min & Max & P25 & P75 \\\\ \\midrule\n"
)
escape_tex <- function(x) {
  gsub("_", "\\_", x, fixed = TRUE)
}

grouped_vars <- list(
  "Identifiers" = c("Claim_ID"),
  "Demographic Features" = c("Age", "Gender"),
  "Policy Characteristics" = c("Policy_Inception_To_Claim", "Years_With_Company", "Policy_Coverage_Type", "Annual_Mileage", "Region"),
  "Incident and Claim Details" = c(
    "Claim_Amount", "Vehicle_Value", "Claim_Amount_Relative", "Number_of_Claimants",
    "Time_of_Incident", "Incident_Day", "Claim_Delay_Days", "Prior_Claims",
    "Vehicle_Age", "Repair_Cost", "Claim_Reason", "Fraudulent"
  )
)

stats_lookup <- stats
rownames(stats_lookup) <- stats_lookup$variable

make_row <- function(var) {
  r <- stats_lookup[var, ]
  sprintf(
    "%s & %s & %s & %s & %s & %s & %s \\\\ ",
    escape_tex(var),
    fmt_num(as.numeric(r[['mean']])),
    fmt_num(as.numeric(r[['median']])),
    fmt_num(as.numeric(r[['min']])),
    fmt_num(as.numeric(r[['max']])),
    fmt_num(as.numeric(r[['p25']])),
    fmt_num(as.numeric(r[['p75']]))
  )
}

rows <- c()
for (grp in names(grouped_vars)) {
  rows <- c(rows, sprintf("\\multicolumn{7}{l}{\\textit{%s}} \\\\", grp))
  for (var in grouped_vars[[grp]]) {
    if (var %in% stats$variable) {
      rows <- c(rows, make_row(var))
    }
  }
}

footer <- "\\bottomrule\\end{tabular}\\end{table}\n"

cat(header, paste(rows, collapse = "\n"), "\n", footer, file = summary_tex, sep = "")

# Purpose: Save cost-benefit matrix table to LaTeX
cost_header <- paste0(
  "\\begin{table}[ht]\\centering\n",
  "\\caption{Cost-Benefit Matrix}\\label{tab:cost_benefit}\n",
  "\\begin{tabular}{lrr}\\toprule\n",
  "Outcome & Type & Value \\\\ \\midrule\n"
)
cost_rows <- paste0(
  "True Positive (TP) & Benefit & 10 \\\\\n",
  "True Negative (TN) & Benefit & 100 \\\\\n",
  "False Positive (FP) & Cost & -50 \\\\\n",
  "False Negative (FN) & Cost & -500 \\\\\n"
)
cost_footer <- "\\bottomrule\\end{tabular}\\end{table}\n"
cat(cost_header, cost_rows, cost_footer, file = cost_tex, sep = "")

# Purpose: Report results
cat('CLEAN_SAVED:', clean_path, '\n')
cat('ROWS_RAW:', nrow(df), '\n')
cat('ROWS_CLEAN:', nrow(clean_df), '\n')
cat('SUMMARY_TABLE_SAVED:', summary_tex, '\n')
cat('COST_TABLE_SAVED:', cost_tex, '\n')

cat('\nSUMMARY_STATS\n')
print(stats, row.names = FALSE)

# Purpose: Class imbalance
cat('\nCLASS_IMBALANCE\n')
if ('Fraudulent' %in% names(clean_df)) {
  counts <- table(clean_df$Fraudulent, useNA = 'ifany')
  props <- round(100 * counts / sum(counts), 2)
  out <- data.frame(class = names(counts), count = as.integer(counts), pct = as.numeric(props))
  print(out, row.names = FALSE)
}
