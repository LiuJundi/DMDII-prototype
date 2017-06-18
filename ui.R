library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)
library(googleVis)

#setwd('/Users/jundiliu/Desktop/DMDII')
setwd('D:\\Program File\\Git\\git_projects\\RA\\VizProto\\DMDII-prototype')

df.data <- read.csv('SalesOrdersLines-05222017.csv', header = TRUE, 
                    colClasses = c(rep("factor",4),"character","numeric","factor","character","factor","factor","character","numeric","factor","numeric","character"))
df.data$required_date <- as.Date(df.data$required_date, format="%d-%b-%y")

# Notification menu
notifications <- dropdownMenu(type = "notifications",
                              notificationItem(
                                status="warning",
                                text = "Data updated 3/8/2017",
                                icon("info-circle")
                              )
)

# Header menu
header <- dashboardHeader(title = "My Dashboard Demo", notifications)

# Sidebar menu
sidebar <- dashboardSidebar(
  sidebarMenu(
    sidebarSearchForm(textId = "searchText", buttonId = "searchButton",
                      label = "Search...")
  ),
  sliderInput(inputId = "quantity_ordered", "Quantity Ordered:", 1, 100, 50),
  selectizeInput(inputId = "part_id", label = "Part ID:", choices = unique(df.data$item_id), selected = FALSE, multiple = FALSE),
  dateInput(inputId = "order_date", label = "Order Date", 
                 min = NULL,max = NULL, format = "mm-dd-yyyy", startview = "month", 
                 weekstart = 0, language = "en", width = NULL),
  numericInput("quantity_ordered", 
               label = "Quantity Ordered:", 
               value = 10),
  sliderInput(inputId = "CI", "Confidence Interval (%):", 1, 100, 95),
  selectizeInput(inputId = "part_id", label = "Part ID:", choices = unique(df.data$norm_descr), selected = FALSE, multiple = TRUE),
  selectInput(inputId = "customer_priority", label = "Customer Priority", choices = c("First", "Second", "Third"), selected = NULL, multiple = FALSE,
              selectize = TRUE, width = NULL, size = NULL),
  fluidRow(
    column(5,actionButton("reset", label = "Reset")),
    column(5,actionButton("predict", label="Predict"))
  )
)

# Body
body <- dashboardBody(
  fluidRow(
    valueBoxOutput("dateEstLower"),
    valueBoxOutput("dateEst"),
    valueBoxOutput("dateEstUpper")
  ),
  fluidRow(
    column(width=12,
           box(width=NULL,title = "Order Calendar", status = "primary", htmlOutput("calendar"))
           ))
)

dashboardPage(header, sidebar, body, skin = "purple")