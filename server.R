#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("Mass Spectra Visualization V2.R")

#Variables from website-----
##Variables for jpeg creation
fig.name<-"Single Spectrum" #figure name, character
fig.height<-6.1 #figure height in cm, numeric
fig.width<-9 #figure width in cm, numeric
fig.res<-800 #figure resolution, numeric
fig.margin<-c(6,7,3,0.5) #figure margins c(bottom, left, top, right), vector of numeric

##Variables for spectrum plotting
#spectrum.filepath<-"180413 PTEN 1st PI3K High_01_%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_0_G12_1.txt" #Filepath of mass spectrum file, character
spectrum.separator<-" " #separator in the mass spectrum csv file, character
spectrum.headerTF<- FALSE #Whether or not the mass spectrum file has column headers, boolean
spectrum.xaxis.label<-"m/z" #Label below x-axis, character
spectrum.yaxis.label<-"Intensity" #Label next to y-axis, character
spectrum.main.label<-"Single Spectrum" #Label above mass spectrum, character
spectrum.full.range<- FALSE #Whether the entire spectrum, or only a section of it should be displayed, boolean
spectrum.upper.range.limit.xaxis<- 1530 #Upper end of the x-axis, numeric
spectrum.lower.range.limit.xaxis<- 1480 #Lower end of the x-axis, numeric  
spectrum.upper.range.limit.yaxis<-40000 #Upper end of the y-axis, numeric  
spectrum.lower.range.limit.yaxis<-0 #Lower end of the y-axis, numeric  
spectrum.axis.fontsize<-3 #Font size of the axis labels, numeric
spectrum.title.fontsize<-2 #Font size of the main label
spectrum.axis.ticks.size<-2 #Font size of the axis ticks, numeric
spectrum.mass.spectrum.color<- "tomato3" #Color of the mass spectrum, character or color hex code
spectrum.mass.spectrum.line.width<- 2 #Line width of the mass spectrum, numeric
spectrum.custom.axes<-T #Whether or not the axis ticks are at custom points, boolean
spectrum.custom.xaxis.pdj<-1 #Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is true), numeric
spectrum.custom.yaxis.pdj<-(-1) #Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true), numeric
spectrum.custom.axis.ann.line<-5 #Distance of the axis label to the axis (if custom axes is true), numeric
spectrum.custom.axis.ann.title.line<- 1 #Distance of the main label from the mass spectrum, numeric
spectrum.xaxis.interval<-20 #Interval of x-axis ticks (if custom axes is true), numeric
spectrum.yaxis.interval<-20000 #Interval of y-axis ticks (if custom axes is true), numeric

##Variables for peak labeling
#peaks.mass.list.filepath<-"PTEN+p110a mix vs seq LP.xlsx" #Filepath of mass list 
#peaks.sheet.name<-"180413_PTEN_1st_PI3K_High_01_%%" #Name of the xlsx sheet 
peaks.selected.masses<-c(1496,1506) #m/z value of the peaks which should be labeled, numeric vector
peaks.peak.tolerance<-2 #Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2), numeric
peaks.label.line.width<-2 #line width of the line connecting the peak to the peak labels, numeric
peaks.label.length<-c(0.1,0.1) #Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)
peaks.label.spread<- 0.075 #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
peaks.label.line.lty<-3 #Line type of the line connecting the peak to the peak labels, numeric
peaks.label.line.col<-"black" #Line type of the line connecting the peak to the peak labels, character or color hex code
peaks.first.label<- c("Peak 1","Peak 2") #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
peaks.second.label<- c("2nd Label P1","2nd Label P2") #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
peaks.labels.on<- c(1,1,1,1,1) #Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio), 1= label is on, 0= label is off
peaks.label.position<-c("r","R") #Where the peak labels should be displayed. "r" or "l" displays them to the right or left of the peak maximum. "R" or "L" displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)
peaks.fontsize<-2.5 #Fontsize of the peak labels, numeric
peaks.if.peak.conflict.use.max<-T #If two peaks are within the tolerance window for peak picking, the higher one is selected, boolean

#Single spectrum----
fig.name.final<-paste(fig.name,".jpg") #adds file extension to file name

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$myImage <- renderImage({
        
        req(input$file1)
        req(input$file2)
        req(input$peaksSheetName)
        
        inFile1 <- input$file1
        inFile2 <- input$file2
        
        file.copy(inFile1$datapath, file.path(".", inFile1$name) )
        file.copy(inFile2$datapath, file.path(".", inFile2$name) )
        
        spectrum.filepath<-inFile1$name
        peaks.mass.list.filepath<-inFile2$name
        peaks.sheet.name<-input$peaksSheetName
        
        # Generate the jpg
        jpeg(filename = fig.name.final,
             height = fig.height,
             width = fig.width,
             res=fig.res,
             pointsize = 4,
             units = "cm")
        
        par(mar=fig.margin+0.1)
        
        spectrum<-mass.spectrum.create(rawfile.path=spectrum.filepath,
                                       separator=spectrum.separator,
                                       headerTF=spectrum.headerTF,
                                       PlotYN=TRUE,
                                       xaxis.title=spectrum.xaxis.label,
                                       yaxis.title=spectrum.yaxis.label,
                                       spectrum.title=spectrum.main.label,
                                       full.range=spectrum.full.range,
                                       upper.range.limit=spectrum.upper.range.limit.xaxis,
                                       lower.range.limit=spectrum.lower.range.limit.xaxis,
                                       y.axis.lower.limit=spectrum.lower.range.limit.yaxis,
                                       y.axis.upper.limit=spectrum.upper.range.limit.yaxis,
                                       axis.fontsize=spectrum.axis.fontsize,
                                       title.fontsize=spectrum.title.fontsize,
                                       axis.ticks.fontsize=spectrum.axis.ticks.size,
                                       spectrum.color=spectrum.mass.spectrum.color,
                                       spectrum.line.width=spectrum.mass.spectrum.line.width,
                                       custom.axis.ann = T,
                                       custom.y.axis = spectrum.custom.axes,
                                       custom.axis = spectrum.custom.axes,
                                       custom.axis.pdj = spectrum.custom.xaxis.pdj,
                                       custom.y.axis.pdj = spectrum.custom.yaxis.pdj,
                                       custom.axis.ann.line = spectrum.custom.axis.ann.line,
                                       custom.axis.ann.title.line = spectrum.custom.axis.ann.title.line,
                                       xaxis.interval = spectrum.xaxis.interval,
                                       yaxis.interval = spectrum.yaxis.interval)
        
        spectrum.label<-mass.spectrum.label.peaks(mass.list.filepath = peaks.mass.list.filepath,
                                                  Sheet.name = peaks.sheet.name,
                                                  mass.spectrum = spectrum,
                                                  PlotYN = T,
                                                  FullListYN = F,
                                                  SelectedMasses = peaks.selected.masses,
                                                  tolerance = peaks.peak.tolerance,
                                                  label.line.width = peaks.label.line.width,
                                                  label.length =peaks.label.length,
                                                  label.spread = peaks.label.spread,
                                                  label.line.lty = peaks.label.line.lty,
                                                  label.line.col = peaks.label.line.col,
                                                  label.title = peaks.first.label,
                                                  label.second.title = peaks.second.label,
                                                  labels.on = peaks.labels.on,
                                                  label.position = peaks.label.position,
                                                  fontsize = peaks.fontsize,
                                                  if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
        
        dev.off()
        
        file.remove(inFile1$name)
        file.remove(inFile2$name)
        
        list(src = fig.name.final)

    }, deleteFile = TRUE)

})
