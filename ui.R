#
# This application tries to present an interactive way to calculate Grantham Scores (Grantham, 1974) given
# two Amino Acid Sequences
#
# The Grantham Scores are calculated by using the Grantham Substitution Matrix (https://en.wikipedia.org/wiki/Amino_acid_replacement#Grantham's_distance) and adding the scores.
#

library(shiny)
library(readr)
library(tidyr)


aa_col_spec <- cols(
  SINGLE = col_character(),
  NAME = col_character(),
  TRIPLET = col_character(),
  CODON = col_character()
)

g_col_spec <- cols(
  FIRST = col_character(),
  SECOND = col_character(),
  SCORE = col_double()
)

aa_map <- read_csv("src/amino_acid_codon_map.csv", col_types = aa_col_spec)
g_scores <- read_csv("src/grantham_scores.csv", col_types = g_col_spec)

# Define UI for application that draws a histogram
ui <- fluidPage(

  # Application title
  titlePanel("Grantham Score Calculator"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons(
        inputId = "input_type",
        label = "Select the Type of Data Input",
        choices = c("Pairwise", "Amino Acid Sequence", "Nucleotide Sequence"),
        selected = "Pairwise"
      ),
      conditionalPanel("input.input_type == 'Pairwise'",
                       selectInput(
                         inputId = "first_aa",
                         choices = sort(unique(aa_map$TRIPLET)),
                         label = "Original Amino Acid"
                       ),
                       selectInput(
                         inputId = "second_aa",
                         choices = sort(unique(aa_map$TRIPLET)),
                         label = "Substituted Amino Acid"
                       )),
      conditionalPanel("input.input_type == 'Amino Acid Sequence'",
                       textInput(
                         inputId = "first_seq",
                         label = "Original Amino Acid Sequence",
                         value = "A"
                       ),
                       textInput(
                         inputId = "second_seq",
                         label = "Substituted Amino Acid Sequence",
                         value = "A"
                       )),
      conditionalPanel("input.input_type == 'Nucleotide Sequence'",
                       textInput(
                         inputId = "first_dna",
                         label = "Original Nucleotide Sequence",
                         value = "ATG"
                       ),
                       textInput(
                         inputId = "second_dna",
                         label = "Substituted Nucleotide Sequence",
                         value = "ATG"
                       )),
      actionButton(inputId = "submit_button",
                   label = "Calculate",
                   class = "btn-success"),

    ),

    # Show a plot of the generated distribution
    mainPanel(
      conditionalPanel("input.input_type == 'Pairwise'",
                       textOutput("grantham")),
      conditionalPanel("input.input_type == 'Amino Acid Sequence'",
                       textOutput("grantham_aa_seq")),
      conditionalPanel("input.input_type == 'Nucleotide Sequence'",
                       textOutput("grantham_dna_seq"))
    )
  )
)
