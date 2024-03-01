library(ggplot2)
library(shiny)

# Interface utilisateur Shiny
ui <- fluidPage(
  titlePanel("Manual peaks selection program"),
  tabsetPanel(
    tabPanel("Minimum and maximum selection",plotOutput("min_scatterplot", click = "plot_min_click"),
              # Graphique pour la sélection des points maximaux
              plotOutput("max_scatterplot", click = "plot_max_click"),
              # Bouton pour signaler la fin de la sélection
              dateInput("sampling_date", "Sampling Date"),
              numericInput("min_SST_month", "Minimum SST Month", value = 0),
              numericInput("max_SST_month", "Maximum SST Month", value = 0)),
    tabPanel("Result tables", verbatimTextOutput("selected_points"),
             actionButton("finishButton", "Finish"),
             verbatimTextOutput("finishMessage"))
  )

  )
  # Graphique pour la sélection des points minimaux


# Logique du serveur Shiny
server <- function(input, output) {

  # Initialiser les listes pour les points minimaux et maximaux
  min_points <- reactiveVal(data.frame(x = numeric(0), y = numeric(0)))
  max_points <- reactiveVal(data.frame(x = numeric(0), y = numeric(0)))

  # Réagir au clic sur le graphique pour la sélection des points minimaux
  observeEvent(input$plot_min_click, {
    click <- input$plot_min_click
    if (!is.null(click)) {
      x <- click$x
      y <- click$y
      min_points_data <- min_points()
      min_points_data <- rbind(min_points_data, data.frame(x = x, y = y))
      min_points(min_points_data)
    }
  })

  # Réagir au clic sur le graphique pour la sélection des points maximaux
  observeEvent(input$plot_max_click, {
    click <- input$plot_max_click
    if (!is.null(click)) {
      x <- click$x
      y <- click$y
      max_points_data <- max_points()
      max_points_data <- rbind(max_points_data, data.frame(x = x, y = y))
      max_points(max_points_data)
    }
  })

  # Enregistrer les données lorsque le bouton "Terminer" est cliqué
  observeEvent(input$finishButton, {
    # Définir le message à afficher
    message <- "Selection completed"
    # Mettre à jour le texte à afficher
    output$finishMessage <- renderText({
      message
    })
    assign("samplingdate",input$sampling_date, envir = .GlobalEnv)
    assign("min_SST_month",input$min_SST_month, envir = .GlobalEnv)
    assign("max_SST_month",input$max_SST_month, envir = .GlobalEnv)

  })
    # Vous pouvez également imprimer les points sélectionnés si nécessaire


  # Afficher le graphique pour la sélection des points minimaux
  output$min_scatterplot <- renderPlot({
    ggplot(data_srca, aes(Distance.from.the.top..mm., Sr407.Ca317)) +
      geom_line() +
      scale_y_reverse()+
      geom_point(data = min_points(), aes(x = x, y = y), color = "red") +
      labs(title = "Minimum peaks selection")
  })

  # Afficher le graphique pour la sélection des points maximaux
  output$max_scatterplot <- renderPlot({
    ggplot(data_srca, aes(Distance.from.the.top..mm., Sr407.Ca317)) +
      geom_line() +
      scale_y_reverse()+
      geom_point(data = max_points(), aes(x = x, y = y), color = "blue") +
      labs(title = "Manimum peaks selection")
  })
  output$selected_points <- renderPrint({
    list(min_points = min_points(), max_points = max_points())
  })

  observeEvent(c(min_points(), max_points()), {
    assign("min_points_data", min_points(), envir = .GlobalEnv)
    assign("max_points_data", max_points(), envir = .GlobalEnv)
  })
}

# Exécuter l'application Shiny
shinyApp(ui = ui, server = server)
