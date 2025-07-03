library(tidyverse)

# Read only raw input files from subfolder
csv_files <- list.files("raw_csvs/", pattern = "\\.csv$", full.names = TRUE)

read_with_location <- function(file) {
  city <- tools::file_path_sans_ext(basename(file))
  read_csv(file) |> mutate(city = city)
}

combined_airbnb <- map_dfr(csv_files, read_with_location)

# Save output at project root
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

