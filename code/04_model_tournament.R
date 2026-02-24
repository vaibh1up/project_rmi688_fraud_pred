# Purpose: Model Tournament & Economic Optimization | Author: Codex Agent | Date: 2026-02-24

options(stringsAsFactors = FALSE)

# Purpose: Load required libraries
suppressPackageStartupMessages({
  library(tidymodels)
  library(randomForest)
})

# Purpose: Load cleaned data with error handling
clean_path <- file.path('data', 'clean', 'training_subsample_30_clean.csv')
read_result <- tryCatch({
  read.csv(clean_path, stringsAsFactors = FALSE)
}, error = function(e) {
  message('ERROR: failed to read clean data: ', e$message)
  NULL
})

if (is.null(read_result)) {
  quit(status = 1)
}

df <- read_result

# Purpose: Ensure target is factor with 0/1 levels
if (!'Fraudulent' %in% names(df)) {
  message('ERROR: Fraudulent column not found')
  quit(status = 1)
}

df$Fraudulent <- factor(df$Fraudulent, levels = c(0, 1))

# Purpose: Convert character predictors to factor
char_cols <- sapply(df, is.character)
if (any(char_cols)) {
  df[char_cols] <- lapply(df[char_cols], as.factor)
}

# Purpose: Stratified 80/20 split
set.seed(123)
split_obj <- initial_split(df, prop = 0.80, strata = Fraudulent)
train_df <- training(split_obj)
test_df <- testing(split_obj)

# Purpose: Define models
logit_spec <- logistic_reg(mode = 'classification') |>
  set_engine('glm')

cart_spec <- decision_tree(mode = 'classification') |>
  set_engine('rpart')

rf_spec <- rand_forest(mode = 'classification', trees = 500) |>
  set_engine('randomForest')

# Purpose: Fit models with error handling
fit_model <- function(spec, data) {
  tryCatch({
    fit(spec, Fraudulent ~ ., data = data)
  }, error = function(e) {
    message('ERROR: model fit failed: ', e$message)
    NULL
  })
}

logit_fit <- fit_model(logit_spec, train_df)
cart_fit <- fit_model(cart_spec, train_df)
rf_fit <- fit_model(rf_spec, train_df)

if (is.null(logit_fit) || is.null(cart_fit) || is.null(rf_fit)) {
  quit(status = 1)
}

# Purpose: Threshold optimization (maximize payoff)
vtp <- 10
vtn <- 100
vfp <- -50
vfn <- -500
thresholds <- seq(0.01, 0.50, by = 0.01)

calc_metrics <- function(truth, prob) {
  results <- data.frame(threshold = thresholds, tp = 0, tn = 0, fp = 0, fn = 0, payoff = 0)
  for (i in seq_along(thresholds)) {
    thr <- thresholds[i]
    pred <- factor(ifelse(prob >= thr, 1, 0), levels = c(0, 1))
    tp <- sum(truth == 1 & pred == 1)
    tn <- sum(truth == 0 & pred == 0)
    fp <- sum(truth == 0 & pred == 1)
    fn <- sum(truth == 1 & pred == 0)
    payoff <- (tp * vtp) + (tn * vtn) + (fp * vfp) + (fn * vfn)
    results[i, c('tp','tn','fp','fn','payoff')] <- c(tp, tn, fp, fn, payoff)
  }
  results
}

get_prob <- function(fit_obj, data) {
  pred <- predict(fit_obj, new_data = data, type = 'prob')
  as.numeric(pred$.pred_1)
}

truth <- as.numeric(as.character(test_df$Fraudulent))

logit_prob <- get_prob(logit_fit, test_df)
cart_prob <- get_prob(cart_fit, test_df)
rf_prob <- get_prob(rf_fit, test_df)

logit_metrics <- calc_metrics(truth, logit_prob)
cart_metrics <- calc_metrics(truth, cart_prob)
rf_metrics <- calc_metrics(truth, rf_prob)

best_row <- function(metrics) {
  metrics[which.max(metrics$payoff), ]
}

best_logit <- best_row(logit_metrics)
best_cart <- best_row(cart_metrics)
best_rf <- best_row(rf_metrics)

