library(shiny)
library(bslib)
library(ggplot2)
library(DT)
library(leaflet)

source("scripts/ai_job_analysis.R")
source("scripts/covid_19_analysis.R")
source("scripts/student.nahom.R")

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
    .control-example {
      text-align: center;
      font-weight: bold
      }
    .dt-buttons .btn {
      background-color: #007bff;
      color: black;
      border: none;
      padding: 8px 12px;
      margin: 2px;
      border-radius: 4px;
    }
    .dt-buttons .btn:hover {
      background-color: #0056b3;
    }
    "))
  ),
  titlePanel(HTML("<b>Dashboard Templates</b>")),
  page_sidebar(
    sidebar = sidebar(
      h1(
        HTML(
          "This <b>area</b> is for <em>controls</em>"
        ),
        style = "color: blue;"
      ),
      p("You can put any controls here, like sliders, inputs, etc."),
      div(
        sliderInput("slider_example",
          label = HTML("<b>slider example</b>"),
          min = 0,
          max = 100,
          value = 50,
        ),
        selectInput(
          "select_example",
          HTML("Select Value:"),
          list("Value 1" = 1, "Value 2" = 2, "Value 3" = 3),
        ),
        class = "control-example"
      ),
      input_switch("switch_example", textOutput("switch_state"))
    ),
    mainPanel(
      h1(HTML("<b>Our</b> <u><b><em>projects</em></b></u>"), style = "text-align: center;"),
      selectInput("plot_to_explore", "Choose a plot & dataset to explore:", choices = c("AI Job", "Covid-19", "Social Media & Exam Scores")),
      plotOutput("selected_plot"),
      hr(),
      h5("Interactive Map"),
      leafletOutput("map"),
      hr(),
      h5("Data Table"),
      DTOutput("cool_table"),
      p("Tip: Use the search box to filter results, or click column headers to sort."),
    ),
    absolutePanel(
      wellPanel(
        titlePanel(HTML("<b>Did you know?</b>")),
        HTML("This website has <b>NO</b> <em>data?</em>")
      ),
      width = "200px",
      right = "50px",
      top = "20px",
      draggable = TRUE
    ),
    div(
      HTML("Credits to all dataset authors. They will be linked in the paper."),
      style = "text-align: center; margin-top: 50px; padding: 20px;
        border-top: 1px solid #ddd; font-style: italic;"
    )
  )
)

server <- function(input, output) {
  click <- reactiveVal(0)
  switch_state_msg <- reactiveVal()
  

  observeEvent(input$click_me, {
    click(click() + 1)
  })

  observeEvent(input$switch_example, {
    if (input$switch_example == TRUE) {
      switch_state_msg("Turned ON")
    } else {
      switch_state_msg("Turned OFF")
    }
  })

  plot <- list(
    "AI Job" = list(ai_plot, ai_jobs),
    "Covid-19" = list(covid_19_plot, covid_data),
    "Social Media & Exam Scores" = list(social_media_plot, data)
  )
  output$selected_plot <- renderPlot({
    selected_plot <- plot[[input$plot_to_explore]][[1]]
    selected_plot
  })

  output$cool_table <- DT::renderDataTable({
    req(input$plot_to_explore)
    selected_data <- plot[[input$plot_to_explore]][[2]]
    print(selected_data)
    DT::datatable(
      selected_data,
      options = list(
        pageLength = 10,
        autoWidth = TRUE,
        scrollX = TRUE,
        dom = "Bfrtip",
        buttons = c("copy", "csv", "excel", "pdf", "print")
      ),
      extensions = "Buttons"
    )
  })

  output$switch_state <- renderText({
    switch_state_msg()
  })

  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng = -74.0060, lat = 40.7128, popup = "New York") %>%
      setView(lng = -74.0060, lat = 40.7128, zoom = 12)
  })
}

shinyApp(ui = ui, server = server, options = list(port = 6060, autoreload = TRUE))