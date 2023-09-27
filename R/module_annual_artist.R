create_annual_artist_plot <- function(spotify_data, artist) {
  spotify_data |>
    filter(artist == !!artist) |>
    count(year) |>
    ggplot(aes(x = year, y = n)) +
    geom_col(fill = "#419D78") +
    scale_x_continuous(
      breaks = ~ seq(floor(.x[1]), ceiling(.x[2]), 1)
    ) +
    scale_y_continuous(
      labels = scales::label_comma(),
      expand = expansion(mult = c(0, 0.03))
    ) +
    labs(x = "Year", y = "Plays", title = artist)
}

annualArtistUI <- function(id) {
  ns <- NS(id)
  tagList(
    plotOutput(ns("annual_artist_plot")),
    hr(),
    wellPanel(
      selectizeInput(
        ns("artist"),
        "Artist",
        choices = NULL
      )
    )
  )
}

annualArtistServer <- function(id, spotify_data) {
  moduleServer(
    id,
    function(input, output, session) {
      artist_choices <- reactive({
        req(spotify_data())
        sort(unique(spotify_data()$artist))
      })

      observeEvent(
        artist_choices(),
        {
          updateSelectizeInput(
            session,
            inputId = "artist",
            choices = artist_choices(),
            server = TRUE
          )
        }
      )

      output$annual_artist_plot <- renderPlot({
        req(spotify_data())
        req(input$artist)

        create_annual_artist_plot(spotify_data(), input$artist)
      })
    }
  )
}
