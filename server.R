#
# This application tries to present an interactive way to calculate Grantham Scores (Grantham, 1974) given
# two Amino Acid Sequences
#
# The Grantham Scores are calculated by using the Grantham Substitution Matrix (https://en.wikipedia.org/wiki/Amino_acid_replacement#Grantham's_distance) and addding the scores.
#

library(shiny)
library(dplyr)
library(readr)
library(tidyr)
library(glue)

aa_map <- read_csv("src/amino_acid_codon_map.csv")
g_scores <- read_csv("src/grantham_scores.csv")

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$grantham <- renderText({
    score <- g_scores %>%
      filter(FIRST == input$first_aa,
             SECOND == input$second_aa) %>%
      pull(SCORE)

    return(glue("Grantham Score for substituting {input$first_aa} by {input$second_aa} is {score}"))
  })
}
