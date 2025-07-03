library(tidyverse)

# List all CSV files in the current project folder
csv_files <- list.files(pattern = "\\.csv$")  # Looks only in current directory

# Function to read each CSV and add a city column from the filename
read_with_location <- function(file) {
  city <- tools::file_path_sans_ext(basename(file))  # Remove .csv extension
  read_csv(file) |> mutate(city = city)
}

# Combine all CSVs into one tibble
combined_airbnb <- map_dfr(csv_files, read_with_location)

# Optional: Write the result to a new CSV
write_csv(combined_airbnb, "combined_airbnb.csv")

# View the result
glimpse(combined_airbnb)

# Create the folder (only if it doesn't exist)
if (!dir.exists("raw_csvs")) {
  dir.create("raw_csvs")
}

# Move all CSV files into that folder
csv_files <- list.files(pattern = "\\.csv$")
file.rename(from = csv_files, to = file.path("raw_csvs", csv_files))

