##ui.R
shinyUI(
    pageWithSidebar(
        # Application title
        headerPanel("Diabetes prediction"),
        
        sidebarPanel(
            numericInput('glucose', 'Glucose mg/dl', 90, min = 50, max = 200, step = 5),
            numericInput('poop', 'smell stench/cm3', 90, min = 50, max = 200, step = 5), ###ADDED
            submitButton('Submit')
        ),
        mainPanel(
            h3('Results of prediction'),
            h4('You entered'),
            verbatimTextOutput("inputValue"),
            h4('Which resulted in a prediction of '),
            verbatimTextOutput("prediction"),
            h4('Which resulted in a prediction of '),
            verbatimTextOutput("prediction2")
        )
    )
)

# function(input, output) {
#     output$inputValue <- renderPrint({input$glucose})
#     output$prediction <- renderPrint({diabetesRisk(input$glucose)})
# }