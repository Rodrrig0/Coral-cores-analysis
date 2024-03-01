ui <- fluidPage(
  titlePanel("Maximum points selection"),
  plotOutput("scatterplot", click = "plot_click"),
  verbatimTextOutput("selected_points"),
  actionButton("save_points", "Save Points")
)

server <- function(input, output) {
  # Afficher le graphique
  output$scatterplot <- renderPlot({
    ggplot(data_srca, aes(Distance.from.the.top..mm., Sr407.Ca317)) + geom_line()
  })

  # Enregistrer les points cliqués
  selected_points <- reactiveValues(points = data.frame(x = numeric(0), y = numeric(0)))

  observeEvent(input$plot_click, {
    click <- input$plot_click
    if (!is.null(click)) {
      x <- click$x
      y <- click$y
      point <- data.frame(x = x, y = y)
      selected_points$points <- rbind(selected_points$points, point)
    }
  })

  # Afficher les points sélectionnés
  output$selected_points <- renderPrint({
    selected_points$points
  })

  # Enregistrer les points sélectionnés dans l'environnement R
  observeEvent(input$save_points, {
    assign("selected_max_points_data", selected_points$points, envir = .GlobalEnv)
  })
}

shinyApp(ui = ui, server = server)

