SpotifyHx is an R Shiny application for visualising listening history data from Spotify.

It uses the extended streaming history data available from Spotify, which contains details
on every track ever played. The data can be requested from Spotify via the [Privacy Settings](https://www.spotify.com/us/account/privacy/) page.

Once downloaded, the data can be imported into the Shiny app, and visualised in a number of ways.

## Installation

The simplest way to run the app is to call:

```r
shiny::runGitHub("spotifyhx", "baird")
```

Alternatively, you can clone the repository:

```bash
git clone https://github.com/bairdj/spotifyhx.git
```

and then run the application from R:

```r
shiny::runApp("spotifyhx")
```

## Usage

You should upload your ZIP file exactly as it was downloaded from Spotify.
This can be done on the "Load Data" tab.

You can apply filters here, such as requiring a minimum duration of listening
for tracks to be included. It is highly recommended that you do this, as the
data includes tracks that were skipped and may have only played for a few seconds.

## Features

### Artists

* __Top artists__: table showing top 50 artists by number of plays
* __Top artist evolution__: line chart showing cumulative plays of top 8 artists over time
* __Annual artist plays__: bar chart showing number of plays per year for a selected artist