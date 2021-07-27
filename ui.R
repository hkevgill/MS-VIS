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
    tags$head(HTML("<script type='text/javascript' src='main.js'></script>")),

    # Application title
    titlePanel("Mass Spectrum"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Files"),
            
            # Input: Select a file ----
            tags$div(title="Mass spectrum file as .txt or .csv with two columns: (1) m/z and (2) intensity",
                fileInput("file1", "Upload a spectrum file",
                      multiple = FALSE,
                      accept = c("text",
                                 "text/plain",
                                 "txt")),
            ),
            
            # Input: Text ----
            tags$div(title="Separator in the mass spectrum csv file",
                     textInput("spectrumSeparator", "Column Separator in the File", value = "", width = NULL, placeholder = "space"),
            ),
            
            # Input: Checkbox ----
            tags$div(title="Whether or not the mass spectrum file has column headers",
                     checkboxInput("spectrumHeader", "Does the File have a Header", value = FALSE, width = NULL),
            ),
            
            # Input: Select a file ----
            tags$div(title="Excel File Mass list file",
                fileInput("file2", "Upload a Mass List as an Excel File",
                      multiple = FALSE,
                      accept = c(".xlsx")),
            ),
            
            # Input: Text ----
            tags$div(title="Sheet name of the excel sheet containing the mass list",
                textInput("peaksSheetName", "Sheet Name", value = "", width = NULL, placeholder = NULL),
            ),
            
            

            HTML("<button class=\"accordion\">Spectrum plotting variables</button><div class=\"panel\">"),
            
            HTML("<button class=\"accordion\">Plot Labels</button><div class=\"panel\">"),
            
            
            # Input: Text ----
            tags$div(title="Label below x-axis",
                textInput("spectrumXaxisLabel", "X-axis Label", value = "m/z", width = NULL, placeholder = ""),
            ),
            
            # Input: SelectInput ----
            tags$div(title="Highlight x-axis label",
                     selectInput("spectrumXaxisLabelHighlight",
                                 "Highlight X-axis Label",
                                 c("None" = 0,
                                   "Bold" = 1,
                                   "Italic" = 2,
                                   "Underline" = 3),
                                 selected = "0"),
            ),
            
            # Input: Text ----
            tags$div(title="Label next to y-axis",
                textInput("spectrumYaxisLabel", "Y-axis Label", value = "Intensity", width = NULL, placeholder = ""),
            ),
            
            # Input: SelectInput ----
            tags$div(title="Highlight y-axis label",
                     selectInput("spectrumYaxisLabelHighlight",
                                 "Highlight Y-axis Label",
                                 c("None" = 0,
                                   "Bold" = 1,
                                   "Italic" = 2,
                                   "Underline" = 3),
                                 selected = "0"),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the axis label to the axis",
                     sliderInput("spectrumCustomAxisAnnLine", "Position of X-axis and Y-axis Labels:",
                                 min = 1, max = 10,
                                 value = 5, step = 0.1),
            ),
            
            # Input: Text ----
            tags$div(title="Label above the mass spectrum",
                textInput("spectrumMainLabel", "Spectrum Title", value = "Single Spectrum", width = NULL, placeholder = ""),
            ),
            
            # Input: SelectInput ----
            tags$div(title="Highlight spectrum title",
                     selectInput("spectrumMainLabelHighlight",
                                 "Highlight Spectrum Title",
                                 c("None" = 0,
                                   "Italic" = 2,
                                   "Underline" = 3),
                                 selected = "0"),
            ),

            # Input: SliderInput ----
            tags$div(title="Distance of the spetcrum title label from the mass spectrum",
                     sliderInput("spectrumCustomAxisAnnTitleLine", "Position of the Spectrum Title:",
                                 min = 0.1, max = 10,
                                 value = 1, step = 0.1),
            ),
            
            HTML("</div>"),
            
            HTML("<button class=\"accordion\">Spectrum Colour and Line Width</button><div class=\"panel\">"),
            
            # Input: ColourInput ----
            tags$div(title="Colour of the mass spectrum",
                colourInput("spectrumColour", "Spectrum Colour", value = "#BC5741", showColour = c("both", "text", "background"), palette = c("square", "limited"), allowTransparent = FALSE, returnName = FALSE),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Line width of the mass spectrum",
                     sliderInput("spectrumLineWidth", "Spectrum Line Width:",
                                 min = 0.01, max = 3,
                                 value = 1, step = 0.1),
            ),
            
            HTML("</div>"),
            
            HTML("<button class=\"accordion\">Axis range and Intervals</button><div class=\"panel\">"),
            
            # Input: Checkbox ----
            tags$div(title="Display full collected mass range or only a selected mass range",
                checkboxInput("spectrumFullRange", "Spectrum Full Range", value = TRUE, width = NULL),
            ),
            
            # Input: NumericRangeInput ----
            tags$div(title="Lower and upper ends of the x-axis",
                numericRangeInput(inputId = "spectrumRangeXAxis", label = "X-axis Range", value = c(0,4000)),
            ),
            
            # Input: NumericRangeInput ----
            tags$div(title="Lower and upper ends of the y-axis",
                numericRangeInput(inputId = "spectrumRangeYAxis", label = "Y-axis Range", value = c(0,40000)),
            ),
            
            # Input: MaterialSwitch ----
            tags$div(title="Whether or not the axis ticks are at custom points",
                     materialSwitch(
                         inputId = "spectrumCustomAxes",
                         label = "Custom Axes", 
                         status = "primary",
                         right = TRUE,
                         value = FALSE
                     ),
            ),
            
            # Input: TextInput ----
            tags$div(title="Interval of x-axis ticks (if custom axes is selected)",
                     textInput(inputId = "spectrumXAxisInterval", label = "X-axis Tick Interval", value = "20", placeholder = ""),
            ),
            
            # Input: TextInput ----
            tags$div(title="Interval of y-axis ticks (if custom axes is selected)",
                     textInput(inputId = "spectrumYAxisInterval", label = "Y-axis Tick Interval", value = "20000", placeholder = ""),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is selected)",
                     sliderInput("spectrumCustomXAxisPdj", "Position of X-axis Tick Values:",
                                 min = 0.1, max = 5,
                                 value = 1, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true)",
                     sliderInput("spectrumCustomYAxisPdj", "Position of Y-axis Tick Values::",
                                 min = -5, max = 5,
                                 value = -1, step = 0.1),
            ),
            
            HTML("</div>"),
            
            
            HTML("<button class=\"accordion\">Font  Sizes</button><div class=\"panel\">"),
            
            # Input: SliderInput ----
            tags$div(title="Font size of the axis labels",
                sliderInput("spectrumAxisFontSize", "Axis Label Font Size:",
                            min = 0.1, max = 5,
                            value = 3, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Font size of the spectrum title",
                sliderInput("spectrumTitleFontSize", "Title Font size:",
                            min = 1, max = 5,
                            value = 2, step = 0.1),
            ),
            
            # Input: SliderInput ----
            tags$div(title="Font size of the axis ticks",
                sliderInput("spectrumAxisTickFontSize", "Axis Tick Font Size:",
                            min = 1, max = 5,
                            value = 2, step = 0.1),
            ),
            
            HTML("</div>"),
            

            HTML("<button class=\"accordion\">Normalization</button><div class=\"panel\">"),
            
            # Input: MaterialSwitch ----
            tags$div(title="Whether or not the spectrum should be normalized",
                     materialSwitch(
                         inputId = "spectrumNormalizeSpectrum",
                         label = "Normalize Spectrum", 
                         status = "primary",
                         right = TRUE,
                         value = FALSE
                     ),
            ),
            
            # Input: SelectInput ----
            tags$div(title="Which method to use for normalization",
                selectInput("spectrumNormalizationMethod",
                            "Normalization Method",
                            c("By highest peak in the collected mass range" = 1,
                              "By highest peak in the selected mass range" = 2,
                              "By a user-defined peak" = 3),
                            selected = "2"),
            ),
            
            # Input: Text ----
            tags$div(title="If normalization method 'By a user-defined peak' is selected, then the intensity of the peak at this m/z value will be used for normalization",
                     textInput(inputId = "spectrumNormalizationPeak", label = "User-defined Peak for Normalization", value = "", placeholder = ""),
            ),
            
            HTML("</div>"),
            
            HTML("</div>"),
            
            HTML("<button class=\"accordion\">Peak labeling variables</button><div class=\"panel\">"),
            
            HTML("<button class=\"accordion\">Peak and Label Selection</button><div class=\"panel\">"),
            
            # Input: Text ----
            tags$div(title="m/z value of the peaks which should be labeled. If several peaks should be labeled, the m/z values need to be separated by comma.",
                     textInput(inputId = "peaksSelectedMasses", label = "m/z Value of Peaks to be Labeled", value = "", placeholder = "Example: 1496, 1506"),
            ),
            
            # Input: Text ----
            tags$div(title="Window in dalton from which the peaks selected in 'm/z Value of Peaks to be Labeled' are picked (e.g., 1496+-2)",
                     textInput(inputId = "peakTolerance", label = "m/z Tolerance ", value = "2", placeholder = ""),
            ),
            
            # Input: MaterialSwitch ----
            tags$div(title="If two peaks are within the tolerance window for peak picking, the higher one is selected",
                     materialSwitch(
                         inputId = "peakConflictUseMax",
                         label = "Peak Conflict: Use Max Peak", 
                         status = "primary",
                         right = TRUE,
                         value = TRUE
                     ),
            ),
            

            # Input: Text ----
            tags$div(title="Where the peak labels should be displayed. 'r' or 'l' displays them to the right or left of the peak maximum, respectively. 'R' or 'L' displays them to the right or left of the peak at the centre of the y-axis, respectively. Numeric values, representing y-axis positions, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak). Must have as many entries (seprated by comma) as there are selected peaks",
                     textInput(inputId = "peaksLabelPosition", label = "Label Position", value = "r", placeholder = "Example: r,R, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            # tags$div(title="Number of digits after decimal point the m/z value is rounded to",
            #          textInput(inputId = "peaksMzLabelSigFigs", label = "m/z Label Rounding", value = "2", placeholder = ""),
            # ),
            # 
            # Input: SliderInput ----
            tags$div(title="Number of digits after decimal point the m/z value is rounded to",
                     sliderInput("peaksMzLabelSigFigs", "Round m/z value to this many digits:",
                                 min = 0, max = 10,
                                 value = 1, step = 1),
            ),
            
            # Input: Text ----
            # tags$div(title="Number of digits after decimal point the intensity value is rounded to",
            #          textInput(inputId = "peaksIntLabelSigFigs", label = "Intensity Label Rounding", value = "2", placeholder = ""),
            # ),
            
            # Input: SliderInput ----
            tags$div(title="Number of digits after decimal point the intensity value is rounded to",
                     sliderInput("peaksIntLabelSigFigs", "Round intensity value to this many digits:",
                                 min = 0, max = 10,
                                 value = 1, step = 1),
            ),
            
            # Input: Text ----
            # tags$div(title="Number of digits after decimal point the S/N value is rounded to",
            #          textInput(inputId = "peaksSnLabelSigFigs", label = "S/N Label Rounding", value = "0", placeholder = ""),
            # ),
            
            # Input: SliderInput ----
            tags$div(title="Number of digits after decimal point the S/N value is rounded to",
                     sliderInput("peaksSnLabelSigFigs", "Round S/N value to this many digits:",
                                 min = 0, max = 10,
                                 value = 1, step = 1),
            ),
            
            # Input: Text ----
            tags$div(title="First label of the peaks, must have as many entries as there are selected peaks",
                     textInput(inputId = "peaksFirstLabel", label = "1st Label", value = "1st label", placeholder = "Example: Peak 1,Peak 2, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Text ----
            tags$div(title="Second label of the peaks, must have as many entries as there are selected peaks",
                     textInput(inputId = "peaksSecondLabel", label = "2nd Label", value = "2nd label", placeholder = "Example: 2nd Label P1,2nd Label P2, must match length of Peaks Selected Masses"),
            ),
            
            # Input: Checkbox Group Buttons ----
            tags$div(title="Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio)",
                     checkboxGroupButtons(
                         inputId = "peaksLabelsOn",
                         label = "Peak Labels Enabled", 
                         choices = c("1st Label", "2nd label", "m/z Ratio", "Intensity", "S/N Ratio"),
                         status = "primary",
                         selected = c("1st Label", "m/z Ratio", "Intensity", "S/N Ratio")
                     ),
            ),
            
            HTML("</div>"),
            
            HTML("<button class=\"accordion\">Label Style</button><div class=\"panel\">"),
            
            # Input: Text ----
            tags$div(title="Distance of the peak labels from the peak (length of the line connecting the peak to the peak labels). Must have as many entries as there are selected peaks",
                     textInput(inputId = "peaksLabelLength", label = "Label Distance", value = "0.1", placeholder = "Example: 0.1,0.1, must match length of Peaks Selected Masses"),
            ),
             
            # Input: SliderInput ----
            # tags$div(title="Distance of the peak labels from the peak (length of the line connecting the peak to the peak labels). Must have as many entries as there are selected peaks",
            #          sliderInput("peaksLabelLength", "Label Distance:",
            #                      min = 0, max = 1,
            #                      value = 0.1, step = 0.05),
            # ),

            # # Input: Text ----
            # tags$div(title="Line spacing within labels of one peak (Label1,Label2,S/N/Intensity,Area)",
            #          textInput(inputId = "peaksLabelSpread", label = "Label Spacing", value = "0.05", placeholder = ""),
            # ),
            
            # Input: SliderInput ----
            tags$div(title="Line spacing within labels of one peak (Label1,Label2,S/N/Intensity,Area)",
                     sliderInput("peaksLabelSpread", "Label Spacing:",
                                 min = 0, max = 0.3,
                                 value = 0.05, step = 0.01),
            ),
            
            # # Input: Text ----
            # tags$div(title="Line type of the line connecting the peak to the peak labels",
            #          textInput(inputId = "peaksLabelLineType", label = "Label Line Type", value = "3", placeholder = ""),
            # ),
            
            # Input: SelectInput ----
            tags$div(title="Line type of the line connecting the peak to the peak labels",
                     selectInput("peaksLabelLineType",
                                 "Label Line Type",
                                 c("Blank" = 0,
                                   "Solid" = 1,
                                   "Dashed" = 2,
                                   "Dotted" = 3,
                                   "Dotdash" = 4,
                                   "Longdash" = 5,
                                   "Twodash" = 6),
                                 selected = "2"),
            ),
            
            # # Input: Text ----
            # tags$div(title="Line width of the line connecting the peak to the peak labels",
            #          textInput(inputId = "peakLabelLineWidth", label = "Label Line Width", value = "1", placeholder = ""),
            # ),
            
            # Input: SliderInput ----
            tags$div(title="Line width of the line connecting the peak to the peak labels",
                     sliderInput("peakLabelLineWidth", "Label Line Width:",
                                 min = 0.01, max = 3,
                                 value = 1, step = 0.1),
            ),
            
            # Input: ColourInput ----
            tags$div(title="Colour of the line connecting the peak to the peak labels",
                     colourInput("peakslabelLineColour", "Label Line Colour", value = "#000000", showColour = c("both", "text", "background"), palette = c("square", "limited"), allowTransparent = FALSE, returnName = FALSE),
            ),
            

            
            # # Input: Text ----
            # tags$div(title="Fontsize of the peak labels",
            #          textInput(inputId = "peaksFontSize", label = "Label Font Size", value = "1.5", placeholder = ""),
            # ),
            
            # Input: SliderInput ----
            tags$div(title="Fontsize of the peak labels",
                     sliderInput("peaksFontSize", "Label Font Size:",
                                 min = 0.01, max = 3,
                                 value = 1, step = 0.1),
            ),

            HTML("</div>"),
            
            HTML("</div>"),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tags$div(class="image-fixed-container", imageOutput("myImage"))
        )
    )
))
