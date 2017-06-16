library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)
library(makeR)
library(chron)

setwd('D:\\Program File\\Git\\git_projects\\RA\\VizProto\\DMDII-prototype')
df.cal <- read.csv('cal.csv', header=TRUE, colClasses = c('character','integer'))

server <- function(input, output, session) {
  output$calendar <- renderImage({
    png(filename = "h1.png", 750, 750, res = 100)
    calendarHeat(df.cal$Dates, df.cal$Value,varname = "Calendar of order commitment dates")
    dev.off()
    
    list(src = 'h1.png')
  })
}