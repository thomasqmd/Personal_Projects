# setup
library(tidyverse)
library(httr)
library(rvest)
library(xml2)
library(stringr)
library(readr)

# function to pull summer Olympics medal table for all years from wikipedia
get_table <- \(year){
  
  # url for wikipedia
  url <- paste0("https://en.wikipedia.org/wiki/", year, "_Summer_Olympics_medal_table") 
  
  # reads page
  page <- read_html(url)
  Sys.sleep(.1)
  
  # Obtain the piece of the web page that corresponds to the "wikitable" node
  mytable <- html_node(page, ".wikitable")
  
  # Convert the html table element into a data frame
  mytable <- html_table(mytable, fill = TRUE)
  
  # convert total column to integer
  mytable$Total <- mytable$Total |> as.integer()
  
  # replace single total value that was coerced to NA
  if(year == 2020){
    mytable$Total[94] <- 1080
  }
  # Set column names
  names(mytable) <- c("Rank", "NOC", "Gold", "Silver", "Bronze", "Total")
  
  # Add year column
  mytable |> mutate(
    Year = year
  )
}

# sequence throughout olympic years
years <- seq(1896, 2024, by = 4)

# drop years without olympics
years <- years[-c(6,12,13)]

# produce talbes for each year and bind to one table
tbs <- map(years, get_table) |>
  bind_rows()

# remove non alphabetic or space characters from Name of Country column
tbs$NOC <- str_extract(tbs$NOC, "^[a-zA-Z\\s]*")

# Coerce rank column to numeric
tbs$Rank <- tbs$Rank |> as.numeric()

# Removes "total medal" rows
tbs <- tbs |> drop_na()

# view table
#view(tbs)

# Write csv in current directory
tbs |> write_csv("Olympic-medal-counts.csv")
