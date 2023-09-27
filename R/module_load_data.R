loadDataUI <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 6,
        p(
          "You can request your Spotify streaming history data from ",
          a("here", href = "https://www.spotify.com/us/account/privacy/"),
          "."
        ),
        h3("Upload"),
        wellPanel(
          fileInput(
            inputId = ns("spotify_data"),
            label = "Upload Spotify data",
            accept = ".zip",
            placeholder = "my_spotify_data.zip"
          ),
          actionButton(
            inputId = ns("load"),
            label = "Import data",
            icon = icon("upload")
          )
        ),
        h3("Filters"),
        wellPanel(
          sliderInput(
            inputId = ns("minimum_play_time"),
            label = "Minimum play time (seconds)",
            min = 0,
            max = 300,
            value = 30
          )
        )
      )
    )
  )
}

loadDataServer <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      parsed_data <- reactiveVal(NULL)

      observeEvent(
        input$load,
        {
          req(input$spotify_data)

          uploaded_data <-
            withProgress(
              parse_spotify_zip(input$spotify_data$datapath),
              message = "Parsing data"
            )

          parsed_data(uploaded_data)
        }
      )

      cleaned_data <- reactive({
        req(parsed_data())
        req(input$minimum_play_time)

        withProgress(
          clean_spotify_data(parsed_data(), input$minimum_play_time),
          message = "Cleaning data"
        )
      })

      list(
        data = cleaned_data
      )
    }
  )
}
