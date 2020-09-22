#
# This application tries to present an interactive way to calculate Grantham Scores (Grantham, 1974) given
# two Amino Acid Sequences
#
# The Grantham Scores are calculated by using the Grantham Substitution Matrix (https://en.wikipedia.org/wiki/Amino_acid_replacement#Grantham's_distance) and adding the scores.
#

library(shiny)
library(readr)
library(tidyr)

aa_map <- read_csv("src/amino_acid_codon_map.csv")
g_scores <- read_csv("src/grantham_scores.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Grantham Score Calculator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "first_aa",
        choices = sort(unique(aa_map$TRIPLET)),
        label = "Original Amino Acid"
      ),
      selectInput(
        inputId = "second_aa",
        choices = sort(unique(aa_map$TRIPLET)),
        label = "Substituted Amino Acid"
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      textOutput("grantham")
    )
  )
)
