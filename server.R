#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
library(readtext)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data <- read.csv("case_time_series.csv")
    data$Date_YMD <- as.Date(data$Date_YMD)
    data <- select(data,Date_YMD,Daily.Confirmed,Daily.Recovered,Daily.Deceased) %>%
            mutate("month" = months(Date_YMD),"day" = as.numeric(substr(x = Date_YMD, start = 9, stop = 10))) %>%
            select(-Date_YMD)
    
    user_month <- reactive({
        input$month
    })
    user_day <- reactive({
        input$date
    })
    user_choice_confirmed <- reactive({
        input$Confirmed
    })
    user_choice_recovered <- reactive({
        input$Recovered
    })
    user_choice_deceased <- reactive({
        input$Deceased
    })
    output$plot <- renderPlot({
        reqd_data <- filter(data,month == user_month()) %>%
            filter(day <= user_day()[2] & day >= user_day()[1]) 
        
        if(!user_choice_confirmed())
        {
            reqd_data <- select(reqd_data,-Daily.Confirmed)
        }
        if(!user_choice_recovered())
        {
            reqd_data <- select(reqd_data,-Daily.Recovered)
        }
        if(!user_choice_deceased())
        {
            reqd_data <- select(reqd_data,-Daily.Deceased)
        }
        reqd_data <- gather(reqd_data,type,numbers,-month,-day)
        qplot(day,numbers,color = type,data = reqd_data,geom = c("point","line"))
    })
    
    output$doc <- renderText("This project makes plots for COVID19 data in India.

The dataset for this project can be downloaded from https://api.covid19india.org/csv/latest/case_time_series.csv.

The application takes as input the month and the dates for which the data should be plotted. The application also has an option for whether or not to show plot of number of confirmed cases. The same option exists for plots of number of recovered cases and number of deceased cases.

You can see a sidebar panel on the lefthand side of your screen.

This panel shows first a dropdown option. From this dropdown, You can select any month for which you wish to see the plot of data.

Below the dropdown is a slider. Move this slider in order to select the dates, in the month selected above, between which you want to see the plot of the data.

Next, you can see a checkbox. The checkbox is clicked and hence it is showing the plot of number of confirmed cases for the month and the dates you selected. If you unselect this, you wont see the plot.

Similar checkboxes for number of recovered and number of deceased cases exist.

NOTE: For some inputs, a blank plot is shown. This is because data for that time period doesn’t exist.
NOW SWITCH OVER TO THE PLOT TAB TO SEE THE ACTION!!!!!")
})
