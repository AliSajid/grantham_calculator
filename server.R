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

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white')
  })
}

# Run the application
