library(shiny)
library(openxlsx)
source("Function_Read Mass List.R")
source("Function_Plot single MS.R")
source("Function_Plot Overlaid MS.R")
source("Function_Overlay Peak List.R")
source("Function_Plot Mirror MS.R")
source("Function_Peak Finder.R")

##Variables for jpeg creation
fig.name<-"Single Spectrum" #figure name, character
fig.height<-6.1 #figure height in cm, numeric
fig.width<-9 #figure width in cm, numeric
fig.res<-800 #figure resolution, numeric
fig.margin<-c(6,7,3,0.5) #figure margins c(bottom, left, top, right), vector of numeric

#Variables for extra labels in plot
extra.labels.on<-T #Should additional text be displayed in plot, as TRUE/FALSE
extra.labels.text<-c("","") #Text displayed anywhere in the plot, vector of strings
extra.labels.xpos<-c(1472,1490) #x-coordinates of labels, vector of numeric
extra.labels.ypos<-c(5,3) #y-coordinates of labels, vector of numeric
extra.labels.fontsize<-c(3,2) #fontsize of labels, vector of numeric
extra.labels.col<-c("black","red") #color of labels, vector of color (text or hex)

rv <- reactiveValues(prevNormalizeSpectrum = FALSE, prevOverlaidNormalizeSpectrum = FALSE)

