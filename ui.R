library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Next Word Prediction App - OL"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("text", "Enter text:", ""),
      actionButton("submit", "Submit"),
      br(),
      h4("Example Inputs:"),
      HTML("
                <ul>
                    <li>new york</li>
                    <li>happy mothers</li>
                    <li>let us</li>
                    <li>two years</li>
                    <li>new</li>
                    <li>right</li>
                    <li>last</li>
                    <li>dont</li>
                    <li>years</li>
                    <li>high</li>
                    <li>first</li>
                    <li>feel</li>
                </ul>
            "),
      br(),
      p("Warning: Don't use apostrophes (') or other special symbols.")
    ),
    
    mainPanel(
      h3("Predicted Next Word:"),
      textOutput("prediction")
    )
  )
))