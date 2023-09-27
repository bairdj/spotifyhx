create_geo_table <- function(spotify_data) {
  spotify_data |>
    count(conn_country) |>
    filter(!is.na(conn_country), conn_country != "ZZ") |>
    arrange(desc(n)) |>
    gt() |>
    fmt_flag(conn_country) |>
    fmt_integer(n) |>
    cols_label(
      conn_country = "Country",
      n = "Plays"
    ) |>
    tab_header(
      title = "Countries listened from"
    )
}

create_geo_year_table <- function(spotify_data) {
  spotify_data |>
    count(conn_country, year) |>
    filter(!is.na(conn_country), conn_country != "ZZ") |>
    arrange(desc(n)) |>
    summarise(countries = paste0(conn_country, collapse = ","), .by = year) |>
    arrange(year) |>
    gt() |>
    fmt_flag(countries) |>
    cols_label(
      year = "Year",
      countries = "Countries"
    ) |>
    tab_header(
      title = "Countries listened from by year"
    )
}

geoUI <- function(id) {
  ns <- NS(id)
  tagList(
    navlistPanel(
      tabPanel("All countries", gt_output(ns("geo_table"))),
      tabPanel("Countries by year", gt_output(ns("geo_year_table")))
    )
  )
}

geoServer <- function(id, spotify_data) {
  moduleServer(
    id,
    function(input, output, session) {
      output$geo_table <- render_gt({
        req(spotify_data())
        create_geo_table(spotify_data())
      })

      output$geo_year_table <- render_gt({
        req(spotify_data())
        create_geo_year_table(spotify_data())
      })
    }
  )
}