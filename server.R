library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)
library(googleVis)

setwd('D:\\Program File\\Git\\git_projects\\RA\\VizProto\\DMDII-prototype')
#setwd('/Users/jundiliu/Desktop/DMDII-prototype')
df.cal <- read.csv('cal.csv', header=TRUE, colClasses = c('character','integer'))
df.cal$Dates <- as.Date(df.cal$Dates, format="%Y-%m-%d")

predDate <- reactiveVal(Sys.Date())
CIbound <- reactiveVal(5)

server <- function(input, output, session) {
  output$calendar <- renderGvis({
    gcal <- gvisCalendar(data=df.cal, datevar="Dates", numvar = "Value",  options=list(
      title="Open Orders",
      width='automatic',
      length='automatic',
      calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: 'black', bold: true},
                               cellSize: 28,
                               focusedCellColor: {stroke:'red'}}"))
    return(gcal)
  })
  
  observeEvent(input$predict, {
    predDate(input$order_date)
    CIbound(floor(runif(1,3,10)))
  })
  
  output$dateEst <- renderValueBox({
    valueBox(
      paste0(predDate()), "Estimated Delivery Date"
    )
  })
  
  output$dateEstLower <- renderValueBox({
    valueBox(
      paste0(predDate()-CIbound()), 
      "Estimated Delivery Date CI Lower Bound"
    )
  })
  
  output$dateEstUpper <- renderValueBox({
    valueBox(
      paste0(predDate()+CIbound()), 
      "Estimated Delivery Date CI Upper Bound"
    )
  })
}