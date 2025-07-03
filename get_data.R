library(tidyverse)

files <- list.files(pattern = "\\.csv$")

file.rename(files, file.path("raw_csvs", files))
