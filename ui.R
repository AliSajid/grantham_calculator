#
# This application tries to present an interactive way to calculate Grantham Scores (Grantham, 1974) given
# two Amino Acid Sequences
#
# The Grantham Scores are calculated by using the Grantham Substitution Matrix (https://en.wikipedia.org/wiki/Amino_acid_replacement#Grantham's_distance) and addding the scores.
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Old Faithful Geyser Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)
