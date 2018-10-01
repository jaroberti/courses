library(shiny)

shinyServer(
  function(input, output) {
    x <- reactive({as.numeric(input$text1)+100})      
    output$text1 <- renderText({x()      })
    #output$text2 <- renderText({x() + as.numeric(input$text2)})
  }
)


#ui.R 
shinyUI(pageWithSidebar(
    headerPanel("Hello Shiny!"),
    sidebarPanel(
        textInput(inputId="text1", label = "Input Text1"),
        #textInput(inputId="text2", label = "Input Text2")
    ),
    mainPanel(
        p('Output text1'),
        textOutput('text1'),
        #p('Output text2'),
        #textOutput('text2')
    )
))


# shinyServer(
#    function(input, output) {
#        x <- reactive({})      
#        output$text1 <- renderText({as.numeric(input$text1)+100  })
#        output$text2 <- renderText({as.numeric(input$text1)+100 + 
#                                        as.numeric(input$text2)})
#    }
# )
