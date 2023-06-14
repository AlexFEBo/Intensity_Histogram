# Test script for generating histogram

library(tidyverse)
library(here)
library(readxl)
library(plotly)

# Setting up Here package

here::i_am("Intensity_Histogram.Rproj")

# Read the data

df <- readxl::read_excel("data", "raw_data")
  ## Not working need to be adjusted

# See:
  # https://joachimgoedhart.github.io/DataViz-protocols/complete-protocols.html#protocol-10

  # Histogram

p <-  ggplot(df,aes(x=Value)) + geom_histogram(binwidth = 5)  # Plot creation
view(p)  # Plot Visualization 

  # Interactive

ggplotly(p)

  # Density plot
  ggplot(df_count, aes(x=Value)) + geom_density(alpha = 0.5)
  
  
  # Save plot
  
  ggsave(filename = here("output", "histogram.png"))
  