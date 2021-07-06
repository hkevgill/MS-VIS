#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(colourpicker)
library(shinyWidgets)

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
            h3("Files"),

            # Input: Select a file ----
            fileInput("file1", "Spectrum text file",
                      multiple = FALSE,
                      accept = c("text",
                                 "text/plain",
                                 "txt")),
            # Input: Select a file ----
            fileInput("file2", "Peaks excel file",
                      multiple = FALSE,
                      accept = c(".xlsx")),
            # Input: Text ----
            textInput("peaksSheetName", "Peaks sheet name", value = "", width = NULL, placeholder = NULL),

            h3("Variables for spectrum plotting"),

            # Input: Text ----
            textInput("spectrumSeparator", "Spectrum separator", value = "", width = NULL, placeholder = "space"),

            # Input: Checkbox ----
            checkboxInput("spectrumHeader", "Spectrum header", value = FALSE, width = NULL),

            # Input: Text ----
            textInput("spectrumXaxisLabel", "Spectrum x-axis label", value = "m/z", width = NULL, placeholder = ""),

            # Input: Text ----
            textInput("spectrumYaxisLabel", "Spectrum y-axis label", value = "Intensity", width = NULL, placeholder = ""),

            # Input: Text ----
            textInput("spectrumMainLabel", "Spectrum main label", value = "Single Spectrum", width = NULL, placeholder = ""),

            # Input: ColourInput
            colourInput("spectrumColour", "Spectrum colour", value = "#BC5741", showColour = c("both", "text", "background"), palette = c("square", "limited"), allowTransparent = FALSE, returnName = FALSE),

            # Input: Checkbox ----
            checkboxInput("spectrumFullRange", "Spectrum full range", value = FALSE, width = NULL),

            # Input: NumericRangeInput ----
            numericRangeInput(inputId = "spectrumRangeXAxis", label = "Spectrum x-axis range limit", value = c(1480,1530)),

            # Input: NumericRangeInput ----
            numericRangeInput(inputId = "spectrumRangeYAxis", label = "Spectrum y-axis range limit", value = c(0,40000)),

            h3("Variables for peak labeling"),

            # Input: NumericRangeInput ----
            numericRangeInput(inputId = "peaksSelectedMasses", label = "Peaks Selected Masses", value = c(1496,1506)),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            imageOutput("myImage")
        )
    )
))
