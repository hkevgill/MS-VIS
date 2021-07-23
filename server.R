#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#source("Mass Spectra Visualization V2.R")
source("Function_Read Mass List.R")
source("Function_Plot single MS.R")
source("Function_Overlay Peak List.R")

#Variables from website-----
##Variables for jpeg creation
fig.name<-"Single Spectrum" #figure name, character
fig.height<-6.1 #figure height in cm, numeric
fig.width<-9 #figure width in cm, numeric
fig.res<-800 #figure resolution, numeric
fig.margin<-c(6,7,3,0.5) #figure margins c(bottom, left, top, right), vector of numeric

##Variables for spectrum plotting
#spectrum.filepath<-"180413 PTEN 1st PI3K High_01_%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%_0_G12_1.txt" #Filepath of mass spectrum file, character
# spectrum.separator<-" " #separator in the mass spectrum csv file, character
# spectrum.headerTF<- FALSE #Whether or not the mass spectrum file has column headers, boolean
# spectrum.xaxis.label<-"m/z" #Label below x-axis, character
# spectrum.yaxis.label<-"Intensity" #Label next to y-axis, character
# spectrum.main.label<-"Single Spectrum" #Label above mass spectrum, character
# spectrum.full.range<- FALSE #Whether the entire spectrum, or only a section of it should be displayed, boolean
# spectrum.upper.range.limit.xaxis<- 1530 #Upper end of the x-axis, numeric
# spectrum.lower.range.limit.xaxis<- 1480 #Lower end of the x-axis, numeric  
# spectrum.upper.range.limit.yaxis<-40000 #Upper end of the y-axis, numeric  
# spectrum.lower.range.limit.yaxis<-0 #Lower end of the y-axis, numeric  
# spectrum.axis.fontsize<-3 #Font size of the axis labels, numeric
# spectrum.title.fontsize<-2 #Font size of the main label
# spectrum.axis.ticks.size<-2 #Font size of the axis ticks, numeric
# spectrum.mass.spectrum.color<- "tomato3" #Color of the mass spectrum, character or color hex code
# spectrum.mass.spectrum.line.width<- 2 #Line width of the mass spectrum, numeric
# spectrum.custom.axes<-T #Whether or not the axis ticks are at custom points, boolean
# spectrum.custom.xaxis.pdj<-1 #Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is true), numeric
# spectrum.custom.yaxis.pdj<-(-1) #Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true), numeric
# spectrum.custom.axis.ann.line<-5 #Distance of the axis label to the axis (if custom axes is true), numeric
# spectrum.custom.axis.ann.title.line<- 1 #Distance of the main label from the mass spectrum, numeric
# spectrum.xaxis.interval<-20 #Interval of x-axis ticks (if custom axes is true), numeric
# spectrum.yaxis.interval<-20000 #Interval of y-axis ticks (if custom axes is true), numeric
# spectrum.normalize.spectrum<-T #Whether or not the spectrum should be normalized, as TRUE/FALSE
# spectrum.normalization.method<-3 #which method to use for normalization (values of 1-3): 1= by max peak intensity in entire spectrum, 2= by max peak intensity in selected mass range, 3= by peak intensity of a selected peak
# spectrum.normalization.peak<-1506 #if spectrum.normalization.method=3, then this m.z value will be used for normalization

##Variables for peak labeling
# peaks.mass.list.filepath<-"PTEN+p110a mix vs seq LP.xlsx" #Filepath of mass list 
# peaks.sheet.name<-"180413_PTEN_1st_PI3K_High_01_%%" #Name of the xlsx sheet 
# peaks.selected.masses<-c(1496,1506) #m/z value of the peaks which should be labeled, numeric vector
# peaks.peak.tolerance<-2 #Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2), numeric
# peaks.label.line.width<-2 #line width of the line connecting the peak to the peak labels, numeric
# peaks.label.length<-c(0.1,0.1) #Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)
# peaks.label.spread<- 0.075 #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
# peaks.label.line.lty<-3 #Line type of the line connecting the peak to the peak labels, numeric
# peaks.label.line.col<-"black" #Line type of the line connecting the peak to the peak labels, character or color hex code
# peaks.first.label<- c("Peak 1","Peak 2") #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
# peaks.second.label<- c("2nd Label P1","2nd Label P2") #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
# peaks.labels.on<- c(1,1,1,1,1) #Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio), 1= label is on, 0= label is off
# peaks.label.position<-c("r","R") #Where the peak labels should be displayed. "r" or "l" displays them to the right or left of the peak maximum. "R" or "L" displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)
# peaks.fontsize<-2.5 #Fontsize of the peak labels, numeric
# peaks.if.peak.conflict.use.max<-T #If two peaks are within the tolerance window for peak picking, the higher one is selected, boolean
# peaks.mz.label.sigfigs<-2 #number of signifcant digits the m/z value is rounded to, numeric
# peaks.int.label.sigfigs<-2 #number of signifcant digits the intensity value is rounded to, numeric
# peaks.sn.label.sigfigs<-0 #number of signifcant digits the S/N value is rounded to, numeric

