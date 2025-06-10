library(shiny)
library(bslib)
library(ggplot2)

source("scripts/ai_job_analysis.R")

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
    .control-example {
      text-align: center !important;
      }
    "))
  ),
  titlePanel(HTML("<b>Dashboard Template</b>")),
  div(
    HTML(
      "Credits to all dataset authors. They will be linked in the paper."
    ),
    style = "position: absolute; bottom: 0;
    left: 0; right: 0; text-align: center;"
  ),
  page_sidebar(
    sidebar = sidebar(
      h1(
        HTML(
          "This <b>area</b> is for <em>controls</em>"
        ),
        style = "color: blue;"
      ),
      p("You can put any controls here, like sliders, inputs, etc."),
      sliderInput("slider_example",
        label = div(HTML("<b>slider example</b>"), class = "control-example"),
        min = 0,
        max = 100,
        value = 50
      ),
      selectInput(
        "select_example",
        div(HTML("Select Value:"), class = "control_example"),
        list("Value 1" = 1, "Value 2" = 2, "Value 3" = 3)
      ),
      input_switch("switch_example", textOutput("switch_state"))
    ),
  mainPanel(
    h1("This is the main area", style = "text-align: center;"),
    plotOutput("new_plot")
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

  output$new_plot <- renderPlot({
    ai_plot
  })


  output$switch_state <- renderText({
    switch_state_msg()
  })
}

shinyApp(ui = ui, server = server, options = list(port = 6060))
