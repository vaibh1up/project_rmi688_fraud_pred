# Purpose: Data Audit | Author: Codex Agent | Date: 2026-02-23

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

# Purpose: Verify header against specification
expected_header <- c(
  'Claim_ID','Age','Gender','Policy_Inception_To_Claim','Years_With_Company',
  'Claim_Amount','Vehicle_Value','Claim_Amount_Relative','Number_of_Claimants',
  'Time_of_Incident','Incident_Day','Claim_Delay_Days','Prior_Claims','Region',
  'Vehicle_Age','Policy_Coverage_Type','Annual_Mileage','Repair_Cost','Claim_Reason','Fraudulent'
)
actual_header <- names(df)

header_match <- identical(actual_header, expected_header)
cat('HEADER_MATCH:', header_match, '\n')

if (!header_match) {
  missing_cols <- setdiff(expected_header, actual_header)
  extra_cols <- setdiff(actual_header, expected_header)
  cat('MISSING_COLS:', paste(missing_cols, collapse = ', '), '\n')
  cat('EXTRA_COLS:', paste(extra_cols, collapse = ', '), '\n')
}

# Purpose: Show first 5 rows for audit
cat('\nFIRST_5_ROWS\n')
print(utils::head(df, 5))