#Variables for extra labels in plot
extra.labels.on<-T #Should additional text be displayed in plot, as TRUE/FALSE
extra.labels.text<-c("","") #Text displayed anywhere in the plot, vector of strings
extra.labels.xpos<-c(1472,1490) #x-coordinates of labels, vector of numeric
extra.labels.ypos<-c(5,3) #y-coordinates of labels, vector of numeric
extra.labels.fontsize<-c(3,2) #fontsize of labels, vector of numeric
extra.labels.col<-c("black","red") #color of labels, vector of color (text or hex)

#Single spectrum----
fig.name.final<-paste(fig.name,".jpg") #adds file extension to file name

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    # Heroku workaround to websocket connection resetting
    autoInvalidate <- reactiveTimer(10000)
    observe({
        autoInvalidate()
        cat(".")
    })

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

        #spectrum variables
        
        #separator in the mass spectrum csv file, character
        if (input$spectrumSeparator == "") {
            spectrum.separator<-" "
        }
        else {
            spectrum.separator<-input$spectrumSeparator
        }

        #Whether or not the mass spectrum file has column headers, boolean
        spectrum.headerTF<-input$spectrumHeader

        #Label below x-axis, character
        spectrum.xaxis.label<-input$spectrumXaxisLabel

        #Label next to y-axis, character
        spectrum.yaxis.label<-input$spectrumYaxisLabel

        #Label above mass spectrum, character
        spectrum.main.label<-input$spectrumMainLabel

        #Color of the mass spectrum
        spectrum.mass.spectrum.color<-input$spectrumColour

        #Whether the entire spectrum, or only a section of it should be displayed, boolean
        spectrum.full.range<-input$spectrumFullRange

        #Upper end of the x-axis, numeric
        spectrum.upper.range.limit.xaxis<-input$spectrumRangeXAxis[2]
        
        #Lower end of the x-axis, numeric
        spectrum.lower.range.limit.xaxis<-input$spectrumRangeXAxis[1]

        #Upper end of the y-axis, numeric 
        spectrum.upper.range.limit.yaxis<-input$spectrumRangeYAxis[2]
        
        #Lower end of the y-axis, numeric  
        spectrum.lower.range.limit.yaxis<-input$spectrumRangeYAxis[1]

        #Font size of the axis labels, numeric
        spectrum.axis.fontsize<-input$spectrumAxisFontSize

        #Font size of the main label
        spectrum.title.fontsize<-input$spectrumTitleFontSize

        #Font size of the axis ticks, numeric
        spectrum.axis.ticks.size<-input$spectrumAxisTickFontSize

        #Line width of the mass spectrum, numeric
        spectrum.mass.spectrum.line.width<- input$spectrumLineWidth

        #Whether or not the axis ticks are at custom points, boolean
        spectrum.custom.axes<-input$spectrumCustomAxes

        #Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is true), numeric
        spectrum.custom.xaxis.pdj<-input$spectrumCustomXAxisPdj

        #Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true), numeric
        spectrum.custom.yaxis.pdj<-(input$spectrumCustomYAxisPdj)

        #Distance of the axis label to the axis (if custom axes is true), numeric
        spectrum.custom.axis.ann.line<-input$spectrumCustomAxisAnnLine

        #Distance of the main label from the mass spectrum, numeric
        spectrum.custom.axis.ann.title.line<-input$spectrumCustomAxisAnnTitleLine

        #Interval of x-axis ticks (if custom axes is true), numeric
        spectrum.xaxis.interval<-as.numeric(input$spectrumXAxisInterval)
        
        #Interval of y-axis ticks (if custom axes is true), numeric
        spectrum.yaxis.interval<-as.numeric(input$spectrumYAxisInterval)
        
        #Whether or not the spectrum should be normalized, as TRUE/FALSE
        spectrum.normalize.spectrum<-input$spectrumNormalizeSpectrum
        
        #Which method to use for normalization (values of 1-3): 1= by max peak intensity in entire spectrum, 2= by max peak intensity in selected mass range, 3= by peak intensity of a selected peak
        spectrum.normalization.method<-input$spectrumNormalizationMethod
        
        #If spectrum.normalization.method=3, then this m.z value will be used for normalization
        spectrum.normalization.peak<-as.numeric(input$spectrumNormalizationPeak)

        #Peak variables
        
        #m/z value of the peaks which should be labeled, numeric vector
        if (input$peaksSelectedMasses == "") {
            peaks.selected.masses<-c(0)
        }
        else {
            peaks.selected.masses<-c(as.numeric(unlist(strsplit(input$peaksSelectedMasses,","))))
        }
        
        #Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)
        if (input$peaksLabelLength == "") {
            peaks.label.length<-c(0)
        }
        else {
            peaks.label.length<-c(as.numeric(unlist(strsplit(input$peaksLabelLength,","))))
        }

        #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
        peaks.label.spread<-as.numeric(input$peaksLabelSpread)

        #Line type of the line connecting the peak to the peak labels, numeric
        peaks.label.line.lty<-as.numeric(input$peaksLabelLineType)

        #Line type of the line connecting the peak to the peak labels, character or color hex code
        peaks.label.line.col<-input$peakslabelLineColour
        
        #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        peaks.first.label<-c(unlist(strsplit(input$peaksFirstLabel,",")))
        
        #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        peaks.second.label<-c(unlist(strsplit(input$peaksSecondLabel,",")))

        #Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio), 1= label is on, 0= label is off
        l1<-0
        l2<-0
        l3<-0
        l4<-0
        l5<-0
        
        for (i in seq_len(length(input$peaksLabelsOn))) {
            if (input$peaksLabelsOn[i] == "1st Label") {l1<-1}
            if (input$peaksLabelsOn[i] == "2nd label") {l2<-1}
            if (input$peaksLabelsOn[i] == "m/z Ratio") {l3<-1}
            if (input$peaksLabelsOn[i] == "Intensity") {l4<-1}
            if (input$peaksLabelsOn[i] == "S/N Ratio") {l5<-1}
        }
        
        peaks.labels.on<-c(l1,l2,l3,l4,l5)
        
        #Where the peak labels should be displayed. "r" or "l" displays them to the right or left of the peak maximum. "R" or "L" displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)
        peaks.label.position<-c(unlist(strsplit(input$peaksLabelPosition,",")))
        
        #Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2), numeric
        peaks.peak.tolerance<-as.numeric(input$peakTolerance)
        
        #line width of the line connecting the peak to the peak labels, numeric
        peaks.label.line.width<-as.numeric(input$peakLabelLineWidth)

        #Fontsize of the peak labels, numeric
        peaks.fontsize<-as.numeric(input$peaksFontSize)

        #If two peaks are within the tolerance window for peak picking, the higher one is selected, boolean
        peaks.if.peak.conflict.use.max<-input$peakConflictUseMax
        
        #Number of signifcant digits the m/z value is rounded to, numeric
        peaks.mz.label.sigfigs<-as.numeric(input$peaksMzLabelSigFigs)
        
        #Number of signifcant digits the intensity value is rounded to, numeric
        peaks.int.label.sigfigs<-as.numeric(input$peaksIntLabelSigFigs)
        
        #Number of signifcant digits the S/N value is rounded to, numeric
        peaks.sn.label.sigfigs<-as.numeric(input$peaksSnLabelSigFigs)
        
        # Generate the jpg
        try(jpeg(filename = fig.name.final,
                 height = fig.height,
                 width = fig.width,
                 res=fig.res,
                 pointsize = 4,
                 units = "cm"))
        
        try(par(mar=fig.margin+0.1))
        
        spectrum.normalization.value<-NA
        
        try(if(spectrum.normalize.spectrum==T){
            masslist.norm<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath,
                                          Sheet.name = peaks.sheet.name,
                                          FullListYN = T,
                                          SelectedMasses = peaks.selected.masses,
                                          tolerance = peaks.peak.tolerance,
                                          if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
            
            if(spectrum.normalization.method==1){
                spectrum.normalization.value<-max(masslist.norm$Intensity)        
            }
            
            if(spectrum.normalization.method==2){
                spectrum.normalization.value<-max(masslist.norm$Intensity[which(masslist.norm$m.z<spectrum.upper.range.limit.xaxis&
                                                                                    masslist.norm$m.z>spectrum.lower.range.limit.xaxis)])        
            }
            
            if(spectrum.normalization.method==3){
                masslist.norm<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath,
                                              Sheet.name = peaks.sheet.name,
                                              FullListYN = F,
                                              SelectedMasses = spectrum.normalization.peak,
                                              tolerance = peaks.peak.tolerance,
                                              if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
                
                spectrum.normalization.value<-masslist.norm$Intensity        
            }
            
        })
        
        try(spectrum<-mass.spectrum.create(rawfile.path=spectrum.filepath,
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
                                           yaxis.interval = spectrum.yaxis.interval,
                                           normalize.spectrum = spectrum.normalize.spectrum,
                                           normalization.value = spectrum.normalization.value))
        
        try(spectrum.label<-mass.spectrum.label.peaks(mass.list.filepath = peaks.mass.list.filepath,
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
                                                      mz.label.sigfigs=peaks.mz.label.sigfigs,
                                                      int.label.sigfigs=peaks.int.label.sigfigs,
                                                      sn.label.sigfigs=peaks.sn.label.sigfigs,
                                                      if.peak.conflict.use.max = peaks.if.peak.conflict.use.max,
                                                      normalize.spectrum = spectrum.normalize.spectrum,
                                                      normalization.value = spectrum.normalization.value))
        
        try(if(extra.labels.on==T){
            text(x=extra.labels.xpos,
                 y=extra.labels.ypos,
                 labels = extra.labels.text,
                 col = extra.labels.col,
                 cex = extra.labels.fontsize,
                 xpd=NA)
        })
        
        dev.off()
        
        file.remove(inFile1$name)
        file.remove(inFile2$name)
        
        list(src = fig.name.final)

    }, deleteFile = TRUE)

})
