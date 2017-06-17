library(shiny)
library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)
library(googleVis)

#<<<<<<< Updated upstream
setwd('/Users/jundiliu/Desktop/DMDII')
#setwd('D:\\Program File\\Git\\git_projects\\RA\\VizProto\\DMDII-prototype')
#=======
setwd('/Users/jundiliu/Desktop/DMDII')
#>>>>>>> Stashed changes
df.data <- read.csv('SalesOrdersLines-05222017.csv', header = TRUE, 
                    colClasses = c(rep("factor",4),"character","numeric","factor","character","factor","factor","character","numeric","factor","numeric"))
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
  numericInput("quantity_ordered", 
               label = "Quantity Ordered:", 
               value = 10),
  sliderInput(inputId = "CI", "Confidence Interval (%):", 1, 100, 80),
  selectizeInput(inputId = "part_id", label = "Part ID:", choices = unique(df.data$norm_descr), selected = FALSE, multiple = TRUE),
  selectInput(inputId = "customer_priority", label = "Customer Priority", choices = c("First", "Second", "Third"), selected = NULL, multiple = FALSE,
              selectize = TRUE, width = NULL, size = NULL),
  fluidRow(
    column(5,actionButton("reset", label = "Reset")),
    column(5,submitButton("Predict"))
  )
)

# Body
body <- dashboardBody(
  fluidRow(
    column(width=12,
           box(width=NULL,title = "Order Calendar", status = "primary", htmlOutput("calendar"))
           )),
  fluidRow(
    column(width=12,
           infoBox("Lower limit (CI)", "2016-09-09", icon = icon("calendar"), width = 3),
           infoBox("Higher limit (CI)", "2016-09-09", icon = icon("calendar"),width = 3),
           infoBox("Estimated Date", "2016-09-09", icon = icon("calendar"),width = 3),
           infoBox("CI level","80%",icon = icon("percent"),width=3)
        ),
    column(width=12,
           infoBox("Customer Priority", "VIP", icon = icon("users"), width = 3),
           infoBox("Quantity Orderes", 30, icon = icon("hashtag"),width = 3),
           infoBox("Part ID", "Ring, Gear and Shaft", icon = icon("cogs"),width = 6)
    )
    )  
)

dashboardPage(header, sidebar, body, skin = "purple")