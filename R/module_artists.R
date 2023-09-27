create_top_artist_table <- function(spotify_data) {
  spotify_data |>
  group_by(artist) |>
  summarise(
    n_plays = n(),
    first_play = min(date)
  ) |>
  slice_max(n_plays, n = 50) |>
  gt() |>
  cols_label(
    artist = "Artist",
    n_plays = "Plays",
    first_play = "First play"
  ) |>
  fmt_date(first_play, date_style = 3) |>
  fmt_integer(n_plays) |>
  tab_header(
    title = "Top 50 artists",
    subtitle = "By number of plays"
  )
}

create_top_artist_evolution <- function(spotify_data, top_n = 8) {
  top_artists <- spotify_data |>
    filter(!is.na(artist)) |>
    count(artist) |>
    slice_max(n, n = top_n)

  cum_play_data <-
    spotify_data |>
    inner_join(top_artists, join_by(artist)) |>
    select(artist, date) |>
    mutate(date = as.Date(date)) |> # Drop time
    count(artist, date) |>
    arrange(date) |>
    mutate(cum_plays = cumsum(n), .by = artist)

  cum_play_data |>
    ggplot(aes(x = date, y = cum_plays, colour = artist)) +
    scale_colour_brewer(
      type = "qual",
      palette = "Dark2",
      name = "Artist"
    ) +
    geom_step() +
    scale_x_date(
      date_breaks = "1 year",
      date_labels = "%Y",
      expand = expansion(mult = c(0.01, 0.01))
    ) +
    scale_y_continuous(
      expand = expansion(mult = c(0.01, 0.03)),
      labels = scales::label_comma()
    ) +
    labs(
      x = "Year",
      y = "Cumulative plays"
    )
}

artistsUI <- function(id) {
  ns <- NS(id)
  navlistPanel(
    tabPanel(
      "Top artists",
      gt_output(ns("artist_table"))
    ),
    tabPanel(
      "Top artist evolution",
      plotOutput(ns("artist_evolution"))
    ),
    tabPanel(
      "Annual artist plays",
      annualArtistUI(ns("annual_artist"))
    )
  )
}

artistsServer <- function(id, spotify_data) {
  moduleServer(
    id,
    function(input, output, session) {
      output$artist_table <- render_gt({
        req(spotify_data())
        create_top_artist_table(spotify_data())
      })

      output$artist_evolution <- renderPlot({
        req(spotify_data())
        create_top_artist_evolution(spotify_data())
      })

      annualArtistServer("annual_artist", spotify_data)
    }
  )
}
