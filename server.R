library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)
library(googleVis)

setwd('D:\\Program File\\Git\\git_projects\\RA\\VizProto\\DMDII-prototype')
df.cal <- read.csv('cal.csv', header=TRUE, colClasses = c('character','integer'))
df.cal$Dates <- as.Date(df.cal$Dates)


server <- function(input, output, session) {
  output$calendar <- renderGvis({
    gcal <- gvisCalendar(data=df.cal, datevar="Dates", numvar = "Value",  options=list(
      title="Daily temperature in Cairo",
      height=250,
      calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: '#1A8763', bold: true},
                               cellSize: 10,
                               cellColor: { stroke: 'red', strokeOpacity: 0.2 },
                               focusedCellColor: {stroke:'red'}}"))
    return(gcal)
  })
}