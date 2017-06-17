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
df.cal$Dates <- as.Date(df.cal$Dates, format="%d-%b-%y")


server <- function(input, output, session) {
  output$calendar <- renderGvis({
    gcal <- gvisCalendar(data=df.cal, datevar="Dates", numvar = "Value",  options=list(
      title="Open Orders",
      width='automatic',
      length='automatic',
      calendar="{yearLabel: { fontName: 'Times-Roman',
                               fontSize: 32, color: 'black', bold: true},
                               cellSize: 15,
                               focusedCellColor: {stroke:'red'}}"))
    return(gcal)
  })
  
  output$dateEst <- renderValueBox({
    valueBox(
      paste0(input$order_date), "Estimated Delivery Date"
    )
  })
  
  output$dateEstLower <- renderValueBox({
    valueBox(
      paste0(input$order_date), 
      "Estimated Delivery Date CI Lower Bound"
    )
  })
  
  output$dateEstUpper <- renderValueBox({
    valueBox(
      paste0(input$order_date), 
      "Estimated Delivery Date CI Upper Bound"
    )
  })
}