#Single spectrum----
#fig.name.final<-paste(fig.name,".jpg") #adds file extension to file name

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

    # Heroku workaround to websocket connection resetting
    autoInvalidate <- reactiveTimer(10000)
    observe({
        autoInvalidate()
        cat(".")
    })
    
    #Tutorial data tab
    output$downloadSpectrum1txt <- downloadHandler(
      filename = function() {
        paste("Spectrum #1 as txt.txt")
      },
      content = function(con) {
        try(file.copy(from="Example Data/spectrum 1.txt",
                      to=con))
        
      }
    )
    
    output$downloadSpectrum2txt <- downloadHandler(
      filename = function() {
        paste("Spectrum #2 as txt.txt")
      },
      content = function(con) {
        try(file.copy(from="Example Data/spectrum 2.txt",
                      to=con))
        
      }
    )
    
    output$downloadSpectrum1csv <- downloadHandler(
      filename = function() {
        paste("Spectrum #1 as csv.csv")
      },
      content = function(con) {
        try(file.copy(from="Example Data/spectrum 1.csv",
                      to=con))
        
      }
    )
    
    output$downloadSpectrum2csv <- downloadHandler(
      filename = function() {
        paste("Spectrum #2 as csv.csv")
      },
      content = function(con) {
        try(file.copy(from="Example Data/spectrum 2.csv",
                      to=con))
        
      }
    )
    
    output$downloadMassList <- downloadHandler(
      filename = function() {
        paste("Mass Lists as xlsx.xlsx")
      },
      content = function(con) {
        try(file.copy(from="Example Data/Example Mass Lists.xlsx",
                      to=con))
        
      }
    )
    
    
    #Peak Finder tab
    output$downloadDataPeakFinder<-downloadHandler(
      filename = function() {
        paste0(input$SaveFileNamePeakFinder,".xlsx")
      },
      content = function(con) {

        req(input$ExcelSheetPeakFinder,
            input$peaksFirstDataRow,
            input$peaksFirstDataRowPeakFinder,
            input$peaksColumnMZPeakFinder,
            input$SheetStartPeakFinder,
            input$SheetEndPeakFinder,
            input$SelectedMassesPeakFinder,
            input$TolerancePeakFinder)
        
        inFile2 <- input$ExcelSheetPeakFinder
        
        file.copy(inFile2$datapath, file.path(".", inFile2$name) )
        
        peaks.mass.list.filepath<-inFile2$name
        #peaks.sheet.name<-input$peaksSheetName
        
        #first data row in the excel sheet, numeric
        if (input$peaksFirstDataRow == "") {
          peaks.first.data.row<-4
        }
        else {
          peaks.first.data.row<-as.numeric(input$peaksFirstDataRowPeakFinder)
        }
        
        #column in the excel sheet containing m/z values, numeric
        if (input$peaksColumnMZPeakFinder == "") {
          peaks.column.mz<-1
        }
        else {
          peaks.column.mz<-as.numeric(input$peaksColumnMZPeakFinder)
        }
        
        #Which columns, other than m/z, to pull from the mass list, numeric
        if (input$peaksColumnsExtraPeakFinder == "") {
          peaks.columns.extra<-c(3,4)
        }
        else {
          peaks.columns.extra<-c(as.numeric(unlist(strsplit(input$peaksColumnsExtraPeakFinder,","))))
        }
        
        #Which row contains the column names, numeric
        if (input$peaksRowWithColumnNamesPeakFinder == "") {
          peaks.row.with.column.names<-3
        }
        else {
          peaks.row.with.column.names<-as.numeric(input$peaksRowWithColumnNamesPeakFinder)
        }
        
        #PEAK FINDER FUNCTION
        ##The first sheet to be analysed, numeric
        peakFinder.sheet.start<-as.numeric(input$SheetStartPeakFinder)
        
        ##The last sheet to be analysed, numeric or character ('last')
        peakFinder.sheet.end<-input$SheetEndPeakFinder
        print(peakFinder.sheet.end)
        
        #m/z value of the peaks which should be labeled, numeric vector
        if (input$SelectedMassesPeakFinder == "") {
          peakFinder.selected.masses<-c(0)
        }
        else {
          peakFinder.selected.masses<-c(as.numeric(unlist(strsplit(input$SelectedMassesPeakFinder,","))))
        }        
        
        ##Tolerance in Da of m/z values of peaks which are searched in the mass list, numeric
        peakFinder.tolerance<-as.numeric(input$TolerancePeakFinder)
        
        ##Name of the results file, character
        peakFinder.save.file.name<-input$SaveFileNamePeakFinder
        
        try(test.search<-peak.finder(mass.list.filepath = peaks.mass.list.filepath,
                                  sheet.start=peakFinder.sheet.start,
                                  sheet.end=peakFinder.sheet.end,
                                  selected.masses=peakFinder.selected.masses,
                                  first.data.row=peaks.first.data.row,
                                  column.mz = peaks.column.mz,
                                  columns.extra = peaks.columns.extra,
                                  #columns.extra.names = peaks.columns.extra.names,
                                  row.with.column.names = peaks.row.with.column.names,
                                  #column.int = peaks.column.int,
                                  #column.sn = peaks.column.sn,
                                  tolerance=peakFinder.tolerance,
                                  #if.peak.conflict.use.max=peakFinder.if.peak.conflict.use.max,
                                  save.file.name=peakFinder.save.file.name,
                                  save.file = F))
        
        wb<-createWorkbook()
        
        ##creates as many workbooks as there are selected masses for peak search
        for(i in 1:length(peakFinder.selected.masses)){
          addWorksheet(wb,
                       sheetName = paste("Search Results Peak ",peakFinder.selected.masses[i]))
          writeData(wb,
                    sheet = paste("Search Results Peak ",peakFinder.selected.masses[i]),
                    x=test.search[[i]])
        }
        
        saveWorkbook(wb,
                     file=con,
                     overwrite = T)
        
        file.remove(inFile2$name)
        
      }
    )
    
    output$singleSpectrum <- renderImage({
        req(input$file1)
        
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

        #first data row in the spectrum file, numeric
        if (input$spectrumFirstDataRow == "") {
            spectrum.first.data.row<-1
        }
        else {
            spectrum.first.data.row<-as.numeric(input$spectrumFirstDataRow)
        }
        
        
        #Label below x-axis, character
        #spectrum.filetype<-input$spectrumFiletype
        spectrum.filetype<-"csv"
        
        #Whether or not the mass spectrum file has column headers, boolean
        #spectrum.headerTF<-input$spectrumHeader
        spectrum.headerTF<-F
        
        #first data row in the excel sheet, numeric
        if (input$peaksFirstDataRow == "") {
            peaks.first.data.row<-4
        }
        else {
            peaks.first.data.row<-as.numeric(input$peaksFirstDataRow)
        }
        
        #column in the excel sheet containing m/z values, numeric
        if (input$peaksColumnMZ == "") {
            peaks.column.mz<-1
        }
        else {
            peaks.column.mz<-as.numeric(input$peaksColumnMZ)
        }
        
        
        #column in the excel sheet containing Intensity values, numeric
        if (input$peaksColumnInt == "") {
            peaks.column.int<-3
        }
        else {
            peaks.column.int<-as.numeric(input$peaksColumnInt)
        }
        
        #column in the excel sheet containing S/N values, numeric
        if (input$peaksColumnSN == "") {
            peaks.column.sn<-4
        }
        else {
            peaks.column.sn<-as.numeric(input$peaksColumnSN)
        }
        
        #Name of jpg file
        if(input$spectrumFilename==""){
            fig.name<-"spectrum"
        } else{
            fig.name<-input$spectrumFilename
        }
        
        fig.name.final<-paste0(fig.name,".png") #adds file extension to file name

        #Whether background of png should be transparent
        if(input$spectrumPlotPNGTransparency==T){
            spectrum.transparency<-"transparent"
        } else {
           spectrum.transparency<-"white"
        }
        
        #Height in cm of file
        if(input$spectrumFileHeight==""){
            fig.height<-6
        } else{
            fig.height<-as.numeric(input$spectrumFileHeight)
        }
        
        #Width in cm of file
        if(input$spectrumFileWidth==""){
            fig.width<-7
        } else{
            fig.width<-as.numeric(input$spectrumFileWidth)    
        }
        
        #File resolution
        if(input$spectrumFileResolution==""){
            fig.res<-800
        } else{
            fig.res<-as.numeric(input$spectrumFileResolution)    
        }
        
   
        #Figure margins, numeric
        fig.margin<-c(as.numeric(input$spectrumMarginBottom),
                      as.numeric(input$spectrumMarginLeft),
                      as.numeric(input$spectrumMarginTop),
                      as.numeric(input$spectrumMarginRight))
        
        #Label below x-axis, character
        spectrum.xaxis.label<-input$spectrumXaxisLabel
        
        #Whether label below x-axis should be highlighted (bold, italic, or underlined), numeric (0-3)
        spectrum.xaxis.label.highlight<-input$spectrumXaxisLabelHighlight
        
        #Label next to y-axis, character
        spectrum.yaxis.label<-input$spectrumYaxisLabel

        #Whether label next to y-axis should be highlighted (bold, italic, or underlined), numeric (0-3)
        spectrum.yaxis.label.highlight<-input$spectrumYaxisLabelHighlight
        
        #Label above mass spectrum, character
        spectrum.main.label<-input$spectrumMainLabel

        #Whether label above mass spectrum should be highlighted (italic, or underlined), numeric (0-3)
        spectrum.main.label.highlight<-input$spectrumMainLabelHighlight
        
        #Color of the mass spectrum
        spectrum.mass.spectrum.color<-input$spectrumColour

        #Shape of the border around the spectrum, character
        spectrum.Border<-input$spectrumBorder
        
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

        #Font type the spectrum, character
        spectrum.fonttype<-input$spectrumFontType
        
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

        #Whether or not to show the x-axis (only affects its display, not the scaling of the plot)
        spectrum.show.x.axis<-input$spectrumShowXAxis

        #Whether or not to show the y-axis (only affects its display, not the scaling of the plot)
        spectrum.show.y.axis<-input$spectrumShowYAxis
        
        #Interval of x-axis ticks (if custom axes is true), numeric
        spectrum.xaxis.interval<-as.numeric(input$spectrumXAxisInterval)
        
        #Interval of y-axis ticks (if custom axes is true), numeric
        spectrum.yaxis.interval<-as.numeric(input$spectrumYAxisInterval)
        
        #Whether or not the spectrum should be normalized, as TRUE/FALSE
        #Also sets the y-axis range to 0 to 1
        if (rv$prevNormalizeSpectrum == FALSE && input$spectrumNormalizeSpectrum == TRUE) {
            # Set y range from 0 to 1
            updateNumericRangeInput(session = session, inputId = "spectrumRangeYAxis", value = c(0, 1))
            rv$prevNormalizeSpectrum<-TRUE
        }
        else if (rv$prevNormalizeSpectrum == TRUE && input$spectrumNormalizeSpectrum == FALSE) {
          rv$prevNormalizeSpectrum<-FALSE
        }
        spectrum.normalize.spectrum<-input$spectrumNormalizeSpectrum
        
        #Which method to use for normalization (values of 1-3): 1= by max peak intensity in entire spectrum, 2= by max peak intensity in selected mass range, 3= by peak intensity of a selected peak
        spectrum.normalization.method<-input$spectrumNormalizationMethod
        
        #If spectrum.normalization.method=3, then this m.z value will be used for normalization
        spectrum.normalization.peak<-as.numeric(input$spectrumNormalizationPeak)

        #Peak variables
        
        peaks.mass.list.filepath<-inFile2$name
        peaks.sheet.name<-input$peaksSheetName
        
        if (!is.null(peaks.mass.list.filepath) && !is.null(peaks.sheet.name)) {
            
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
    
            #peaks.label.length<-as.numeric(input$peaksLabelLength)
            
            #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
            peaks.label.spread<-as.numeric(input$peaksLabelSpread)
    
            #Line type of the line connecting the peak to the peak labels, numeric
            peaks.label.line.lty<-as.numeric(input$peaksLabelLineType)
    
            #Line type of the line connecting the peak to the peak labels, character or color hex code
            peaks.label.line.col<-input$peakslabelLineColour
            
            #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
            #peaks.first.label<-c(unlist(strsplit(input$peaksFirstLabel,",")))
            if (input$peaksFirstLabel == "") {
                peaks.first.label<-""
            }
            else {
                peaks.first.label<-c(unlist(strsplit(input$peaksFirstLabel,",")))
            }
            
            
            #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
            if (input$peaksSecondLabel == "") {
                peaks.second.label<-""
            }
            else {
                peaks.second.label<-c(unlist(strsplit(input$peaksSecondLabel,",")))
            }
            
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
        
        }

        # Generate the png
        try(png(filename = fig.name.final,
                 height = fig.height,
                 width = fig.width,
                 res=fig.res,
                 pointsize = 4,
                 units = "cm",
                 bg=spectrum.transparency))
        
        try(par(mar=fig.margin+0.1,
                family=spectrum.fonttype))
        
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
        
        try(dev.control(displaylist="enable"))
        
        try(spectrum<-mass.spectrum.create(rawfile.path=spectrum.filepath,
                                           separator=spectrum.separator,
                                           decimal = input$DecimalSeparator,
                                           headerTF=spectrum.headerTF,
                                           first.data.row = spectrum.first.data.row,
                                           filetype = spectrum.filetype,
                                           PlotYN=TRUE,
                                           xaxis.title=spectrum.xaxis.label,
                                           xaxis.title.highlight=spectrum.xaxis.label.highlight,
                                           yaxis.title=spectrum.yaxis.label,
                                           yaxis.title.highlight=spectrum.yaxis.label.highlight,
                                           spectrum.title=spectrum.main.label,
                                           spectrum.title.highlight=spectrum.main.label.highlight,
                                           full.range=spectrum.full.range,
                                           border = spectrum.Border,
                                           upper.range.limit=spectrum.upper.range.limit.xaxis,
                                           lower.range.limit=spectrum.lower.range.limit.xaxis,
                                           y.axis.lower.limit=spectrum.lower.range.limit.yaxis,
                                           y.axis.upper.limit=spectrum.upper.range.limit.yaxis,
                                           show.x.axis=spectrum.show.x.axis,
                                           show.y.axis=spectrum.show.y.axis,
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
                                           normalization.value = spectrum.normalization.value,
                                           normalize.spectrum.show.as.percent = input$spectrumNormalize.spectrum.show.as.percent,
                                           axis.line.width=input$spectrumAxesLineWidth))
        
        if (!is.null(peaks.mass.list.filepath) && !is.null(peaks.sheet.name)) {
            try(spectrum.label<-mass.spectrum.label.peaks(mass.list.filepath = peaks.mass.list.filepath,
                                                          Sheet.name = peaks.sheet.name,
                                                          mass.spectrum = spectrum,
                                                          PlotYN = T,
                                                          FullListYN = F,
                                                          SelectedMasses = peaks.selected.masses,
                                                          first.data.row = peaks.first.data.row,
                                                          column.mz = peaks.column.mz,
                                                          column.int = peaks.column.int,
                                                          column.sn = peaks.column.sn,
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
                                                          round.or.sigfig=input$peaksMzLabelRounding,
                                                          int.label.sigfigs=peaks.int.label.sigfigs,
                                                          sn.label.sigfigs=peaks.sn.label.sigfigs,
                                                          if.peak.conflict.use.max = peaks.if.peak.conflict.use.max,
                                                          normalize.spectrum = spectrum.normalize.spectrum,
                                                          normalization.value = spectrum.normalization.value,
                                                          normalize.spectrum.show.as.percent = input$spectrumNormalize.spectrum.show.as.percent,
                                                          label1.highlight=input$peaksLabel1Highlight,
                                                          label2.highlight=input$peaksLabel2Highlight))
        }
        
        try(if(extra.labels.on==T){
            text(x=extra.labels.xpos,
                 y=extra.labels.ypos,
                 labels = extra.labels.text,
                 col = extra.labels.col,
                 cex = extra.labels.fontsize,
                 xpd=NA)
        })
        
        try(record.record.single.spectrum.vars<<-data.frame("filename"=fig.name.final,
                                                           "height"=fig.height,
                                                           "width"=fig.width,
                                                           "res"=fig.res,
                                                           "bg"=spectrum.transparency))
        
        
        try(record.single.spectrum<<-recordPlot())
        try(dev.control(displaylist="inhibit"))
        
        dev.off()
        
            #Run save settings function
            try(if(input$saveSettings==T){
                if (!is.null(peaks.mass.list.filepath) && !is.null(peaks.sheet.name)) {
                    user.input<<-list("Spectrum File"=spectrum.filepath,
                                     "Excel File with Mass List"=peaks.mass.list.filepath,
                                     "Mass List Sheet Name"=peaks.sheet.name,
                                     "Column Separator in Spectrum File"=spectrum.separator,
                                     "Decimal Separator"= input$DecimalSeparator,
                                     "First Data Row in the Spectrum File"=spectrum.first.data.row,
                                     "First Data Row in Mass List"=peaks.first.data.row,
                                     #"Column in the Mass List Containing m/z Values"=peaks.column.mz,
                                     #"Column in the Mass List Containing Intensity Values"=peaks.column.int,
                                     #"Column in the Mass List Containing S/N Values"=peaks.column.SN,
                                     #"fig.name"=fig.name,
                                     "Figure Height in cm"=fig.height,
                                     "Figure Width in cm"=fig.width,
                                     "Figure Resolution"=fig.res,
                                     "Bottom Figure Margin"=fig.margin[1],
                                     "Left Figure Margin"=fig.margin[2],
                                     "Top Figure Margin"=fig.margin[3],
                                     "Right Figure Margin"=fig.margin[4],
                                     "X-axis Label"=spectrum.xaxis.label,
                                     "Highlight X-axis Label"=spectrum.xaxis.label.highlight,
                                     "Y-axis Label"=spectrum.yaxis.label,
                                     "Highlight y-axis Label"=spectrum.yaxis.label.highlight,
                                     "Spectrum Title"=spectrum.main.label,
                                     "Highlight Spectrum Title"=spectrum.main.label.highlight,
                                     "Spectrum Colour"=spectrum.mass.spectrum.color,
                                     "Shape of the Border Around the Spectrum"=spectrum.Border,
                                     "Spectrum Full Range"=spectrum.full.range,
                                     "X-axis Range Upper Limit"=spectrum.upper.range.limit.xaxis,
                                     "X-axis Range Lower Limit"=spectrum.lower.range.limit.xaxis,
                                     "Y-axis Range Upper Limit"=spectrum.upper.range.limit.yaxis,
                                     "Y-axis Range Lower Limit"=spectrum.lower.range.limit.yaxis,
                                     "Font Type"=spectrum.fonttype,
                                     "Axis Label Font Size"=spectrum.axis.fontsize,
                                     "Title Font Size"=spectrum.title.fontsize,
                                     "Axis Tick Font Size"=spectrum.axis.ticks.size,
                                     "Spectrum Line Width"=spectrum.mass.spectrum.line.width,
                                     "Custom Axes"=spectrum.custom.axes,
                                     "Position of X-axis Tick Values:"=spectrum.custom.xaxis.pdj,
                                     "Position of Y-axis Tick Values:"=spectrum.custom.yaxis.pdj,
                                     "Position of X-axis and Y-axis Labels"=spectrum.custom.axis.ann.line,
                                     "Position of the Spectrum Title"=spectrum.custom.axis.ann.title.line,
                                     "Show x-Axis"=spectrum.show.x.axis,
                                     "Show y-axis"=spectrum.show.y.axis,
                                     "X-axis Tick Interval"=spectrum.xaxis.interval,
                                     "Y-axis Tick Interval"=spectrum.yaxis.interval,
                                     "Normalize Spectrum"=spectrum.normalize.spectrum,
                                     "Normalization Method"=spectrum.normalization.method,
                                     "User-defined Peak for Normalization"=spectrum.normalization.peak,
                                     "m/z Value of Peaks to be Labeled"=peaks.selected.masses,
                                     "Label Distance"=peaks.label.length,
                                     "Label Spacing"=peaks.label.spread,
                                     "Label Line Type"=peaks.label.line.lty,
                                     "Label Line Colour"=peaks.label.line.col,
                                     "1st Label"=peaks.first.label,
                                     "2nd Label"=peaks.second.label,
                                     "Peak Labels Enabled "=peaks.labels.on,
                                     "Label Position"=peaks.label.position,
                                     "m/z Tolerance"=peaks.peak.tolerance,
                                     "Label Line Width"=peaks.label.line.width,
                                     "Label Font Size"=peaks.fontsize,
                                     "Peak Conflict: Use Max Peak"=peaks.if.peak.conflict.use.max,
                                     "Round m/z value to this many digits"=peaks.mz.label.sigfigs,
                                     "Round intensity value to this many digits"=peaks.int.label.sigfigs,
                                     "Round S/N value to this many digits"=peaks.sn.label.sigfigs)
                    
                } else {
                    user.input<<-list("Spectrum File"=spectrum.filepath,
                                     "Column Separator in Spectrum File"=spectrum.separator,
                                     "Decimal Separator"=input$DecimalSeparator,
                                     "First Data Row in the Spectrum File"=spectrum.first.data.row,
                                     #"fig.name"=fig.name,
                                     "Figure Height in cm"=fig.height,
                                     "Figure Width in cm"=fig.width,
                                     "Figure Resolution"=fig.res,
                                     "Bottom Figure Margin"=fig.margin[1],
                                     "Left Figure Margin"=fig.margin[2],
                                     "Top Figure Margin"=fig.margin[3],
                                     "Right Figure Margin"=fig.margin[4],
                                     "X-axis Label"=spectrum.xaxis.label,
                                     "Highlight X-axis Label"=spectrum.xaxis.label.highlight,
                                     "Y-axis Label"=spectrum.yaxis.label,
                                     "Highlight y-axis Label"=spectrum.yaxis.label.highlight,
                                     "Spectrum Title"=spectrum.main.label,
                                     "Highlight Spectrum Title"=spectrum.main.label.highlight,
                                     "Spectrum Colour"=spectrum.mass.spectrum.color,
                                     "Shape of the Border Around the Spectrum"=spectrum.Border,
                                     "Spectrum Full Range"=spectrum.full.range,
                                     "X-axis Range Upper Limit"=spectrum.upper.range.limit.xaxis,
                                     "X-axis Range Lower Limit"=spectrum.lower.range.limit.xaxis,
                                     "Y-axis Range Upper Limit"=spectrum.upper.range.limit.yaxis,
                                     "Y-axis Range Lower Limit"=spectrum.lower.range.limit.yaxis,
                                     "Font Type"=spectrum.fonttype,
                                     "Axis Label Font Size"=spectrum.axis.fontsize,
                                     "Title Font Size"=spectrum.title.fontsize,
                                     "Axis Tick Font Size"=spectrum.axis.ticks.size,
                                     "Spectrum Line Width"=spectrum.mass.spectrum.line.width,
                                     "Custom Axes"=spectrum.custom.axes,
                                     "Position of X-axis Tick Values:"=spectrum.custom.xaxis.pdj,
                                     "Position of Y-axis Tick Values:"=spectrum.custom.yaxis.pdj,
                                     "Position of X-axis and Y-axis Labels"=spectrum.custom.axis.ann.line,
                                     "Position of the Spectrum Title"=spectrum.custom.axis.ann.title.line,
                                     "Show x-Axis"=spectrum.show.x.axis,
                                     "Show y-axis"=spectrum.show.y.axis,
                                     "X-axis Tick Interval"=spectrum.xaxis.interval,
                                     "Y-axis Tick Interval"=spectrum.yaxis.interval,
                                     "Normalize Spectrum"=spectrum.normalize.spectrum,
                                     "Normalization Method"=spectrum.normalization.method,
                                     "User-defined Peak for Normalization"=spectrum.normalization.peak)
                    
                }

                updateMaterialSwitch(session,
                                     "saveSettings",
                                     value = FALSE)
                
                output$downloadButtonSettings<- renderUI({
                    downloadButton('downloadDataSettings', 'Download Settings')
                })
            })
        
        #download handler save figure single spectrum as png
        output$downloadFigureSingleSpectrumPng <- downloadHandler(
          filename = function() {
            paste(as.character(record.record.single.spectrum.vars[[1]]))
          },
          content = function(con) {
            try(png(filename = as.character(record.record.single.spectrum.vars[[1]]),
                    height = as.numeric(record.record.single.spectrum.vars[[2]]),
                    width = as.numeric(record.record.single.spectrum.vars[[3]]),
                    res=as.numeric(record.record.single.spectrum.vars[[4]]),
                    pointsize = 4,
                    units = "cm",
                    bg=as.character(record.record.single.spectrum.vars[[5]])))
            
            try(replayPlot(record.single.spectrum))
            
            dev.off()

            try(file.copy(from=as.character(record.record.single.spectrum.vars[[1]]),
                          to=con))
            
            try(file.remove(as.character(record.record.single.spectrum.vars[[1]])))
            
          }
        )
        
        #download handler save figure single spectrum as pdf
        output$downloadFigureSingleSpectrumPdf <- downloadHandler(
          filename = function() {
            paste(paste0(fig.name,".pdf"))
          },
          content = function(con) {
            try(pdf(file = as.character(record.record.single.spectrum.vars[[1]]),
                    height = as.numeric(record.record.single.spectrum.vars[[2]]),
                    width = as.numeric(record.record.single.spectrum.vars[[3]]),
                    pointsize = 4,
                    bg=as.character(record.record.single.spectrum.vars[[5]])))
            
            try(replayPlot(record.single.spectrum))
            
            dev.off()
            
            try(file.copy(from=as.character(record.record.single.spectrum.vars[[1]]),
                          to=con))
            
            try(file.remove(as.character(record.record.single.spectrum.vars[[1]])))
            
          }
        )
        
        #download handler save settings
        output$downloadDataSettings <- downloadHandler(
            filename = function() {
                paste0("settings",".csv")
            },
            content = function(con) {
                write.csv((unlist(user.input)), con)
                
                output$downloadButtonSettings<- renderUI({})
                
            }
        )

        
        file.remove(inFile1$name)
        if(!is.null(inFile2)) {
            file.remove(inFile2$name)
        }
        
        list(src = fig.name.final)

    }, deleteFile = TRUE)
    
    output$overlaidSpectrum <- renderImage({
      
        #Variables for extra labels in plot
        extra.labels.on<-T #Should additional text be displayed in plot, as TRUE/FALSE
        extra.labels.text<-c("#1","hello") #Text displayed anywhere in the plot, vector of strings
        extra.labels.xpos<-c(1320,1450) #x-coordinates of labels, vector of numeric
        extra.labels.ypos<-c(1.65,1.25) #y-coordinates of labels, vector of numeric
        extra.labels.fontsize<-c(3,2) #fontsize of labels, vector of numeric
        extra.labels.col<-c("black","red") #color of labels, vector of color (text or hex)

        #Overlaid spectra----
        fig.name.final<-paste(fig.name,".jpg") #adds file extension to file name
        
        
        
        
        #Files
        req(input$overlaidSpectrumFile1)
        req(input$overlaidSpectrumFile2)
        
        overlaidSpectrumFile1 <- input$overlaidSpectrumFile1
        overlaidSpectrumFile2 <- input$overlaidSpectrumFile2
        
        overlaidMassListFile1<-input$overlaidMassListFile1
        overlaidMassListFile2<-input$overlaidMassListFile2
        
        file.copy(overlaidSpectrumFile1$datapath, file.path(".", overlaidSpectrumFile1$name))
        file.copy(overlaidSpectrumFile2$datapath, file.path(".", overlaidSpectrumFile2$name))
        
        file.copy(overlaidMassListFile1$datapath, file.path(".", overlaidMassListFile1$name))
        file.copy(overlaidMassListFile2$datapath, file.path(".", overlaidMassListFile2$name))
        
        spectrum.first.spectrum.filepath<-overlaidSpectrumFile1$name
        spectrum.second.spectrum.filepath<-overlaidSpectrumFile2$name
        
        peaks.mass.list.filepath.first.spectrum<-overlaidMassListFile1$name
        peaks.sheet.name.first.spectrum<-input$overlaidPeaksSheetName1
        
        peaks.mass.list.filepath.second.spectrum<-overlaidMassListFile2$name
        peaks.sheet.name.second.spectrum<-input$overlaidPeaksSheetName2
        
        #overlaid spectrum variables
        
        #separator in the mass spectrum csv file, character
        if (input$overlaidSpectrumSeparator == "") {
            spectrum.separator<-" "
        }
        else {
            spectrum.separator<-input$overlaidSpectrumSeparator
        }
        
        #Whether or not the mass spectrum file has column headers, boolean
        spectrum.headerTF<-F
        
        #Label below x-axis, character
        spectrum.xaxis.label<-input$overlaidSpectrumXaxisLabel
        
        #Label next to y-axis, character
        spectrum.yaxis.label<-input$overlaidSpectrumYaxisLabel
        
        #Distance of the axis label to the axis (if custom axes is true), numeric
        spectrum.custom.axis.ann.line<-input$overlaidSpectrumCustomAxisAnnLine
        
        #Label above mass spectrum, character
        spectrum.main.label<-input$overlaidSpectrumMainLabel
        
        #Distance of the main label from the mass spectrum, numeric
        spectrum.custom.axis.ann.title.line<-input$overlaidSpectrumCustomAxisAnnTitleLine
        
        #Color of the 1st mass spectrum, character or color hex code
        spectrum.mass.spectrum.color.first.spectrum<-input$overlaidSpectrumColour1
        
        #Color of the 1st mass spectrum, character or color hex code
        spectrum.mass.spectrum.color.second.spectrum<-input$overlaidSpectrumColour2
        
        #Line width of the first mass spectrum, numeric
        spectrum.mass.spectrum.line.width.first.spectrum<-input$overlaidSpectrumLineWidth1
        
        #Line width of the second mass spectrum, numeric
        spectrum.mass.spectrum.line.width.second.spectrum<-input$overlaidSpectrumLineWidth2
        
        #Line type of first mass spectrum, numeric
        spectrum.line.type.first.spectrum<-as.numeric(input$overlaidSpectrumLineType1)
        
        #Line type of second mass spectrum, numeric
        spectrum.line.type.second.spectrum<-as.numeric(input$overlaidSpectrumLineType2)
        
        #Whether the entire spectrum, or only a section of it should be displayed, boolean
        spectrum.full.range<-input$overlaidSpectrumFullRange
        
        #Upper end of the x-axis, numeric
        spectrum.upper.range.limit.xaxis<-input$overlaidSpectrumRangeXAxis[2]
        
        #Lower end of the x-axis, numeric
        spectrum.lower.range.limit.xaxis<-input$overlaidSpectrumRangeXAxis[1]
        
        #Upper end of the y-axis, numeric 
        spectrum.upper.range.limit.yaxis<-input$overlaidSpectrumRangeYAxis[2]
        
        #Lower end of the y-axis, numeric  
        spectrum.lower.range.limit.yaxis<-input$overlaidSpectrumRangeYAxis[1]
        
        #Whether or not the axis ticks are at custom points, boolean
        spectrum.custom.axes<-input$overlaidSpectrumCustomAxes
        
        #Interval of x-axis ticks (if custom axes is true), numeric
        spectrum.xaxis.interval<-as.numeric(input$overlaidSpectrumXAxisInterval)
        
        #Interval of y-axis ticks (if custom axes is true), numeric
        spectrum.yaxis.interval<-as.numeric(input$overlaidSpectrumYAxisInterval)
        
        #Distance of the x-axis tick mark labels from the x-axis ticks (if custom axes is true), numeric
        spectrum.custom.xaxis.pdj<-input$overlaidSpectrumCustomXAxisPdj
        
        #Distance of the y-axis tick mark labels from the y-axis ticks (if custom axes is true), numeric
        spectrum.custom.yaxis.pdj<-(input$overlaidSpectrumCustomYAxisPdj)

        #Font type
        spectrum.fonttype<-input$overlaidSpectrumFontType
      
        #Font size of the axis labels, numeric
        spectrum.axis.fontsize<-input$overlaidSpectrumAxisFontSize
        
        #Font size of the main label
        spectrum.title.fontsize<-input$overlaidSpectrumTitleFontSize
        
        #Font size of the axis ticks, numeric
        spectrum.axis.ticks.size<-input$overlaidSpectrumAxisTickFontSize
        
        #Name of jpg file
        if(input$overlaidSpectrumFilename==""){
            fig.name<-"spectrum"
        } else{
            fig.name<-input$overlaidSpectrumFilename
        }
        
        fig.name.final<-paste0(fig.name,".png") #adds file extension to file name
        
        #Whether background of png should be transparent
        if(input$OverlaidSpectrumPlotPNGTransparency==T){
          spectrum.transparency<-"transparent"
        } else {
          spectrum.transparency<-"white"
        }
        
        #Height in cm of file
        if(input$overlaidSpectrumFileHeight==""){
            fig.height<-6
        } else{
            fig.height<-as.numeric(input$overlaidSpectrumFileHeight)
        }
        
        #Width in cm of file
        if(input$overlaidSpectrumFileWidth==""){
            fig.width<-7
        } else{
            fig.width<-as.numeric(input$overlaidSpectrumFileWidth)    
        }
        
        #File resolution
        if(input$overlaidSpectrumFileResolution==""){
            fig.res<-800
        } else{
            fig.res<-as.numeric(input$overlaidSpectrumFileResolution)    
        }

        #Figure margins, numeric
        fig.margin<-c(as.numeric(input$overlaidSpectrumMarginBottom),
                      as.numeric(input$overlaidSpectrumMarginLeft),
                      as.numeric(input$overlaidSpectrumMarginTop),
                      as.numeric(input$overlaidSpectrumMarginRight))

        #Whether or not the spectrum should be normalized, as TRUE/FALSE
        #Also sets the y-axis range to 0 to 1
        if (rv$prevOverlaidNormalizeSpectrum == FALSE && input$overlaidSpectrumNormalizeSpectrum == TRUE) {
          # Set y range from 0 to 1
          updateNumericRangeInput(session = session, inputId = "overlaidSpectrumRangeYAxis", value = c(0, 1))
          rv$prevOverlaidNormalizeSpectrum<-TRUE
        }
        else if (rv$prevOverlaidNormalizeSpectrum == TRUE && input$overlaidSpectrumNormalizeSpectrum == FALSE) {
          rv$prevOverlaidNormalizeSpectrum<-FALSE
        }

        spectrum.normalize.spectrum<-input$overlaidSpectrumNormalizeSpectrum
        
        #Which method to use for normalization (values of 1-3): 1= by max peak intensity in entire spectrum, 2= by max peak intensity in selected mass range, 3= by peak intensity of a selected peak
        spectrum.normalization.method<-input$overlaidSpectrumNormalizationMethod
        
        #if spectrum.normalization.method=3, then this m.z value will be used or normalization of 1st spectrum
        spectrum.normalization.peak.first.spectrum<-as.numeric(input$overlaidSpectrumNormalizationPeak1)
        
        #if spectrum.normalization.method=3, then this m.z value will be used or normalization of 2nd spectrum
        spectrum.normalization.peak.second.spectrum<-as.numeric(input$overlaidSpectrumNormalizationPeak2)
        
        
        # Legend variables
        
        #Whether a legend for both spectra should be shown. 1= yes, 0=no
        spectrum.legend.yesno<-input$overlaidSpectrumLegend
        
        #Label (in legend) of first mass spectrum, character
        spectrum.label.first.spectrum<- input$overlaidSpectrumLegendLabel1
        
        #Whether the legend should have a border, boolean
        if(input$overlaidSpectrumLegendBorder==T){
          spectrum.legend.border<-"s"
        } else if(input$overlaidSpectrumLegendBorder==F){
            spectrum.legend.border<-"n"
          }
        
        #Label (in legend) of 2nd mass spectrum, character
        spectrum.label.second.spectrum<- input$overlaidSpectrumLegendLabel2
        
        #Position of legend in plot. Same as normal R legend position commands (i.e. "topright","top","topleft","bottomleft","bottom","bottomright")
        spectrum.legend.position<-input$overlaidSpectrumLegendPosition
        
        #Size of legend, numeric
        spectrum.legend.size<-as.numeric(input$overlaidSpectrumLegendSize)
        
        #lwd of lines in legend
        spectrum.legend.lwd<-as.numeric(input$overlaidSpectrumLegendLineWidth)
        
        
        # Spectrum 1 peak labelling variables
          
          
        #m/z value of the peaks which should be labeled, numeric vector
        if (input$overlaidPeaks1SelectedMasses == "") {
            peaks.selected.masses.first.spectrum<-c(0)
        }
        else {
            peaks.selected.masses.first.spectrum<-c(as.numeric(unlist(strsplit(input$overlaidPeaks1SelectedMasses,","))))
        }
        
        #Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2), numeric
        peaks.peak.tolerance.first.spectrum<-as.numeric(input$overlaidPeak1Tolerance)
        
        #If two peaks are within the tolerance window for peak picking, the higher one is selected, boolean
        peaks.if.peak.conflict.use.max.first.spectrum<-input$overlaidPeak1ConflictUseMax
        
        #Where the peak labels should be displayed. "r" or "l" displays them to the right or left of the peak maximum. "R" or "L" displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)
        peaks.label.position.first.spectrum<-c(unlist(strsplit(input$overlaidPeaks1LabelPosition,",")))
        
        #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        if (input$overlaidPeaks1FirstLabel == "") {
            peaks.first.label.first.spectrum<-""
        }
        else {
            peaks.first.label.first.spectrum<-c(unlist(strsplit(input$overlaidPeaks1FirstLabel,",")))
        }
        
        
        #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        if (input$overlaidPeaks1SecondLabel == "") {
            peaks.second.label.first.spectrum<-""
        }
        else {
            peaks.second.label.first.spectrum<-c(unlist(strsplit(input$overlaidPeaks1SecondLabel,",")))
        }
        
        #Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio), 1= label is on, 0= label is off
        l1<-0
        l2<-0
        l3<-0
        l4<-0
        l5<-0
        
        for (i in seq_len(length(input$overlaidPeaks1LabelsOn))) {
            if (input$overlaidPeaks1LabelsOn[i] == "1st Label") {l1<-1}
            if (input$overlaidPeaks1LabelsOn[i] == "2nd label") {l2<-1}
            if (input$overlaidPeaks1LabelsOn[i] == "m/z Ratio") {l3<-1}
            if (input$overlaidPeaks1LabelsOn[i] == "Intensity") {l4<-1}
            if (input$overlaidPeaks1LabelsOn[i] == "S/N Ratio") {l5<-1}
        }
        
        peaks.labels.on.first.spectrum<-c(l1,l2,l3,l4,l5)
        
        #Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)
        if (input$overlaidPeaksLabelLength1 == "") {
          peaks.label.length.first.spectrum<-c(0)
        }
        else {
          peaks.label.length.first.spectrum<-c(as.numeric(unlist(strsplit(input$overlaidPeaksLabelLength1,","))))
        }
        
        #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
        peaks.label.spread.first.spectrum<-as.numeric(input$overlaidPeaksLabelSpread1)
        
        #Line type of the line connecting the peak to the peak labels, numeric
        peaks.label.line.lty.first.spectrum<-as.numeric(input$overlaidPeaksLabelLineType1)
        
        #Line type of the line connecting the peak to the peak labels, character or color hex code
        if (input$overlaidPeaksLabelLineColour1 == "") {
          peaks.label.line.col.first.spectrum<-""
        }
        else {
          peaks.label.line.col.first.spectrum<-c(unlist(strsplit(input$overlaidPeaksLabelLineColour1,",")))
        }
        
        #line width of the line connecting the peak to the peak labels
        peaks.label.line.width.first.spectrum<-input$overlaidPeakLineWidth1
        
        #Fontsize of the peak labels, numeric
        peaks.fontsize.first.spectrum<-as.numeric(input$overlaidPeaksFontSize1)
        
        
        # Spectrum 2 peak labelling variables
        
        #m/z value of the peaks which should be labeled, numeric vector
        if (input$overlaidPeaks2SelectedMasses == "") {
            peaks.selected.masses.second.spectrum<-c(0)
        }
        else {
            peaks.selected.masses.second.spectrum<-c(as.numeric(unlist(strsplit(input$overlaidPeaks2SelectedMasses,","))))
        }
        
        #Window in dalton from the peaks selected in 'peaks.selected.masses' are picked (e.g., 1496+-2), numeric
        peaks.peak.tolerance.second.spectrum<-as.numeric(input$overlaidPeak2Tolerance)
        
        #If two peaks are within the tolerance window for peak picking, the higher one is selected, boolean
        peaks.if.peak.conflict.use.max.second.spectrum<-input$overlaidPeak2ConflictUseMax
        
        #Where the peak labels should be displayed. "r" or "l" displays them to the right or left of the peak maximum. "R" or "L" displays them to the right or left of the peak at the centre of the y-axis. Numeric values, representing y-axis position, are also possible, for example 20000 or -20000 (positive value= to the right of peak, negative value= to the left of the peak)
        peaks.label.position.second.spectrum<-c(unlist(strsplit(input$overlaidPeaks2LabelPosition,",")))
        
        #First label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        if (input$overlaidPeaks2FirstLabel == "") {
            peaks.first.label.second.spectrum<-""
        }
        else {
            peaks.first.label.second.spectrum<-c(unlist(strsplit(input$overlaidPeaks2FirstLabel,",")))
        }
        
        
        #Second label of the peaks, character vector of equal length of 'peaks.selected.masses' vector
        if (input$overlaidPeaks2SecondLabel == "") {
            peaks.second.label.second.spectrum<-""
        }
        else {
            peaks.second.label.second.spectrum<-c(unlist(strsplit(input$overlaidPeaks2SecondLabel,",")))
        }
        
        #Which peak parameters should be displayed. c(1st label, 2nd label, m/z ratio, intensity, S/N ratio), 1= label is on, 0= label is off
        l1<-0
        l2<-0
        l3<-0
        l4<-0
        l5<-0
        
        for (i in seq_len(length(input$overlaidPeaks2LabelsOn))) {
            if (input$overlaidPeaks2LabelsOn[i] == "1st Label") {l1<-1}
            if (input$overlaidPeaks2LabelsOn[i] == "2nd label") {l2<-1}
            if (input$overlaidPeaks2LabelsOn[i] == "m/z Ratio") {l3<-1}
            if (input$overlaidPeaks2LabelsOn[i] == "Intensity") {l4<-1}
            if (input$overlaidPeaks2LabelsOn[i] == "S/N Ratio") {l5<-1}
        }
        
        peaks.labels.on.second.spectrum<-c(l1,l2,l3,l4,l5)
        
        #Distance of the peak labels from the peak, numeric vector (equal length of 'peaks.selected.masses' vector)
        if (input$overlaidPeaksLabelLength2 == "") {
          peaks.label.length.second.spectrum<-c(0)
        }
        else {
          peaks.label.length.second.spectrum<-c(as.numeric(unlist(strsplit(input$overlaidPeaksLabelLength2,","))))
        }
        
        #Distance how far the labels of one peak (Label1,Label2,S/N/Intensity,Area) are spread apart, numeric
        peaks.label.spread.second.spectrum<-as.numeric(input$overlaidPeaksLabelSpread2)
        
        #Line type of the line connecting the peak to the peak labels, numeric
        peaks.label.line.lty.second.spectrum<-as.numeric(input$overlaidPeaksLabelLineType2)
        
        #Line type of the line connecting the peak to the peak labels, character or color hex code
        if (input$overlaidPeaksLabelLineColour2 == "") {
          peaks.label.line.col.second.spectrum<-""
        }
        else {
          peaks.label.line.col.second.spectrum<-c(unlist(strsplit(input$overlaidPeaksLabelLineColour2,",")))
        }
        
        #Line width of the line connecting the peak to the peak labels
        peaks.label.line.width.second.spectrum<-input$overlaidPeakLineWidth2
        
        #Fontsize of the peak labels, numeric
        peaks.fontsize.second.spectrum<-as.numeric(input$overlaidPeaksFontSize2)
        
        
        # Rounding variables
        
        #Number of signifcant digits the m/z value is rounded to, numeric
        peaks.mz.label.sigfigs<-as.numeric(input$overlaidPeaksMzLabelSigFigs)
        
        #Number of signifcant digits the intensity value is rounded to, numeric
        peaks.int.label.sigfigs<-as.numeric(input$overlaidPeaksIntLabelSigFigs)
        
        #Number of signifcant digits the S/N value is rounded to, numeric
        peaks.sn.label.sigfigs<-as.numeric(input$overlaidPeaksSnLabelSigFigs)
        
        #generate png
        try(png(filename = fig.name.final,
                height = fig.height,
                width = fig.width,
                res=fig.res,
                pointsize = 4,
                units = "cm",
                bg=spectrum.transparency))
        
        try(par(mar=fig.margin+0.1,
                family=spectrum.fonttype))
        

        spectrum.normalization.value<-NA

        try(if(spectrum.normalize.spectrum==T){
                masslist.norm.first.spectrum<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath.first.spectrum,
                                                            Sheet.name = peaks.sheet.name.first.spectrum,
                                                            FullListYN = T,
                                                            SelectedMasses = peaks.selected.masses.first.spectrum,
                                                            tolerance = peaks.peak.tolerance.first.spectrum,
                                                            if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)

                masslist.norm.second.spectrum<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath.second.spectrum,
                                                            Sheet.name = peaks.sheet.name.second.spectrum,
                                                            FullListYN = T,
                                                            SelectedMasses = peaks.selected.masses.second.spectrum,
                                                            tolerance = peaks.peak.tolerance.second.spectrum,
                                                            if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
                
                if(spectrum.normalization.method==1){
                        first.spectrum.normalization.value<-max(masslist.norm.first.spectrum$Intensity) 
                        second.spectrum.normalization.value<-max(masslist.norm.second.spectrum$Intensity)        
                        
                }
                
                if(spectrum.normalization.method==2){
                        first.spectrum.normalization.value<-max(masslist.norm.first.spectrum$Intensity[which(masslist.norm.first.spectrum$m.z<spectrum.upper.range.limit.xaxis&
                                                                                                            masslist.norm.first.spectrum$m.z>spectrum.lower.range.limit.xaxis)])        
                        
                        second.spectrum.normalization.value<-max(masslist.norm.second.spectrum$Intensity[which(masslist.norm.second.spectrum$m.z<spectrum.upper.range.limit.xaxis&
                                                                                                                    masslist.norm.second.spectrum$m.z>spectrum.lower.range.limit.xaxis)])        
                }
                
                if(spectrum.normalization.method==3){
                        masslist.norm.first.spectrum<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath.first.spectrum,
                                                                    Sheet.name = peaks.sheet.name.first.spectrum,
                                                                    FullListYN = F,
                                                                    SelectedMasses = spectrum.normalization.peak.first.spectrum,
                                                                    tolerance = peaks.peak.tolerance.first.spectrum,
                                                                    if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
                        
                        masslist.norm.second.spectrum<-read.mass.list(mass.list.filepath = peaks.mass.list.filepath.second.spectrum,
                                                                    Sheet.name = peaks.sheet.name.second.spectrum,
                                                                    FullListYN = F,
                                                                    SelectedMasses = spectrum.normalization.peak.second.spectrum,
                                                                    tolerance = peaks.peak.tolerance.second.spectrum,
                                                                    if.peak.conflict.use.max = peaks.if.peak.conflict.use.max)
                        
                        first.spectrum.normalization.value<-masslist.norm.first.spectrum$Intensity
                        second.spectrum.normalization.value<-masslist.norm.second.spectrum$Intensity
                }
                
        })

        try(dev.control(displaylist="enable"))
        
        try(spectrum<-mass.spectrum.overlaid.create(first.spectrum.rawfile.path = spectrum.first.spectrum.filepath,
                                                second.spectrum.rawfile.path = spectrum.second.spectrum.filepath,
                                                separator=spectrum.separator,
                                                decimal=input$DecimalSeparator,
                                                headerTF=spectrum.headerTF,
                                                xaxis.title=spectrum.xaxis.label,
                                                yaxis.title=spectrum.yaxis.label,
                                                spectrum.title=spectrum.main.label,
                                                full.range=spectrum.full.range,
                                                first.spectrum.upper.range.limit = spectrum.upper.range.limit.xaxis,
                                                first.spectrum.lower.range.limit = spectrum.lower.range.limit.xaxis,
                                                second.spectrum.upper.range.limit = spectrum.upper.range.limit.xaxis,
                                                second.spectrum.lower.range.limit = spectrum.lower.range.limit.xaxis,
                                                axis.fontsize=spectrum.axis.fontsize,
                                                title.fontsize=spectrum.title.fontsize,
                                                axis.ticks.fontsize=spectrum.axis.ticks.size,
                                                spectrum.y.axis.lower.limit = spectrum.lower.range.limit.yaxis,
                                                spectrum.y.axis.upper.limit = spectrum.upper.range.limit.yaxis,
                                                first.spectrum.color = spectrum.mass.spectrum.color.first.spectrum,
                                                second.spectrum.color = spectrum.mass.spectrum.color.second.spectrum,
                                                first.spectrum.line.type = spectrum.line.type.first.spectrum,
                                                second.spectrum.line.type = spectrum.line.type.second.spectrum,
                                                first.spectrum.lwd = spectrum.mass.spectrum.line.width.first.spectrum,
                                                second.spectrum.lwd = spectrum.mass.spectrum.line.width.second.spectrum,
                                                first.spectrum.label = spectrum.label.first.spectrum,
                                                second.spectrum.label = spectrum.label.second.spectrum,
                                                legend.yesno = spectrum.legend.yesno,
                                                legend.position = spectrum.legend.position,
                                                legend.size = spectrum.legend.size,
                                                legend.lwd = spectrum.legend.lwd,
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
                                                first.spectrum.normalization.value = first.spectrum.normalization.value,
                                                second.spectrum.normalization.value = second.spectrum.normalization.value,
                                                normalize.spectrum.show.as.percent = input$overlaidSpectrumNormalize.spectrum.show.as.percent,
                                                mirror.spectrum = input$overlaidMirrorSpectrum,
                                                xaxis.title.highlight = input$overlaidSpectrumXaxisLabelHighlight,
                                                yaxis.title.highlight = input$overlaidSpectrumYaxisLabelHighlight,
                                                spectrum.title.highlight = input$overlaidSpectrumMainLabelHighlight,
                                                border = input$overlaidSpectrumBorder,
                                                show.x.axis = input$overlaidSpectrumShowXAxis,
                                                show.y.axis = input$overlaidSpectrumShowYAxis,
                                                legend.bty = spectrum.legend.border,
                                                axis.line.width = input$overlaidSpectrumAxesLineWidth))

        if (!is.null(peaks.mass.list.filepath.first.spectrum) || !is.null(peaks.sheet.name.first.spectrum)) {
            try(spectrum.first.label<-mass.spectrum.label.peaks(mass.list.filepath = peaks.mass.list.filepath.first.spectrum,
                                                    Sheet.name = peaks.sheet.name.first.spectrum,
                                                    mass.spectrum = spectrum$`First Spectrum`,
                                                    PlotYN = T,
                                                    FullListYN = F,
                                                    SelectedMasses = peaks.selected.masses.first.spectrum,
                                                    tolerance = peaks.peak.tolerance.first.spectrum,
                                                    label.line.width = peaks.label.line.width.first.spectrum,
                                                    label.length =peaks.label.length.first.spectrum,
                                                    label.spread = peaks.label.spread.first.spectrum,
                                                    label.line.lty = peaks.label.line.lty.first.spectrum,
                                                    label.line.col = peaks.label.line.col.first.spectrum,
                                                    label.title = peaks.first.label.first.spectrum,
                                                    label.second.title = peaks.second.label.first.spectrum,
                                                    labels.on = peaks.labels.on.first.spectrum,
                                                    label.position = peaks.label.position.first.spectrum,
                                                    fontsize = peaks.fontsize.first.spectrum,
                                                    if.peak.conflict.use.max = peaks.if.peak.conflict.use.max.first.spectrum,
                                                    normalize.spectrum = spectrum.normalize.spectrum,
                                                    normalization.value = first.spectrum.normalization.value,
                                                    normalize.spectrum.show.as.percent = input$overlaidSpectrumNormalize.spectrum.show.as.percent,
                                                    round.or.sigfig=input$peaksOverlaidSpectraMzLabelRounding,
                                                    mz.label.sigfigs=peaks.mz.label.sigfigs,
                                                    int.label.sigfigs=peaks.int.label.sigfigs,
                                                    sn.label.sigfigs=peaks.sn.label.sigfigs,
                                                    mirror=F,
                                                    label1.highlight=input$overlaidPeaks1Label1Highlight,
                                                    label2.highlight=input$overlaidPeaks1Label2Highlight))
        }

        if (!is.null(peaks.mass.list.filepath.second.spectrum) || !is.null(peaks.sheet.name.second.spectrum)) {
            try(spectrum.second.label<-mass.spectrum.label.peaks(mass.list.filepath = peaks.mass.list.filepath.second.spectrum,
                                                            Sheet.name = peaks.sheet.name.second.spectrum,
                                                            mass.spectrum = spectrum$`Second Spectrum`,
                                                            PlotYN = T,
                                                            FullListYN = F,
                                                            SelectedMasses = peaks.selected.masses.second.spectrum,
                                                            tolerance = peaks.peak.tolerance.second.spectrum,
                                                            label.line.width = peaks.label.line.width.second.spectrum,
                                                            label.length =peaks.label.length.second.spectrum,
                                                            label.spread = peaks.label.spread.second.spectrum,
                                                            label.line.lty = peaks.label.line.lty.second.spectrum,
                                                            label.line.col = peaks.label.line.col.second.spectrum,
                                                            label.title = peaks.first.label.second.spectrum,
                                                            label.second.title = peaks.second.label.second.spectrum,
                                                            labels.on = peaks.labels.on.second.spectrum,
                                                            label.position = peaks.label.position.second.spectrum,
                                                            fontsize = peaks.fontsize.second.spectrum,
                                                            if.peak.conflict.use.max = peaks.if.peak.conflict.use.max.second.spectrum,
                                                            normalize.spectrum = spectrum.normalize.spectrum,
                                                            normalization.value = second.spectrum.normalization.value,
                                                            normalize.spectrum.show.as.percent = input$overlaidSpectrumNormalize.spectrum.show.as.percent,
                                                            round.or.sigfig=input$peaksOverlaidSpectraMzLabelRounding,
                                                            mz.label.sigfigs=peaks.mz.label.sigfigs,
                                                            int.label.sigfigs=peaks.int.label.sigfigs,
                                                            sn.label.sigfigs=peaks.sn.label.sigfigs,
                                                            mirror=input$overlaidMirrorSpectrum,
                                                            label1.highlight=input$overlaidPeaks2Label1Highlight,
                                                            label2.highlight=input$overlaidPeaks2Label2Highlight))
        }
        
        try(record.overlaid.spectra.vars<<-data.frame("filename"=fig.name.final,
                                                            "height"=fig.height,
                                                            "width"=fig.width,
                                                            "res"=fig.res,
                                                            "bg"=spectrum.transparency))
        
        
        try(record.overlaid.spectra<<-recordPlot())
        try(dev.control(displaylist="inhibit"))
        
        
        dev.off()
        
        file.remove(overlaidSpectrumFile1$name)
        file.remove(overlaidSpectrumFile2$name)
        
        if (!is.null(peaks.mass.list.filepath.first.spectrum) && !is.null(peaks.sheet.name.first.spectrum)) {
            file.remove(overlaidMassListFile1$name)
        }
        if (!is.null(peaks.mass.list.filepath.second.spectrum) && !is.null(peaks.sheet.name.second.spectrum)) {
            file.remove(overlaidMassListFile2$name)
        }
        
        #download handler save figure single spectrum as png
        output$downloadFigureOverlaidSpectraPng <- downloadHandler(
          filename = function() {
            paste(as.character(record.overlaid.spectra.vars[[1]]))
          },
          content = function(con) {
            try(png(filename = as.character(record.overlaid.spectra.vars[[1]]),
                    height = as.numeric(record.overlaid.spectra.vars[[2]]),
                    width = as.numeric(record.overlaid.spectra.vars[[3]]),
                    res=as.numeric(record.overlaid.spectra.vars[[4]]),
                    pointsize = 4,
                    units = "cm",
                    bg=as.character(record.overlaid.spectra.vars[[5]])))
            
            try(replayPlot(record.overlaid.spectra))
            
            dev.off()
            
            try(file.copy(from=as.character(record.overlaid.spectra.vars[[1]]),
                          to=con))
            
            try(file.remove(as.character(record.overlaid.spectra.vars[[1]])))
            
          }
        )
        
        #download handler save figure single spectrum as pdf
        output$downloadFigureOverlaidSpectraPdf <- downloadHandler(
          filename = function() {
            paste(paste0(fig.name,".pdf"))
          },
          content = function(con) {
            try(pdf(file = as.character(record.overlaid.spectra.vars[[1]]),
                    height = as.numeric(record.overlaid.spectra.vars[[2]]),
                    width = as.numeric(record.overlaid.spectra.vars[[3]]),
                    pointsize = 4,
                    bg=as.character(record.overlaid.spectra.vars[[5]])))
            
            try(replayPlot(record.overlaid.spectra))
            
            dev.off()
            
            try(file.copy(from=as.character(record.overlaid.spectra.vars[[1]]),
                          to=con))
            
            try(file.remove(as.character(record.overlaid.spectra.vars[[1]])))
            
          }
        )
        
        list(src = fig.name.final)
        
    }, deleteFile = TRUE)

})
