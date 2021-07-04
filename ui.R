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
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "main.css")
    ),

    # Application title
    titlePanel("MALDI Visualizer"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            # Input: Select a file ----
            fileInput("file1", "Upload a spectrum text file",
                      multiple = FALSE,
                      accept = c("text",
                                 "text/plain",
                                 "txt")),
            # Input: Select a file ----
            fileInput("file2", "Upload a mass spec peaks excel file",
                      multiple = FALSE,
                      accept = c(".xlsx")),
            # Input: Text ----
            textInput("peaksSheetName", "Peaks Sheet Name", value = "", width = NULL, placeholder = NULL),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            imageOutput("myImage")
        )
    )
))
