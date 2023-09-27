library(dplyr)
library(gt)
library(ggplot2)
library(glue)

options(shiny.maxRequestSize = 50*1024^2)

theme_set(theme_minimal())
theme_update(
  panel.background = element_blank(),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major.y = element_line(colour = "grey80"),
  axis.line.x = element_line("black")
)

server <- function(input, output) {
  loaded_data <- loadDataServer("load")
  artistsServer("artists", loaded_data$data)
}

ui <- navbarPage(
  "SpotifyHx",
  tabPanel("Load Data", icon = icon("upload"), loadDataUI("load")),
  tabPanel("Artists", icon = icon("users"), artistsUI("artists"))
)

shinyApp(ui = ui, server = server)