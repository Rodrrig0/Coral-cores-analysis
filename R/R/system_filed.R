library(shiny)

ui <- fluidPage(
  actionButton("btn1", "Are you sure ?"),
  uiOutput("btn2"),
  uiOutput("btn3"),
  uiOutput("btn4"),
  verbatimTextOutput("text1"),
  uiOutput("btn5"),
  verbatimTextOutput("text2"),
  uiOutput("btn6"),
  verbatimTextOutput("text3"),
  uiOutput("btn7"),
  uiOutput("text4")
)

server <- function(input, output, session) {
  observeEvent(input$btn1, {
    output$btn2 <- renderUI({
      actionButton("btn2", "Are you really sure ?")
    })
  })
  observeEvent(input$btn2, {
    output$btn3 <- renderUI({
      actionButton("btn3", "Are you really really sure ?")
    })
  })
  observeEvent(input$btn3, {
    output$btn4 <- renderUI({
      actionButton("btn4", "There will be no come back")
    })
  })
  observeEvent(input$btn4,{
    output$text1 <- renderText({
      "You give me butterflies <3"
    })
    output$btn5 <- renderUI({
      actionButton("btn5", "what do you mean?")
    })
  })
  observeEvent(input$btn5,{
    output$text2 <- renderText({
      "Mit dir ist die Welt schöner"
    })
    output$btn6 <- renderUI({
      actionButton("btn6", "Synonyme please")
    })
  })
  observeEvent(input$btn6,{
    output$text3 <- renderText({
      "Me muero por verte"
    })
    output$btn7 <- renderUI({
      actionButton("btn7", "Get to the point!")
    })
  })
  observeEvent(input$btn7,{
    output$text4 <- renderText({
      "I have a critical crush on you - Romain"
    })
  })
}

shinyApp(ui, server)
