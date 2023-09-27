#' Parse a Spotify streaming history JSON file
#'
#' @param x Path or connection to a Spotify streaming history JSON file
#' @return A tibble
parse_spotify_json <- function(x) {
  jsonlite::fromJSON(x) |> tibble::as_tibble()
}

#' Parse a Spotify streaming history ZIP archive
#'
#' Works with the default ZIP file that is provided by Spotify. This expects
#' a top-level directory called `MyData`, which contains JSON files.
#'
#' @param path Path to a Spotify streaming history ZIP archive
#' @return A tibble
parse_spotify_zip <- function(path) {
  file_list <- utils::unzip(path, list = TRUE)
  json_pattern <- "^MyData/.*\\.json$"
  json_files <- file_list[grep(json_pattern, file_list$Name), "Name"]
  
  purrr::map(
    json_files,
    ~ parse_spotify_json(unz(path, .x))
  ) |>
  bind_rows()
}

clean_spotify_data <- function(df, minimum_play_time = 30) {
  df |>
    #slice_sample(prop = 0.1) |>
    mutate(
      date = lubridate::fast_strptime(ts, "%Y-%m-%dT%H:%M:%S%z"),
      year = lubridate::year(date),
      duration_s = round(ms_played / 1000)
    ) |>
    filter(duration_s >= minimum_play_time) |>
    rename(
      artist = master_metadata_album_artist_name,
      album = master_metadata_album_album_name,
      track = master_metadata_track_name
    )
}
