#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(leaflet)
library(readr)
library(here)

trees <- read_csv(here("data", "trees1.csv"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Trees of Macalester"),
    leafletOutput("leafletMap", height = 600)
)

    

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$leafletMap <- renderLeaflet({
        leaflet(trees) |>
        addTiles() |>
        addAwesomeMarkers(
          lng = ~x,
          lat = ~y,
          icon = awesomeIcons(
            icon = 'leaf',
            iconColor = 'white',
            markerColor = 'green',
            library = 'fa'
          ),
          label = ~`Common Species Name`
        ) 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
