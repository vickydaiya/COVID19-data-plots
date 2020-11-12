#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Covid 19 data analysis"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("month",
                        label = "Choose a month for which you want to see the data",
                        choices = month.name,selected = "November"),
            sliderInput("date", label = "Choose the dates between which you want to see the data", min = 1, 
                        max = 31, value = c(1, 10)),
            checkboxInput("Confirmed",label = "show confirmed cases data",value = TRUE),
            checkboxInput("Recovered",label = "show recovered cases data",value = TRUE),
            checkboxInput("Deceased",label = "show deceased cases data",value = TRUE)
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs",
                        tabPanel("Documentation",br(),textOutput("doc")),
                        tabPanel("Plot",br(),plotOutput("plot")))
        )
    )
))
