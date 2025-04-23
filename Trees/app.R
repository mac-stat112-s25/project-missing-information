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

trees <- read_csv(here("src/appx", "Apptrees.csv"))

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Trees of Macalester"),
    sidebarLayout(
      sidebarPanel(
        checkboxGroupInput("selected_Species", "Choose Species to Display:",
                           choices = unique(trees$TFSpecies),
                           selected = unique(trees$TFSpecies))
      ),
      mainPanel(
    leafletOutput("leafletMap", height = 600)
      )
    )
)



# Define server logic required to draw a histogram
server <- function(input, output, session) {
  treeIcon <- makeIcon(
    iconUrl = "https://cdn.pixabay.com/photo/2017/01/31/22/47/tree-2027899_1280.png",
    iconWidth = 17, iconHeight = 17,
    iconAnchorX = 7.5, iconAnchorY = 7.5
  )

    output$leafletMap <- renderLeaflet({
        leaflet(trees) |>
        addTiles() |>
        flyTo(
          lng = mean(trees$x),
          lat = mean(trees$y),
          zoom = 15
        )
    })
    species_pal <- colorFactor(palette = "Set1", domain = unique(trees$TFSpecies))
    
    observe({
      filtered <- trees[trees$TFSpecies %in% input$selected_Species, ]
      
      leafletProxy("leafletMap") |>
        clearMarkers() |>
        clearShapes() |>
        addMarkers(
          data = filtered, 
          lng = ~x,
          lat = ~y,
          icon = treeIcon,
          label = ~`Common Species Name`
        ) |>
        addCircles(
          data = filtered,
          lng = ~x,
          lat = ~y,
          color = ~species_pal(TFSpecies),
          weight = 2,
          radius = 5)
       })
}


# Run the application 
shinyApp(ui = ui, server = server)
