library(tidyverse)

# Step 0: Delete previous combined file if it exists
if (file.exists("raw_csvs/airbnb_combined.csv")) {
  file.remove("raw_csvs/airbnb_combined.csv")
}

# Step 1: Get all relevant CSVs
csv_files <- list.files("raw_csvs", pattern = "\\.csv$", full.names = TRUE)
csv_files <- csv_files[!str_detect(csv_files, "airbnb_combined\\.csv")]

# Step 2: Combine files and clean up names
combined_data <- map_dfr(csv_files, function(file_path) {
  file_name <- tools::file_path_sans_ext(basename(file_path))  # e.g., "amsterdam_weekday"
  
  # Fix 1: Extract day_type based on suffix
  day_type <- case_when(
    str_ends(file_name, "_weekdays") ~ "Weekday",
    str_ends(file_name, "_weekends") ~ "Weekend",
    TRUE ~ NA_character_
  )
  
  # Fix 2: Remove _weekday/_weekend from the city name
  city <- str_remove(file_name, "_(weekdays|weekends)$")
  
  # Read and append metadata
  read_csv(file_path, show_col_types = FALSE) |>
    mutate(city = city, day_type = day_type)
})

# Step 3: Save to combined file
write_csv(combined_data, "raw_csvs/airbnb_combined.csv")


