library(shiny)
library(dplyr)
library(tm)

# Load the necessary data
load("uniwordfreq.RData")
load("biwordfreq.RData")
load("triwordfreq.RData")

predict_next_word <- function(input_text) {
  input_text <- tolower(input_text)
  input_words <- unlist(strsplit(input_text, "\\s+"))
  num_words <- length(input_words)
  
  if (num_words >= 2) {
    bigram_prefix <- paste(input_words[(num_words-1):num_words], collapse=" ")
    trigram_match <- triwordfreq %>%
      filter(grepl(paste0("^", bigram_prefix, " "), word)) %>%
      arrange(desc(freq))
    
    if (nrow(trigram_match) > 0) {
      predicted_word <- strsplit(trigram_match$word[1], " ")[[1]][3]
      return(predicted_word)
    }
  }
  
  if (num_words >= 1) {
    unigram_prefix <- paste(input_words[num_words], collapse=" ")
    bigram_match <- biwordfreq %>%
      filter(grepl(paste0("^", unigram_prefix, " "), word)) %>%
      arrange(desc(freq))
    
    if (nrow(bigram_match) > 0) {
      predicted_word <- strsplit(bigram_match$word[1], " ")[[1]][2]
      return(predicted_word)
    }
  }
  
  total_freq <- sum(uniwordfreq$freq)
  uniwordfreq$prob <- uniwordfreq$freq / total_freq
  predicted_word <- sample(uniwordfreq$word, 1, prob = uniwordfreq$prob)
  return(predicted_word)
}

shinyServer(function(input, output) {
  observeEvent(input$submit, {
    req(input$text)
    prediction <- predict_next_word(input$text)
    output$prediction <- renderText({ prediction })
  })
})