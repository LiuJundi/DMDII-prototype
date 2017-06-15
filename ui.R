library(shinydashboard)
library(plotly)
library(dplyr)
library(stringdist)
library(tm)

setwd('/Users/jundiliu/Desktop/DMDII')
df.data <- read.csv('SalesOrdersLines-05222017.csv', header = TRUE, 
                    colClasses = c(rep("factor",4),"character","numeric","factor","character","factor","factor","character","numeric","factor","numeric"))
df.data$required_date <- as.Date(df.data$required_date, format="%d-%b-%y")

#Cleaning
df.data$item_description <- tolower(df.data$item_description)
df.data$drawing_description <- tolower(df.data$drawing_description)
df.data$item_description <- removePunctuation(df.data$item_description, preserve_intra_word_dashes = TRUE)
df.data$item_description <- gsub('\\S+([0-9])\\S+','',df.data$item_description)
df.data$item_description <- sub("rev.*","",df.data$item_description)
df.data$item_description <- removeNumbers(df.data$item_description)
df.data$item_description <- removePunctuation(df.data$item_description)
df.data$norm_descr <- ifelse(df.data$drawing_description == "",df.data$item_description, df.data$drawing_description)

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
  selectizeInput(inputId = "part_id", label = "Part ID:", choices = unique(df.data$norm_descr), selected = FALSE, multiple = TRUE),
  dateRangeInput(inputId = "date_range", label = "Date Range", start = NULL, end = NULL, min = NULL,
                 max = NULL, format = "yyyy-mm-dd", startview = "month", weekstart = 0,
                 language = "en", separator = " to ", width = NULL),
  selectInput(inputId = "customer_priority", label = "Customer Priority", choices = c("First", "Second", "Third"), selected = NULL, multiple = FALSE,
              selectize = TRUE, width = NULL, size = NULL)
)

# Body
body <- dashboardBody(
  
)

ui <- dashboardPage(header, sidebar, body, skin = "purple")
