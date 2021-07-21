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
        tags$link(rel = "stylesheet", type = "text/css", href = "main.css"),
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
            
            # Input: SliderInput ----
            tags$div(title="Font size of the axis labels",
                sliderInput("spectrumAxisFontSize", "Spectrum axis font size:",
                            min = 1, max = 5,
                            value = 3, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Font size of the main label",
                sliderInput("spectrumTitleFontSize", "Spectrum title font size:",
                            min = 1, max = 5,
                            value = 2, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Font size of the axis ticks",
                sliderInput("spectrumAxisTickFontSize", "Spectrum axis tick font size:",
                            min = 1, max = 5,
                            value = 2, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Line width of the mass spectrum",
                sliderInput("spectrumLineWidth", "Spectrum line width:",
                            min = 1, max = 5,
                            value = 2, step = 0.1),
            ),
            
            # Input: MaterialSwitch ----
            tags$div(title="Whether or not the axis ticks are at custom points",
                materialSwitch(
                    inputId = "spectrumCustomAxes",
                    label = "Spectrum custom axes", 
                    status = "primary",
                    right = TRUE,
                    value = TRUE
                ),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is true)",
                sliderInput("spectrumCustomXAxisPdj", "Spectrum custom x-axis pdj:",
                            min = 0.1, max = 5,
                            value = 1, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true)",
                sliderInput("spectrumCustomYAxisPdj", "Spectrum custom y-axis pdj:",
                            min = -5, max = 5,
                            value = -1, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the axis label to the axis (if custom axes is true)",
                sliderInput("spectrumCustomAxisAnnLine", "Spectrum custom axis ann line:",
                            min = 1, max = 10,
                            value = 5, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the main label from the mass spectrum",
                sliderInput("spectrumCustomAxisAnnTitleLine", "Spectrum custom axis ann title line:",
                            min = 0.1, max = 10,
                            value = 1, step = 0.1),
            ),
            
            # Input: TextInput ----
            tags$div(title="Interval of x-axis ticks (if custom axes is true)",
                     textInput(inputId = "spectrumXAxisInterval", label = "Spectrum x-axis interval", value = "20", placeholder = ""),
            ),
            
            # Input: TextInput ----
            tags$div(title="Interval of y-axis ticks (if custom axes is true)",
                     textInput(inputId = "spectrumYAxisInterval", label = "Spectrum y-axis interval", value = "20000", placeholder = ""),
            ),
            
            # Input: MaterialSwitch ----
            tags$div(title="Whether or not the spectrum should be normalized",
                     materialSwitch(
                         inputId = "spectrumNormalizeSpectrum",
                         label = "Normalize spectrum", 
                         status = "primary",
                         right = TRUE,
                         value = FALSE
                     ),
            ),
            
            # Input: SelectInput ----
            tags$div(title="Which method to use for normalization (values of 1-3): 1= by max peak intensity in entire spectrum, 2= by max peak intensity in selected mass range, 3= by peak intensity of a selected peak",
                selectInput("spectrumNormalizationMethod",
                            "Spectrum normalization method",
                            c("1" = 1,
                              "2" = 2,
                              "3" = 3),
                            selected = "3"),
            ),
            
            # Input: Text ----
            tags$div(title="If spectrum.normalization.method=3, then this m.z value will be used for normalization",
                     textInput(inputId = "spectrumNormalizationPeak", label = "Spectrum Normalization Peak", value = "", placeholder = ""),
            ),
            
            h3("Variables for peak labeling"),
            
            # Input: Text ----
            tags$div(title="m/z value of the peaks which should be labeled",
                     textInput(inputId = "peaksSelectedMasses", label = "Peaks Selected Masses", value = "", placeholder = "Example: 1496, 1506"),
            ),
            

            # Input: Text ----
            tags$div(title="Where the peak labels should be displayed. r or l displays them to the right or left of the peak maximum. R or L displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)",
                     textInput(inputId = "peaksLabelPosition", label = "Peaks Label position", value = "", placeholder = "Example: r,R, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)",
                     textInput(inputId = "peaksLabelLength", label = "Peaks Label Length", value = "", placeholder = "Example: 0.1,0.1, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart",
                     textInput(inputId = "peaksLabelSpread", label = "Peaks Label Spread", value = "0.075", placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Line type of the line connecting the peak to the peak labels",
                     textInput(inputId = "peaksLabelLineType", label = "Peaks Label Line Type", value = "3", placeholder = ""),
            ),
            
            # Input: ColourInput ----
            tags$div(title="Line colour of the line connecting the peak to the peak labels",
                     colourInput("peakslabelLineColour", "PeaksLabel Line colour", value = "#000000", showColour = c("both", "text", "background"), palette = c("square", "limited"), allowTransparent = FALSE, returnName = FALSE),
            ),
            
            # Input: Text ----
            tags$div(title="First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector",
                     textInput(inputId = "peaksFirstLabel", label = "Peaks First Label", value = "", placeholder = "Example: Peak 1,Peak 2, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector",
                     textInput(inputId = "peaksSecondLabel", label = "Peaks Second Label", value = "", placeholder = "Example: 2nd Label P1,2nd Label P2, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Checkbox Group Buttons ----
            tags$div(title="Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio)",
                     checkboxGroupButtons(
                         inputId = "peaksLabelsOn",
                         label = "Peak Labels Enabled", 
                         choices = c("1st Label", "2nd label", "m/z ratio", "intensity", "S/N ratio"),
                         status = "primary",
                         selected = c("1st Label", "m/z ratio", "intensity", "S/N ratio")
                     ),
            ),
            
            # Input: Text ----
            tags$div(title="Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2)",
                     textInput(inputId = "peakTolerance", label = "Peak Tolerance", value = "2", placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="line width of the line connecting the peak to the peak labels",
                     textInput(inputId = "peakLabelLineWidth", label = "Peak Label Line Width", value = "2", placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Fontsize of the peak labels",
                     textInput(inputId = "peaksFontSize", label = "Peaks Font Size", value = "2.5", placeholder = ""),
            ),
            
            # Input: MaterialSwitch ----
            tags$div(title="If two peaks are within the tolerance window for peak picking, the higher one is selected",
                     materialSwitch(
                         inputId = "peakConflictUseMax",
                         label = "Peaks Conflict: Use Max Peak", 
                         status = "primary",
                         right = TRUE,
                         value = TRUE
                     ),
            ),
            
            # Input: Text ----
            tags$div(title="Number of signifcant digits the m/z value is rounded to",
                     textInput(inputId = "peaksMzLabelSigFigs", label = "Peaks m/z label sig figs", value = "2", placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Number of signifcant digits the intensity value is rounded to",
                     textInput(inputId = "peaksIntLabelSigFigs", label = "Peaks Intensity label sig figs", value = "2", placeholder = ""),
            ),
            
            # Input: Text ----
            tags$div(title="Number of signifcant digits the S/N value is rounded to",
                     textInput(inputId = "peaksSnLabelSigFigs", label = "Peaks S/N label sig figs", value = "0", placeholder = ""),
            ),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tags$div(class="image-fixed-container", imageOutput("myImage"))
        )
    )
))