calc_sens_spec <- function(truth, prob, thr) {
  pred <- factor(ifelse(prob >= thr, 1, 0), levels = c(0, 1))
  tp <- sum(truth == 1 & pred == 1)
  tn <- sum(truth == 0 & pred == 0)
  fp <- sum(truth == 0 & pred == 1)
  fn <- sum(truth == 1 & pred == 0)
  sensitivity <- ifelse((tp + fn) == 0, NA, tp / (tp + fn))
  specificity <- ifelse((tn + fp) == 0, NA, tn / (tn + fp))
  list(tp = tp, tn = tn, fp = fp, fn = fn, sensitivity = sensitivity, specificity = specificity)
}

logit_eval <- calc_sens_spec(truth, logit_prob, best_logit$threshold)
cart_eval <- calc_sens_spec(truth, cart_prob, best_cart$threshold)
rf_eval <- calc_sens_spec(truth, rf_prob, best_rf$threshold)

# Purpose: Assemble results table
results_tbl <- data.frame(
  Model = c('Logistic Regression', 'Decision Tree', 'Random Forest'),
  Threshold = c(best_logit$threshold, best_cart$threshold, best_rf$threshold),
  Payoff = c(best_logit$payoff, best_cart$payoff, best_rf$payoff),
  TP = c(logit_eval$tp, cart_eval$tp, rf_eval$tp),
  TN = c(logit_eval$tn, cart_eval$tn, rf_eval$tn),
  FP = c(logit_eval$fp, cart_eval$fp, rf_eval$fp),
  FN = c(logit_eval$fn, cart_eval$fn, rf_eval$fn),
  Sensitivity = c(logit_eval$sensitivity, cart_eval$sensitivity, rf_eval$sensitivity),
  Specificity = c(logit_eval$specificity, cart_eval$specificity, rf_eval$specificity)
)

# Purpose: Save results table to LaTeX (booktabs)
output_dir <- file.path('output', 'tables')
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}
output_file <- file.path(output_dir, 'model_tournament_results.tex')
output_csv <- file.path(output_dir, 'model_tournament_results.csv')

header <- paste0(
  "\\begin{table}[ht]\\centering\n",
  "\\caption{Model Tournament Results}\\label{tab:model_tournament}\n",
  "\\begin{tabular}{lrrrrrrrr}\\toprule\n",
  "Model & Threshold & Payoff & $TP$ & $TN$ & $FP$ & $FN$ & Sensitivity & Specificity \\\\ \\midrule\n"
)
rows <- apply(results_tbl, 1, function(r) {
  sprintf(
    "%s & %.2f & %.0f & %d & %d & %d & %d & %.4f & %.4f \\\\ ",
    r[['Model']], as.numeric(r[['Threshold']]), as.numeric(r[['Payoff']]),
    as.integer(r[['TP']]), as.integer(r[['TN']]), as.integer(r[['FP']]), as.integer(r[['FN']]),
    as.numeric(r[['Sensitivity']]), as.numeric(r[['Specificity']])
  )
})
footer <- "\\bottomrule\\end{tabular}\\end{table}\n"

cat(header, paste(rows, collapse = "\n"), "\n", footer, file = output_file, sep = "")
write.csv(results_tbl, output_csv, row.names = FALSE)

# Purpose: Report results
cat('MODEL_RESULTS\n')
cat('LOGIT_BEST_THRESHOLD:', best_logit$threshold, 'MAX_PAYOFF:', best_logit$payoff, '\n')
cat('LOGIT_CONFUSION:', 'TP', logit_eval$tp, 'TN', logit_eval$tn, 'FP', logit_eval$fp, 'FN', logit_eval$fn, '\n')
cat('LOGIT_SENS_SPEC:', logit_eval$sensitivity, logit_eval$specificity, '\n\n')

cat('CART_BEST_THRESHOLD:', best_cart$threshold, 'MAX_PAYOFF:', best_cart$payoff, '\n')
cat('CART_CONFUSION:', 'TP', cart_eval$tp, 'TN', cart_eval$tn, 'FP', cart_eval$fp, 'FN', cart_eval$fn, '\n')
cat('CART_SENS_SPEC:', cart_eval$sensitivity, cart_eval$specificity, '\n\n')

cat('RF_BEST_THRESHOLD:', best_rf$threshold, 'MAX_PAYOFF:', best_rf$payoff, '\n')
cat('RF_CONFUSION:', 'TP', rf_eval$tp, 'TN', rf_eval$tn, 'FP', rf_eval$fp, 'FN', rf_eval$fn, '\n')
cat('RF_SENS_SPEC:', rf_eval$sensitivity, rf_eval$specificity, '\n')

cat('RESULTS_TABLE_SAVED:', output_file, '\n')
cat('RESULTS_CSV_SAVED:', output_csv, '\n')
