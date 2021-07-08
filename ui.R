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
    titlePanel("Mass Spectrum"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Files"),

            # Input: Select a file ----
            tags$div(title="Mass spectrum file",
                fileInput("file1", "Upload a spectrum text file",
                      multiple = FALSE,
                      accept = c("text",
                                 "text/plain",
                                 "txt")),
            ),
            
            # Input: Select a file ----
            tags$div(title="Mass list file",
                fileInput("file2", "Upload a mass spec peaks excel file",
                      multiple = FALSE,
                      accept = c(".xlsx")),
            ),
            
            # Input: Text ----
            tags$div(title="",
                textInput("peaksSheetName", "Peaks sheet name", value = "", width = NULL, placeholder = NULL),
            ),
            
            h3("Variables for spectrum plotting"),
            
            # Input: Text ----
            tags$div(title="Separator in the mass spectrum csv file",
                textInput("spectrumSeparator", "Spectrum separator", value = "", width = NULL, placeholder = "space"),
            ),
            
            # Input: Checkbox ----
            tags$div(title="Whether or not the mass spectrum file has column headers",
                checkboxInput("spectrumHeader", "Spectrum header", value = FALSE, width = NULL),
            ),
            
            # Input: Text ----
            tags$div(title="Label below x-axis",
                textInput("spectrumXaxisLabel", "Spectrum x-axis label", value = "m/z", width = NULL, placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Label next to y-axis",
                textInput("spectrumYaxisLabel", "Spectrum y-axis label", value = "Intensity", width = NULL, placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Label above mass spectrum",
                textInput("spectrumMainLabel", "Spectrum main label", value = "Single Spectrum", width = NULL, placeholder = ""),
            ),
            
            # Input: ColourInput ----
            tags$div(title="Color of the mass spectrum",
                colourInput("spectrumColour", "Spectrum colour", value = "#BC5741", showColour = c("both", "text", "background"), palette = c("square", "limited"), allowTransparent = FALSE, returnName = FALSE),
            ),
            
            # Input: Checkbox ----
            tags$div(title="Whether the entire spectrum, or only a section of it should be displayed",
                checkboxInput("spectrumFullRange", "Spectrum full range", value = FALSE, width = NULL),
            ),
            
            # Input: NumericRangeInput ----
            tags$div(title="Lower and upper ends of the x-axis",
                numericRangeInput(inputId = "spectrumRangeXAxis", label = "Spectrum x-axis range limit", value = c(0,4000)),
            ),
            
            # Input: NumericRangeInput ----
            tags$div(title="Lower and upper ends of the y-axis",
                numericRangeInput(inputId = "spectrumRangeYAxis", label = "Spectrum y-axis range limit", value = c(0,40000)),
            ),
            
            h3("Variables for peak labeling"),

            # Input: Text ----
            tags$div(title="Where the peak labels should be displayed. r or l displays them to the right or left of the peak maximum. R or L displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)",
                     textInput(inputId = "peaksLabelPosition", label = "Peaks Label position", value = "", placeholder = "Example: r,R, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="m/z value of the peaks which should be labeled",
                textInput(inputId = "peaksSelectedMasses", label = "Peaks Selected Masses", value = "", placeholder = "Example: 1496, 1506"),
            ),

            # Input: Text ----
            tags$div(title="Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)",
                textInput(inputId = "peaksLabelLength", label = "Peaks Label Length", value = "", placeholder = "Example: 0.1,0.1, must match length of Peaks Selected Masses"),
            ),

            # Input: Text ----
            tags$div(title="First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector",
                     textInput(inputId = "peaksFirstLabel", label = "Peaks First Label", value = "", placeholder = "Example: Peak 1,Peak 2, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector",
                     textInput(inputId = "peaksSecondLabel", label = "Peaks Second Label", value = "", placeholder = "Example: 2nd Label P1,2nd Label P2, must match length of Peaks Selected Masses"),
            ),

            # Input: Text ----
            tags$div(title="Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2)",
                     textInput(inputId = "peakTolerance", label = "Peak Tolerance", value = "2", placeholder = ""),
            ),

            # Input: Text ----
            tags$div(title="line width of the line connecting the peak to the peak labels",
                     textInput(inputId = "peakLabelLineWidth", label = "Peak Label Line Width", value = "2", placeholder = ""),
            ),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            imageOutput("myImage")
        )
    )
))
