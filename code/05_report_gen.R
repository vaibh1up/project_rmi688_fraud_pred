# Purpose: Report Generation | Author: Codex Agent | Date: 2026-02-24

options(stringsAsFactors = FALSE)

# Purpose: Load model results with error handling
results_path <- file.path('output', 'tables', 'model_tournament_results.csv')
results_tbl <- tryCatch({
  read.csv(results_path, stringsAsFactors = FALSE)
}, error = function(e) {
  message('ERROR: failed to read model results: ', e$message)
  NULL
})

if (is.null(results_tbl)) {
  quit(status = 1)
}

# Purpose: Identify winning model by max payoff
results_tbl$Payoff <- as.numeric(results_tbl$Payoff)
max_idx <- which.max(results_tbl$Payoff)
win_row <- results_tbl[max_idx, ]

# Purpose: Build draft sections
intro_text <- paste0(
  "Fraud detection balances customer experience with loss prevention. ",
  "This report summarizes the data, cleaning steps, model evaluation, and final recommendation. ",
  "We compare Logistic Regression, a Decision Tree, and Random Forest using a payoff function that ",
  "weights correct and incorrect decisions. The report is organized as follows: ",
  "Data and Methods, Results, and Recommendation.\n"
)

data_methods_text <- paste0(
  "\\subsection*{Data}\n",
  "The dataset contains policyholder demographics, claim attributes, and the binary target ",
  "variable indicating fraud. Cleaning steps included trimming whitespace in character fields, ",
  "converting categorical fields to factors, and removing rows with any missing values. ",
  "Duplicate rows were not removed. Summary statistics are reported in Table~\\ref{tab:eda_summary}. ",
  "The target is imbalanced, with most observations labeled non-fraud.\n\n",
  "\\input{../output/tables/eda_summary.tex}\n\n",
  "The cost-benefit matrix guiding optimization is shown in Table~\\ref{tab:cost_benefit}.\n\n",
  "\\input{../output/tables/cost_benefit.tex}\n\n",
  "\\subsection*{Methods}\n",
  "We fit three models: Logistic Regression (interpretable baseline), Decision Tree (nonlinear splits), ",
  "and Random Forest (ensemble for higher predictive power). Each model was trained on an 80/20 ",
  "stratified split. For each model, thresholds from 0.01 to 0.50 were evaluated, and the threshold ",
  "maximizing total business payoff was selected.\n"
)

results_text <- paste0(
  "Logistic Regression provides interpretable coefficients and stable behavior, but may underfit ",
  "nonlinear relationships. The Decision Tree captures nonlinear splits and interactions, though it ",
  "can be unstable and sensitive to data variation. The Random Forest aggregates many trees to ",
  "improve generalization, at the cost of interpretability.\n\n",
  "Model performance and optimal thresholds under the payoff criterion are summarized in ",
  "Table~\\ref{tab:model_tournament}.\n\n",
  "\\input{../output/tables/model_tournament_results.tex}\n"
)

recommend_text <- paste0(
  "Sensitivity reflects fraud capture, while specificity reflects avoidance of false alarms. ",
  "The payoff function explicitly balances these outcomes by weighting true negatives and false ",
  "negatives more heavily. Based on maximum total business payoff, the selected model is ",
  win_row$Model, " (payoff ", win_row$Payoff, ", sensitivity ",
  sprintf('%.4f', as.numeric(win_row$Sensitivity)), ", specificity ",
  sprintf('%.4f', as.numeric(win_row$Specificity)), "). ",
  "If the penalty for false negatives increases further, models with higher sensitivity would ",
  "become more attractive even at the expense of specificity; if false positives become more costly, ",
  "a more conservative threshold or model might be preferred.\n"
)

# Purpose: Write draft files
if (!dir.exists('draft')) {
  dir.create('draft', recursive = TRUE)
}

cat(intro_text, file = file.path('draft', 'introduction.tex'))
cat(data_methods_text, file = file.path('draft', 'data_methods.tex'))
cat(results_text, file = file.path('draft', 'results.tex'))
cat(recommend_text, file = file.path('draft', 'recommend.tex'))

main_text <- paste0(
  "\\documentclass{article}\n",
  "\\usepackage{booktabs}\n",
  "\\usepackage{graphicx}\n",
  "\\usepackage{geometry}\n",
  "\\usepackage{caption}\n",
  "\\geometry{margin=1in}\n",
  "\\begin{document}\n",
  "\\section*{Introduction}\\input{introduction}\n",
  "\\section*{Data and Methods}\\input{data_methods}\n",
  "\\section*{Results}\\input{results}\n",
  "\\section*{Recommendation}\\input{recommend}\n",
  "\\end{document}\n"
)

cat(main_text, file = file.path('draft', 'main.tex'))

# Purpose: Report results
cat('REPORT_FILES_SAVED:', file.path('draft', 'introduction.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'data_methods.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'results.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'recommend.tex'), '\n')
cat('REPORT_FILES_SAVED:', file.path('draft', 'main.tex'), '\n')

# Purpose: Attempt PDF compilation using tinytex (compile from draft/)
compile_result <- tryCatch({
  if (!requireNamespace('tinytex', quietly = TRUE)) {
    install.packages('tinytex', repos = 'https://cran.rstudio.com')
  }
  if (requireNamespace('tinytex', quietly = TRUE)) {
    old_wd <- getwd()
    on.exit(setwd(old_wd), add = TRUE)
    setwd('draft')
    tinytex::latexmk(file = 'main.tex', pdf_file = 'main.pdf')
    TRUE
  } else {
    FALSE
  }
}, error = function(e) {
  message('ERROR: tinytex compile failed: ', e$message)
  FALSE
})

cat('TINYTEXT_COMPILE_SUCCESS:', compile_result, '\n')
