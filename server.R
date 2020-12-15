#
# This application tries to present an interactive way to calculate Grantham Scores (Grantham, 1974) given
# two Amino Acid Sequences
#
# The Grantham Scores are calculated by using the Grantham Substitution Matrix (https://en.wikipedia.org/wiki/Amino_acid_replacement#Grantham's_distance) and adding the scores.
#

library(shiny)
library(dplyr)
library(readr)
library(tidyr)
library(glue)
library(stringr)
library(purrr)

aa_col_spec <- cols(
  .default = col_character()
)

g_col_spec <- cols(
  .default = col_character(),
  SCORE = col_double()
)

aa_map <- read_csv("src/amino_acid_codon_map.csv", col_types = aa_col_spec)
g_scores <- read_csv("src/grantham_scores.csv", col_types = g_col_spec)

get_score <- function(first, second) {
  score <- g_scores %>%
    filter(first == FSINGLE, second == SSINGLE) %>%
    unique %>%
    pull(SCORE)
  score
}

get_codons <- function(seq) {
  codons <- str_extract_all(seq, "...", simplify = TRUE)
  codons
}

get_dna_score <- function(first, second) {
  a <- aa_map %>%
    filter(CODON == first) %>%
    pull(SINGLE) %>%
    unique
  b <- aa_map %>%
    filter(CODON == second) %>%
    pull(SINGLE) %>%
    unique
  score <- get_score(a, b)
  score
}

# Define server logic required to draw a histogram
server <- function(input, output) {


  pairwise <- reactive({
    input$submit_button
    score <- g_scores %>%
      filter(FIRST == input$first_aa,
             SECOND == input$second_aa) %>%
      pull(SCORE)

    return(glue("Grantham Score for substituting {input$first_aa} by {input$second_aa} is {score}"))
  })

  aa_seq <- reactive({
    if (str_length(input$first_seq) == str_length(input$second_seq)) {
      comparison_df <- str_split(c(input$first_seq, input$second_seq), "", simplify = T) %>%
        t %>%
        as_tibble(.name_repair = "unique") %>%
        rename(first = ...1,
               second = ...2)

      score <- pmap_dbl(comparison_df, get_score) %>%
        sum

      return(glue("Grantham Score for substituting {input$first_seq} by {input$second_seq} is {score}"))
    } else {
      return("Both Sequences must be of the same length")
    }

  })

  dna_seq <- reactive({
    if (str_length(input$first_dna) %% 3 != 0 |
        str_length(input$second_dna) %% 3 != 0 |
        str_length(input$first_dna) != str_length(input$second_dna)) {
      return("Both Sequences must be of the same length and must not contain a partial codon")
    } else {
      first <- get_codons(input$first_dna)
      second <- get_codons(input$second_dna)

      score <- map2_dbl(first, second, get_dna_score) %>%
        sum

      return(glue("Grantham Score for substituting {input$first_dna} by {input$second_dna} is {score}"))
    }
  })

  output$grantham <- renderText({
    input$submit_button
    out <- isolate(pairwise())
    out
    })
  output$grantham_aa_seq <- renderText({
    input$submit_button
    out <- isolate(aa_seq())
    out
    })
  output$grantham_dna_seq <- renderText({
    input$submit_button
    out <- isolate(dna_seq())
    out
    })
}
