## server.R
diabetesRisk <- function(glucose) glucose / 200
stupidRisk <- function(poop) poop*diabetesRisk##ADDED

shinyServer(
    function(input, output) {
        output$inputValue <- renderPrint({input$glucose})
        output$prediction <- renderPrint({diabetesRisk(input$glucose)})
     
    }
    function(input1, output1) {
    output1$prediction2 <- renderPrint({stupidRisk(input1$poop)})###ADDED
    }
)

#setwd("C:/Users/jroberti/Git/courses/09_DevelopingDataProducts/shiny2/predictionModel")
