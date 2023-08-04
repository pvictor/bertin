pkgload::load_all()
library(sf)
library(shiny)

ui <- fluidPage(
  tags$h2("Hide/Show layers"),
  radioButtons(
    inputId = "layer",
    label = "Layer to show:",
    choices = c("pop", "gdp"),
    inline = TRUE
  ),
  bertinOutput("map")
)

server <- function(input, output, session) {

  world <- st_read(
    system.file("gpkg/world.gpkg", package = "bertin"),
    layer = "world",
    quiet = TRUE
  )

  output$map <- renderBertin({
    bt_param(width = 500, margin = 10) |>
      bt_layer(
        data = world[world$region == "Africa", ],
        fill = "#ebc994",
        display = FALSE
      ) |>
      bt_bubble(
        id = "pop",
        data = world[world$region == "Africa", ],
        values = "pop",
        fill = "#d44495",
        tooltip = c("$name", "$pop", " thousands inh."),
        leg_title = "Number of inh.",
        leg_x = 30,
        leg_y = 300,
        leg_round = 0
      ) |>
      bt_bubble(
        id = "gdp",
        data = world[world$region == "Africa", ],
        values = "gdp",
        k = 55,
        fill = "#81A1C1",
        tooltip = c("$name", "$gdppc", "(current US$)"),
        leg_title = "GDP per capital\n(in $)",
        leg_x = 30,
        leg_y = 290,
        leg_round = -2
      ) |>
      bt_hide_layer(layers_id = "gdp") |>
      bt_draw()
  })

  observeEvent(input$layer, {
    if (input$layer == "pop") {
      bertinProxy("map") |>
        bt_hide_layer("gdp") |>
        bt_show_layer("pop")
    } else {
      bertinProxy("map") |>
        bt_hide_layer("pop") |>
        bt_show_layer("gdp")
    }
  })

}

shinyApp(ui, server)
