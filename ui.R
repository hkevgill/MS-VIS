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
    tags$head(
        HTML("<script type='text/javascript' src='main.js'></script>")
    ),
    
    # Application title
    titlePanel("Mass Spectrum"),
    
    # Output: Tabset ----
    tabsetPanel(
        type = "tabs",
        tabPanel("Single Spectrum",
                 # Sidebar with a slider input for number of bins
                 sidebarLayout(
                     sidebarPanel(
                         h3("Files"),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Mass spectrum file as .txt or .csv with two columns: (1) m/z and (2) intensity",
                             fileInput(
                                 "file1",
                                 "Upload a spectrum file",
                                 multiple = FALSE,
                                 accept = c("text",
                                            "text/plain",
                                            "txt")
                             ),
                         ),
                         
                         # # Input: Text ----
                         # tags$div(title="Separator in the mass spectrum csv file",
                         #          textInput("spectrumSeparator", "Column Separator in the File", value = "", width = NULL, placeholder = "space"),
                         # ),
                         
                         # # Input: SelectInput ----
                         # tags$div(title="File Type",
                         #          selectInput("spectrumFiletype",
                         #                      "File type of the spectrum file",
                         #                      c("CSV" = "csv",
                         #                        "MzXML" = "MzXML"),
                         #                      selected = "CSV"),
                         # ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Separator in the mass spectrum csv file",
                             selectInput(
                                 "spectrumSeparator",
                                 "Column Separator in the File",
                                 c(
                                     "Space" = " ",
                                     "Comma" = ",",
                                     "Tab" = "\t"
                                 ),
                                 selected = "Space"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The row in the spectrum file with the first data value",
                             textInput(
                                 "spectrumFirstDataRow",
                                 "First Data Row in Spectrum File",
                                 value = "1",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # # Input: Checkbox ----
                         # tags$div(title="Whether or not the mass spectrum file has column headers",
                         #          checkboxInput("spectrumHeader", "Does the File have a Header", value = FALSE, width = NULL),
                         # ),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Excel File Mass list file",
                             fileInput(
                                 "file2",
                                 "Upload a Mass List as an Excel File",
                                 multiple = FALSE,
                                 accept = c(".xlsx")
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Sheet name of the excel sheet containing the mass list",
                             textInput(
                                 "peaksSheetName",
                                 "Sheet Name",
                                 value = "",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The row in the mass list where the data entries start",
                             textInput(
                                 "peaksFirstDataRow",
                                 "First Data Row in Mass List",
                                 value = "4",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The column in the mass list which contains the m/z values",
                             textInput(
                                 "peaksColumnMZ",
                                 "Column in the Mass List Containing m/z Values",
                                 value = "1",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The column in the mass list which contains the intensity values",
                             textInput(
                                 "peaksColumnInt",
                                 "Column in the Mass List Containing Intensity Values",
                                 value = "3",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The column in the mass list which contains the S/N values",
                             textInput(
                                 "peaksColumnSN",
                                 "Column in the Mass List Containing S/N Ratios",
                                 value = "4",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         HTML(
                             "<button class=\"accordion\">Spectrum plotting variables</button><div class=\"panel\">"
                         ),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Plot Labels</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label below x-axis",
                             textInput(
                                 "spectrumXaxisLabel",
                                 "X-axis Label",
                                 value = "m/z",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Highlight x-axis label",
                             selectInput(
                                 "spectrumXaxisLabelHighlight",
                                 "Highlight X-axis Label",
                                 c(
                                     "None" = 0,
                                     "Bold" = 1,
                                     "Italic" = 2,
                                     "Underline" = 3
                                 ),
                                 selected = "0"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label next to y-axis",
                             textInput(
                                 "spectrumYaxisLabel",
                                 "Y-axis Label",
                                 value = "Intensity",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Highlight y-axis label",
                             selectInput(
                                 "spectrumYaxisLabelHighlight",
                                 "Highlight Y-axis Label",
                                 c(
                                     "None" = 0,
                                     "Bold" = 1,
                                     "Italic" = 2,
                                     "Underline" = 3
                                 ),
                                 selected = "0"
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the axis label to the axis",
                             sliderInput(
                                 "spectrumCustomAxisAnnLine",
                                 "Position of X-axis and Y-axis Labels:",
                                 min = 1,
                                 max = 10,
                                 value = 5,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label above the mass spectrum",
                             textInput(
                                 "spectrumMainLabel",
                                 "Spectrum Title",
                                 value = "Single Spectrum",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Highlight spectrum title",
                             selectInput(
                                 "spectrumMainLabelHighlight",
                                 "Highlight Spectrum Title",
                                 c(
                                     "None" = 0,
                                     "Italic" = 2,
                                     "Underline" = 3
                                 ),
                                 selected = "0"
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the spetcrum title label from the mass spectrum",
                             sliderInput(
                                 "spectrumCustomAxisAnnTitleLine",
                                 "Position of the Spectrum Title:",
                                 min = 0.1,
                                 max = 10,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML(
                             "Spectrum Border, Colour, and Line Width</button><div class=\"panel\">"
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Define the shape of the border of the spectrum",
                             selectInput(
                                 "spectrumBorder",
                                 "Shape of the Border Around the Spectrum",
                                 c(
                                     "None" = "n",
                                     "O" = "o",
                                     "L" = "l",
                                     "7" = "7",
                                     "C" = "c",
                                     "U" = "u",
                                     "]" = "]"
                                 ),
                                 selected = "o"
                             )
                         ),
                         
                         # Input: ColourInput ----
                         tags$div(
                             title = "Colour of the mass spectrum",
                             colourInput(
                                 "spectrumColour",
                                 "Spectrum Colour",
                                 value = "#BC5741",
                                 showColour = c("both", "text", "background"),
                                 palette = c("square", "limited"),
                                 allowTransparent = FALSE,
                                 returnName = FALSE
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Line width of the mass spectrum",
                             sliderInput(
                                 "spectrumLineWidth",
                                 "Spectrum Line Width:",
                                 min = 0.01,
                                 max = 3,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Axis range and Intervals</button><div class=\"panel\">"),
                         
                         # Input: Checkbox ----
                         tags$div(
                             title = "Display full collected mass range or only a selected mass range",
                             checkboxInput(
                                 "spectrumFullRange",
                                 "Spectrum Full Range",
                                 value = TRUE,
                                 width = NULL
                             ),
                         ),
                         
                         # Input: NumericRangeInput ----
                         tags$div(
                             title = "Lower and upper ends of the x-axis",
                             numericRangeInput(
                                 inputId = "spectrumRangeXAxis",
                                 label = "X-axis Range",
                                 value = c(0, 4000)
                             ),
                         ),
                         
                         # Input: NumericRangeInput ----
                         tags$div(
                             title = "Lower and upper ends of the y-axis",
                             numericRangeInput(
                                 inputId = "spectrumRangeYAxis",
                                 label = "Y-axis Range",
                                 value = c(0, 40000)
                             ),
                         ),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "Whether or not the axis ticks are at custom points",
                             materialSwitch(
                                 inputId = "spectrumCustomAxes",
                                 label = "Custom Axes",
                                 status = "primary",
                                 right = TRUE,
                                 value = FALSE
                             ),
                         ),
                         
                         # Input: TextInput ----
                         tags$div(
                             title = "Interval of x-axis ticks (if custom axes is selected)",
                             textInput(
                                 inputId = "spectrumXAxisInterval",
                                 label = "X-axis Tick Interval",
                                 value = "20",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: TextInput ----
                         tags$div(
                             title = "Interval of y-axis ticks (if custom axes is selected)",
                             textInput(
                                 inputId = "spectrumYAxisInterval",
                                 label = "Y-axis Tick Interval",
                                 value = "20000",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is selected)",
                             sliderInput(
                                 "spectrumCustomXAxisPdj",
                                 "Position of X-axis Tick Values:",
                                 min = 0.1,
                                 max = 5,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true)",
                             sliderInput(
                                 "spectrumCustomYAxisPdj",
                                 "Position of Y-axis Tick Values::",
                                 min = -5,
                                 max = 5,
                                 value = -1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Font Sizes</button><div class=\"panel\">"),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Font",
                             selectInput(
                                 "spectrumFontType",
                                 "Font Type",
                                 c(
                                     "Arial" = "sans",
                                     "Times New Roman" = "serif",
                                     "Courier" = "mono"
                                 ),
                                 selected = "sans"
                             ),
                         ),
                         
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the axis labels",
                             sliderInput(
                                 "spectrumAxisFontSize",
                                 "Axis Label Font Size:",
                                 min = 0.1,
                                 max = 5,
                                 value = 3,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the spectrum title",
                             sliderInput(
                                 "spectrumTitleFontSize",
                                 "Title Font size:",
                                 min = 1,
                                 max = 5,
                                 value = 2,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the axis ticks",
                             sliderInput(
                                 "spectrumAxisTickFontSize",
                                 "Axis Tick Font Size:",
                                 min = 1,
                                 max = 5,
                                 value = 2,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Figure Margins</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Filename",
                             textInput(
                                 "spectrumFilename",
                                 "Filename",
                                 value = "Spectrum",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Height in cm",
                             textInput(
                                 "spectrumFileHeight",
                                 "Figure Height in cm",
                                 value = "6.1",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Width in cm",
                             textInput(
                                 "spectrumFileWidth",
                                 "Figure Width in cm",
                                 value = "9",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Resolution",
                             textInput(
                                 "spectrumFileResolution",
                                 "Figure Resolution",
                                 value = "800",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Bottom Figure Margin",
                             sliderInput(
                                 "spectrumMarginBottom",
                                 "Bottom Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 6,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Left Figure Margin",
                             sliderInput(
                                 "spectrumMarginLeft",
                                 "Left Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 7,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Top Figure Margin",
                             sliderInput(
                                 "spectrumMarginTop",
                                 "Top Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 3,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Right Figure Margin",
                             sliderInput(
                                 "spectrumMarginRight",
                                 "Right Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 0.5,
                                 step = 0.5
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Normalization</button><div class=\"panel\">"),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "Whether or not the spectrum should be normalized",
                             materialSwitch(
                                 inputId = "spectrumNormalizeSpectrum",
                                 label = "Normalize Spectrum",
                                 status = "primary",
                                 right = TRUE,
                                 value = FALSE
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Which method to use for normalization",
                             selectInput(
                                 "spectrumNormalizationMethod",
                                 "Normalization Method",
                                 c(
                                     "By highest peak in the collected mass range" = 1,
                                     "By highest peak in the selected mass range" = 2,
                                     "By a user-defined peak" = 3
                                 ),
                                 selected = "2"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "If normalization method 'By a user-defined peak' is selected, then the intensity of the peak at this m/z value will be used for normalization",
                             textInput(
                                 inputId = "spectrumNormalizationPeak",
                                 label = "User-defined Peak for Normalization",
                                 value = "",
                                 placeholder = ""
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("</div>"),
                         
                         HTML(
                             "<button class=\"accordion\">Peak labeling variables</button><div class=\"panel\">"
                         ),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Peak and Label Selection</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "m/z value of the peaks which should be labeled. If several peaks should be labeled, the m/z values need to be separated by comma.",
                             textInput(
                                 inputId = "peaksSelectedMasses",
                                 label = "m/z Value of Peaks to be Labeled",
                                 value = "",
                                 placeholder = "Example: 1496, 1506"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Window in dalton from which the peaks selected in 'm/z Value of Peaks to be Labeled' are picked (e.g., 1496+-2)",
                             textInput(
                                 inputId = "peakTolerance",
                                 label = "m/z Tolerance ",
                                 value = "2",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "If two peaks are within the tolerance window for peak picking, the higher one is selected",
                             materialSwitch(
                                 inputId = "peakConflictUseMax",
                                 label = "Peak Conflict: Use Max Peak",
                                 status = "primary",
                                 right = TRUE,
                                 value = TRUE
                             ),
                         ),
                         
                         
                         # Input: Text ----
                         tags$div(
                             title = "Where the peak labels should be displayed. 'r' or 'l' displays them to the right or left of the peak maximum, respectively. 'R' or 'L' displays them to the right or left of the peak at the centre of the y-axis, respectively. Numeric values, representing y-axis positions, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak). Must have as many entries (seprated by comma) as there are selected peaks",
                             textInput(
                                 inputId = "peaksLabelPosition",
                                 label = "Label Position",
                                 value = "l,r",
                                 placeholder = "Example: r,R, must match length of Peaks Selected Masses"
                             ),
                         ),
                         
                         # Input: Text ----
                         # tags$div(title="Number of digits after decimal point the m/z value is rounded to",
                         #          textInput(inputId = "peaksMzLabelSigFigs", label = "m/z Label Rounding", value = "2", placeholder = ""),
                         # ),
                         #
                         # Input: SliderInput ----
                         tags$div(
                             title = "Number of digits after decimal point the m/z value is rounded to",
                             sliderInput(
                                 "peaksMzLabelSigFigs",
                                 "Round m/z value to this many digits:",
                                 min = 0,
                                 max = 10,
                                 value = 1,
                                 step = 1
                             ),
                         ),
                         
                         # Input: Text ----
                         # tags$div(title="Number of digits after decimal point the intensity value is rounded to",
                         #          textInput(inputId = "peaksIntLabelSigFigs", label = "Intensity Label Rounding", value = "2", placeholder = ""),
                         # ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Number of digits after decimal point the intensity value is rounded to",
                             sliderInput(
                                 "peaksIntLabelSigFigs",
                                 "Round intensity value to this many digits:",
                                 min = 0,
                                 max = 10,
                                 value = 1,
                                 step = 1
                             ),
                         ),
                         
                         # Input: Text ----
                         # tags$div(title="Number of digits after decimal point the S/N value is rounded to",
                         #          textInput(inputId = "peaksSnLabelSigFigs", label = "S/N Label Rounding", value = "0", placeholder = ""),
                         # ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Number of digits after decimal point the S/N value is rounded to",
                             sliderInput(
                                 "peaksSnLabelSigFigs",
                                 "Round S/N value to this many digits:",
                                 min = 0,
                                 max = 10,
                                 value = 1,
                                 step = 1
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "First label of the peaks, must have as many entries as there are selected peaks",
                             textInput(
                                 inputId = "peaksFirstLabel",
                                 label = "1st Label",
                                 value = "1st label Peak #1,1st label Peak #2",
                                 placeholder = "Example: Peak 1,Peak 2. Must have as many entries (seprated by comma) as there are selected peaks"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Second label of the peaks, must have as many entries as there are selected peaks",
                             textInput(
                                 inputId = "peaksSecondLabel",
                                 label = "2nd Label",
                                 value = "2nd label Peak #1,2nd label Peak #2",
                                 placeholder = "Example: 2nd Label P1,2nd Label P2. Must have as many entries (seprated by comma) as there are selected peaks"
                             ),
                         ),
                         
                         # Input: Checkbox Group Buttons ----
                         tags$div(
                             title = "Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio)",
                             checkboxGroupButtons(
                                 inputId = "peaksLabelsOn",
                                 label = "Peak Labels Enabled",
                                 choices = c("1st Label", "2nd label", "m/z Ratio", "Intensity", "S/N Ratio"),
                                 status = "primary",
                                 selected = c("1st Label", "2nd label", "m/z Ratio", "Intensity", "S/N Ratio")
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Label Style</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Distance of the peak labels from the peak (length of the line connecting the peak to the peak labels). Must have as many entries as there are selected peaks",
                             textInput(
                                 inputId = "peaksLabelLength",
                                 label = "Label Distance",
                                 value = "0.1,0.1",
                                 placeholder = "Example: 0.1,0.1, must match length of Peaks Selected Masses"
                             ),
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
                         tags$div(
                             title = "Line spacing within labels of one peak (Label1,Label2,S/N/Intensity,Area)",
                             sliderInput(
                                 "peaksLabelSpread",
                                 "Label Spacing:",
                                 min = 0,
                                 max = 0.3,
                                 value = 0.05,
                                 step = 0.01
                             ),
                         ),
                         
                         # # Input: Text ----
                         # tags$div(title="Line type of the line connecting the peak to the peak labels",
                         #          textInput(inputId = "peaksLabelLineType", label = "Label Line Type", value = "3", placeholder = ""),
                         # ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Line type of the line connecting the peak to the peak labels",
                             selectInput(
                                 "peaksLabelLineType",
                                 "Label Line Type",
                                 c(
                                     "Blank" = 0,
                                     "Solid" = 1,
                                     "Dashed" = 2,
                                     "Dotted" = 3,
                                     "Dotdash" = 4,
                                     "Longdash" = 5,
                                     "Twodash" = 6
                                 ),
                                 selected = "2"
                             ),
                         ),
                         
                         # # Input: Text ----
                         # tags$div(title="Line width of the line connecting the peak to the peak labels",
                         #          textInput(inputId = "peakLabelLineWidth", label = "Label Line Width", value = "1", placeholder = ""),
                         # ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Line width of the line connecting the peak to the peak labels",
                             sliderInput(
                                 "peakLabelLineWidth",
                                 "Label Line Width:",
                                 min = 0.01,
                                 max = 3,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: ColourInput ----
                         tags$div(
                             title = "Colour of the line connecting the peak to the peak labels",
                             colourInput(
                                 "peakslabelLineColour",
                                 "Label Line Colour",
                                 value = "#000000",
                                 showColour = c("both", "text", "background"),
                                 palette = c("square", "limited"),
                                 allowTransparent = FALSE,
                                 returnName = FALSE
                             ),
                         ),
                         
                         
                         
                         # # Input: Text ----
                         # tags$div(title="Fontsize of the peak labels",
                         #          textInput(inputId = "peaksFontSize", label = "Label Font Size", value = "1.5", placeholder = ""),
                         # ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Fontsize of the peak labels",
                             sliderInput(
                                 "peaksFontSize",
                                 "Label Font Size:",
                                 min = 0.01,
                                 max = 3,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("</div>"),
                         
                         HTML(
                             "<button class=\"accordion\">Peak Finder</button><div class=\"panel\">"
                         ),
                 
                         # Input: Text ----
                         tags$div(
                             title = "The first sheet in the excel file to start the peak finder",
                             textInput(
                                 inputId = "peakFinderSheetStart",
                                 label = "First sheet",
                                 value = "1",
                                 placeholder = "1"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "The last sheet in the excel file where the peak finder ends. Can be either 'last' or a nuber",
                             textInput(
                                 inputId = "peakFinderSheetEnd",
                                 label = "Final sheet",
                                 value = "last",
                                 placeholder = "last"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "m/z value of the peaks which should be searched. If several peaks are searched, the m/z values need to be separated by comma.",
                             textInput(
                                 inputId = "peakFinderSelectedMasses",
                                 label = "m/z Value of Peaks to be Searched",
                                 value = "",
                                 placeholder = "Example: 1496, 1506"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Window in dalton from which the peaks selected in 'm/z Value of Peaks to be Searched' are picked (e.g., 1496+-2)",
                             textInput(
                                 inputId = "peakFinderTolerance",
                                 label = "m/z Tolerance ",
                                 value = "2",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "If two peaks are within the tolerance window for peak picking, the higher one is selected",
                             materialSwitch(
                                 inputId = "peakFinderConflictUseMax",
                                 label = "Peak Conflict: Use Max Peak",
                                 status = "primary",
                                 right = TRUE,
                                 value = TRUE
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Name of the file containing the results",
                             textInput(
                                 inputId = "peakFinderSaveFileName",
                                 label = "Name of Save File ",
                                 value = "Savefile",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "Run Peak Finder?",
                             materialSwitch(
                                 inputId = "peakFinderRun",
                                 label = "Run Peak Finder?",
                                 status = "primary",
                                 right = TRUE,
                                 value = FALSE
                             ),
                         ),
                         
                         #Run peak finder----
                         # tags$div(title="Run Peak Finder",
                         #          actionButton("runPeakFinder","Run Peak Finder"),
                         # ),
                         
                         
                         
                         #selected.masses,
                         #tolerance,
                         #if.peak.conflict.use.max=T,
                         #save.file.name="Peak Finder Results",
                         
                         
                         HTML("</div>")
                         
                         
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                         # Button
                         #downloadButton('downloadData', 'Download PeakFinder'),
                         uiOutput('downloadButton'),
                         
                         tags$div(class = "image-fixed-container", imageOutput("singleSpectrum"))
                     )
                 )),
        tabPanel("Overlaid Spectrum",
                 # Sidebar with a slider input for number of bins
                 sidebarLayout(
                     sidebarPanel(
                         h3("Files"),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Overlaid mass spectrum file as .txt or .csv with two columns: (1) m/z and (2) intensity",
                             fileInput(
                                 "overlaidSpectrumFile1",
                                 "Upload first spectrum file",
                                 multiple = FALSE,
                                 accept = c("text",
                                            "text/plain",
                                            "txt")
                             ),
                         ),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Overlaid mass spectrum file as .txt or .csv with two columns: (1) m/z and (2) intensity",
                             fileInput(
                                 "overlaidSpectrumFile2",
                                 "Upload second spectrum file",
                                 multiple = FALSE,
                                 accept = c("text",
                                            "text/plain",
                                            "txt")
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Separator in the mass spectrum csv file",
                             selectInput(
                                 "overlaidSpectrumSeparator",
                                 "Column Separator in the files",
                                 c(
                                     "Space" = " ",
                                     "Comma" = ",",
                                     "Tab" = "\t"
                                 ),
                                 selected = "Space"
                             ),
                         ),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Excel mass list file for the first spectrum",
                             fileInput(
                                 "overlaidMassListFile1",
                                 "Upload a Mass List as an Excel File for the first spectrum",
                                 multiple = FALSE,
                                 accept = c(".xlsx")
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Sheet name of the excel sheet containing the mass list for the first spectrum",
                             textInput(
                                 "overlaidPeaksSheetName1",
                                 "Sheet Name for the first Mass List",
                                 value = "",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Select a file ----
                         tags$div(
                             title = "Excel mass list file for the second spectrum",
                             fileInput(
                                 "overlaidMassListFile2",
                                 "Upload a Mass List as an Excel File for the second spectrum",
                                 multiple = FALSE,
                                 accept = c(".xlsx")
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Sheet name of the excel sheet containing the mass list for the second spectrum",
                             textInput(
                                 "overlaidPeaksSheetName2",
                                 "Sheet Name for the second Mass List",
                                 value = "",
                                 width = NULL,
                                 placeholder = NULL
                             ),
                         ),
                         
                         # Input: Checkbox ----
                         #tags$div(title="Whether or not the mass spectrum file has column headers",
                         #         checkboxInput("overlaidSpectrumHeader", "Does the File have a Header", value = FALSE, width = NULL),
                         #),
                         
                         HTML(
                             "<button class=\"accordion\">Spectrum plotting variables</button><div class=\"panel\">"
                         ),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Plot Labels</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label below x-axis",
                             textInput(
                                 "overlaidSpectrumXaxisLabel",
                                 "X-axis Label",
                                 value = "m/z",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label below y-axis",
                             textInput(
                                 "overlaidSpectrumYaxisLabel",
                                 "Y-axis Label",
                                 value = "Intensity",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the axis label to the axis",
                             sliderInput(
                                 "overlaidSpectrumCustomAxisAnnLine",
                                 "Position of X-axis and Y-axis Labels:",
                                 min = 1,
                                 max = 10,
                                 value = 5,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Label above the mass spectrum",
                             textInput(
                                 "overlaidSpectrumMainLabel",
                                 "Spectrum Title",
                                 value = "Overlaid Spectra",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the spetcrum title label from the mass spectrum",
                             sliderInput(
                                 "overlaidSpectrumCustomAxisAnnTitleLine",
                                 "Position of the Spectrum Title:",
                                 min = 0.1,
                                 max = 10,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML(
                             "Spectrum Border, Colour, and Line Width</button><div class=\"panel\">"
                         ),
                         
                         # Input: ColourInput ----
                         tags$div(
                             title = "Colour of the mass spectrum",
                             colourInput(
                                 "overlaidSpectrumColour1",
                                 "First Spectrum Colour",
                                 value = "#BC5741",
                                 showColour = c("both", "text", "background"),
                                 palette = c("square", "limited"),
                                 allowTransparent = FALSE,
                                 returnName = FALSE
                             ),
                         ),
                         
                         # Input: ColourInput ----
                         tags$div(
                             title = "Colour of the mass spectrum",
                             colourInput(
                                 "overlaidSpectrumColour2",
                                 "Second Spectrum Colour",
                                 value = "#4682B4",
                                 showColour = c("both", "text", "background"),
                                 palette = c("square", "limited"),
                                 allowTransparent = FALSE,
                                 returnName = FALSE
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Line width of the mass spectrum",
                             sliderInput(
                                 "overlaidSpectrumLineWidth1",
                                 "First Spectrum Line Width:",
                                 min = 0.01,
                                 max = 3,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Line width of the mass spectrum",
                             sliderInput(
                                 "overlaidSpectrumLineWidth2",
                                 "Second Spectrum Line Width:",
                                 min = 0.01,
                                 max = 3,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Axis range and Intervals</button><div class=\"panel\">"),
                         
                         # Input: NumericRangeInput ----
                         tags$div(
                             title = "Lower and upper ends of the x-axis",
                             numericRangeInput(
                                 inputId = "overlaidSpectrumRangeXAxis",
                                 label = "X-axis Range",
                                 value = c(0, 4000)
                             ),
                         ),
                         
                         # Input: NumericRangeInput ----
                         tags$div(
                             title = "Lower and upper ends of the y-axis",
                             numericRangeInput(
                                 inputId = "overlaidSpectrumRangeYAxis",
                                 label = "Y-axis Range",
                                 value = c(0, 40000)
                             ),
                         ),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "Whether or not the axis ticks are at custom points",
                             materialSwitch(
                                 inputId = "overlaidSpectrumCustomAxes",
                                 label = "Custom Axes",
                                 status = "primary",
                                 right = TRUE,
                                 value = FALSE
                             ),
                         ),
                         
                         # Input: TextInput ----
                         tags$div(
                             title = "Interval of x-axis ticks (if custom axes is selected)",
                             textInput(
                                 inputId = "overlaidSpectrumXAxisInterval",
                                 label = "X-axis Tick Interval",
                                 value = "20",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: TextInput ----
                         tags$div(
                             title = "Interval of y-axis ticks (if custom axes is selected)",
                             textInput(
                                 inputId = "overlaidSpectrumYAxisInterval",
                                 label = "Y-axis Tick Interval",
                                 value = "20000",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is selected)",
                             sliderInput(
                                 "overlaidSpectrumCustomXAxisPdj",
                                 "Position of X-axis Tick Values:",
                                 min = 0.1,
                                 max = 5,
                                 value = 1,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true)",
                             sliderInput(
                                 "overlaidSpectrumCustomYAxisPdj",
                                 "Position of Y-axis Tick Values::",
                                 min = -5,
                                 max = 5,
                                 value = -1,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Font Sizes</button><div class=\"panel\">"),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the axis labels",
                             sliderInput(
                                 "overlaidSpectrumAxisFontSize",
                                 "Axis Label Font Size:",
                                 min = 0.1,
                                 max = 5,
                                 value = 3,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the spectrum title",
                             sliderInput(
                                 "overlaidSpectrumTitleFontSize",
                                 "Title Font size:",
                                 min = 1,
                                 max = 5,
                                 value = 2,
                                 step = 0.1
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Font size of the axis ticks",
                             sliderInput(
                                 "overlaidSpectrumAxisTickFontSize",
                                 "Axis Tick Font Size:",
                                 min = 1,
                                 max = 5,
                                 value = 2,
                                 step = 0.1
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Figure Margins</button><div class=\"panel\">"),
                         
                         # Input: Text ----
                         tags$div(
                             title = "Filename",
                             textInput(
                                 "overlaidSpectrumFilename",
                                 "Filename",
                                 value = "Spectrum",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Height in cm",
                             textInput(
                                 "overlaidSpectrumFileHeight",
                                 "Figure Height in cm",
                                 value = "6.1",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Width in cm",
                             textInput(
                                 "overlaidSpectrumFileWidth",
                                 "Figure Width in cm",
                                 value = "9",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         tags$div(
                             title = "Figure Resolution",
                             textInput(
                                 "overlaidSpectrumFileResolution",
                                 "Figure Resolution",
                                 value = "800",
                                 width = NULL,
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Bottom Figure Margin",
                             sliderInput(
                                 "overlaidSpectrumMarginBottom",
                                 "Bottom Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 6,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Left Figure Margin",
                             sliderInput(
                                 "overlaidSpectrumMarginLeft",
                                 "Left Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 7,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Top Figure Margin",
                             sliderInput(
                                 "overlaidSpectrumMarginTop",
                                 "Top Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 3,
                                 step = 0.5
                             ),
                         ),
                         
                         # Input: SliderInput ----
                         tags$div(
                             title = "Right Figure Margin",
                             sliderInput(
                                 "overlaidSpectrumMarginRight",
                                 "Right Figure Margin:",
                                 min = 0,
                                 max = 10,
                                 value = 0.5,
                                 step = 0.5
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("<button class=\"inner-accordion\">"),
                         icon("plus-circle", class = NULL, lib = "font-awesome"),
                         HTML("Normalization</button><div class=\"panel\">"),
                         
                         # Input: MaterialSwitch ----
                         tags$div(
                             title = "Whether or not the spectrum should be normalized",
                             materialSwitch(
                                 inputId = "overlaidSpectrumNormalizeSpectrum",
                                 label = "Normalize Spectrum",
                                 status = "primary",
                                 right = TRUE,
                                 value = FALSE
                             ),
                         ),
                         
                         # Input: SelectInput ----
                         tags$div(
                             title = "Which method to use for normalization",
                             selectInput(
                                 "overlaidSpectrumNormalizationMethod",
                                 "Normalization Method",
                                 c(
                                     "By highest peak in the collected mass range" = 1,
                                     "By highest peak in the selected mass range" = 2,
                                     "By a user-defined peak" = 3
                                 ),
                                 selected = "2"
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "If normalization method 'By a user-defined peak' is selected, then the intensity of the peak at this m/z value will be used for normalization",
                             textInput(
                                 inputId = "overlaidSpectrumNormalizationPeak1",
                                 label = "First Spectrum User-defined Peak for Normalization",
                                 value = "",
                                 placeholder = ""
                             ),
                         ),
                         
                         # Input: Text ----
                         tags$div(
                             title = "If normalization method 'By a user-defined peak' is selected, then the intensity of the peak at this m/z value will be used for normalization",
                             textInput(
                                 inputId = "overlaidSpectrumNormalizationPeak2",
                                 label = "Second Spectrum User-defined Peak for Normalization",
                                 value = "",
                                 placeholder = ""
                             ),
                         ),
                         
                         HTML("</div>"),
                         
                         HTML("</div>"),
                         
                     ),
                     
                     # Show a plot of the generated distribution
                     mainPanel(
                         tags$div(class = "image-fixed-container", imageOutput("overlaidSpectrum"))
                     )
                 )
                 ),
        tabPanel("About", HTML("<div><h3>About</h3><p>This mass-spectrum online plotting tool is made for visualizing and labelling MALDI mass spectra. The online tool is an easy to use interface for users with no prior programming experience We plan to expand this online tool to accept other data formats to make a more general tool for mass-spectra visualization.</p><p>Citation: DOI: TBD</p><p>Creators: Bjorn Froehlich, Kevin Gill, and Anuj Joshi</p></div>"))
        
    ),
))
