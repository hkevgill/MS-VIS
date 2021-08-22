mass.spectra.mirror.create<-function(first.spectrum.rawfile.path, #Filepath of the first of two mass spectra to be overlaid, character
                                     separator=" ", #Separating character between m/z and intensity in mass spectrum text file, character
                                     second.spectrum.rawfile.path, #Filepath of the second of two mass spectra to be overlaid, character 
                                     headerTF=FALSE, #TRUE/FALSE if mass spectrum text file has a header, boolean
                                     xaxis.title="m/z", #Title of spectrum x-axis, character
                                     yaxis.title="Intensity in a.u.", #Title of spectrum y-axis, charcter
                                     spectrum.title="Overlaid Mass Spectra", #Title of entire mass spectrum, character
                                     first.spectrum.upper.range.limit=3500, #Upper mass range limit for first spectrum, only values below are plotted, numeric
                                     first.spectrum.lower.range.limit=1000, #Lower  mass range limit for first spectrum, only values above are plotted, numeric
                                     custom.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                                     custom.axis.pdj=0, #Distance adjuster for custom x-axis
                                     custom.y.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                                     custom.y.axis.pdj=0, #Distance adjuster for custom y-axis
                                     custom.axis.ann=FALSE, #TRUE/FALSE if distance of annotations should be off, necessary for custom axis distances
                                     custom.axis.ann.line=0, #Distance of custom axis labels to axis
                                     custom.axis.ann.title.line, #Distance of main title if ann is F
                                     xaxis.interval=100, #ONLY APPLIES IF custom.axis=TRUE, sets the desired x-axis interval, numeric
                                     yaxis.interval=1000, #ONLY APPLIES IF custom.y.axis=TRUE, sets the desired x-axis interval, numeric
                                     spectrum.y.axis.lower.limit=NULL, #Lower limit of y-axis of plot, numeric 
                                     spectrum.y.axis.upper.limit=NULL, #Upper limit of y-axis of plot, numeric
                                     axis.fontsize=1, #Font size (cex) of axis labels, numeric
                                     title.fontsize=1, #Font size (cex) of plot main title, numeric
                                     axis.ticks.fontsize=2, #Font size of axis ticks, numeric
                                     first.spectrum.color="black", #Color of first mass trace, character
                                     second.spectrum.color="red", #Color of second mass trace, character
                                     second.spectrum.upper.range.limit=3500, #Upper mass range limit for second spectrum, only values below are plotted, numeric
                                     second.spectrum.lower.range.limit=1000, #Lower mass range limit for second spectrum, only values below are plotted, numeric
                                     first.spectrum.line.type=2, #Line type of first plotted mass trace, numeric
                                     second.spectrum.line.type=3, #Line type of second plotted mass trace, numeric
                                     first.spectrum.lwd=1, #Line width of first mass trace, numeric
                                     second.spectrum.lwd=1, #Line width of second mass trace, numeric
                                     first.spectrum.label="First Spectrum", #Legend label of first mass trace, character
                                     second.spectrum.label="Second Spectrum", #Legen label of second mass trace, character
                                     legend.yesno=1, #0/1=Y/N, display legend yes/no, numeric
                                     legend.position="topright", #Position of legend, only applies if legend.yesno=1, character
                                     legend.size=1, #Size (cex) of legend, only applies if legend.yesno=1, numeric
                                     legend.lwd=1, #Linewidth of lines in legend
                                     first.spectrum.normalization.value=NULL, #If normalize.spectrum is true, all intensity values of first spectrum will be divided by this value
                                     second.spectrum.normalization.value=NULL, #If normalize.spectrum is true, all intensity values of first spectrum will be divided by this value
                                     normalize.spectrum=F #Normalize Y/N
                                     ){
  
  
  #get mass spectrum from file
  print(first.spectrum.rawfile.path)
  full.first.mass.spectrum <- read.csv(first.spectrum.rawfile.path,sep=separator, header=headerTF)
  names(full.first.mass.spectrum)<-c("m/z","Intensity")
  
  print(second.spectrum.rawfile.path)
  full.second.mass.spectrum <- read.csv(second.spectrum.rawfile.path,sep=separator, header=headerTF)
  names(full.second.mass.spectrum)<-c("m/z","Intensity")
  
  if(normalize.spectrum==TRUE){
    full.first.mass.spectrum[[2]]<-full.first.mass.spectrum[[2]]/first.spectrum.normalization.value
    full.second.mass.spectrum[[2]]<-full.second.mass.spectrum[[2]]/second.spectrum.normalization.value
  }
  
  
  #Pull specified mass ranges 
  first.spectrum.mass.range <- c(first.spectrum.lower.range.limit,first.spectrum.upper.range.limit)
  second.spectrum.mass.range <- c(second.spectrum.lower.range.limit,second.spectrum.upper.range.limit)
  
  first.mass.spectrum<-subset(full.first.mass.spectrum,full.first.mass.spectrum$`m/z`<first.spectrum.mass.range[2] & full.first.mass.spectrum$`m/z`>first.spectrum.mass.range[1])
  second.mass.spectrum<-subset(full.second.mass.spectrum,full.second.mass.spectrum$`m/z`<second.spectrum.mass.range[2] & full.second.mass.spectrum$`m/z`>second.spectrum.mass.range[1])
  
  #Check if y-axis limits have been set  
  if(is.null(spectrum.y.axis.lower.limit)==TRUE || custom.y.axis==F){
    spectrum.y.axis.lower.limit<-min(first.mass.spectrum[[2]])
  }
  
  if(is.null(spectrum.y.axis.upper.limit)==TRUE || custom.y.axis==F){
    spectrum.y.axis.upper.limit<-max(first.mass.spectrum[[2]])
  }
  
  
  yaxis.yesno<-"n"
  xaxis.yesno<-"n"
  ann.yesno<-F
  
  if(custom.y.axis==F){
    yaxis.interval<-spectrum.y.axis.upper.limit/4
    custom.y.axis.pdj<-(-0.25)
    axis.ticks.fontsize<-2
  }

  if(custom.axis==F){
    xaxis.interval<-(first.spectrum.upper.range.limit-first.spectrum.lower.range.limit)/5
    custom.axis.pdj<-0.75
  }
  
  if(custom.axis.ann==F){
    custom.axis.ann.line<-1
    axis.fontsize<-1
    custom.axis.ann.title.line<-1
    custom.axis.ann.line<-1
  } 
  
  # if(custom.y.axis==TRUE){
  #   yaxis.yesno="n"
  # } else {
  #   yaxis.yesno="s"
  # }
  # 
  
  
  # if(custom.axis==TRUE){
  #   xaxis.yesno="n"
  # } else {
  #   xaxis.yesno="s"
  # }
  # 
  # if(custom.axis.ann==TRUE){
  #   ann.yesno=F
  # } else {
  #   ann.yesno=T
  # }
  
  #create first mass spectrum
  plot(first.mass.spectrum$Intensity~first.mass.spectrum$`m/z`,
       type="l", 
       lty=first.spectrum.line.type,
       xaxt=xaxis.yesno,
       yaxt=xaxis.yesno,
       ann=ann.yesno,
       xlab=xaxis.title,
       ylab=yaxis.title, 
       main=spectrum.title,
       col=first.spectrum.color,
       ylim=c(-spectrum.y.axis.upper.limit,spectrum.y.axis.upper.limit),
       cex.lab=axis.fontsize,
       cex.main=title.fontsize,
       cex.axis=axis.ticks.fontsize,
       lwd=first.spectrum.lwd)
  
  #create second mass spectrum
  points((-second.mass.spectrum$Intensity)~second.mass.spectrum$`m/z`,
         type="l",
         lty=second.spectrum.line.type,
         col=second.spectrum.color,
         lwd=second.spectrum.lwd
  )
  
  #if(custom.axis==TRUE){
    axis(1,
         at=axisTicks(c(first.spectrum.lower.range.limit,first.spectrum.upper.range.limit),log=FALSE,nint = ((first.spectrum.upper.range.limit-first.spectrum.lower.range.limit)/xaxis.interval)),
         padj = custom.axis.pdj,
         cex.axis=axis.ticks.fontsize)
  #}
  
  #if(custom.y.axis==TRUE){
    axis.labels<-axisTicks(c(-spectrum.y.axis.upper.limit,spectrum.y.axis.upper.limit),log=FALSE,nint = ((2*spectrum.y.axis.upper.limit)/yaxis.interval))

      axis(2,
         at=axis.labels,
         padj = custom.y.axis.pdj,
         labels = abs(axis.labels),
         cex.axis = axis.ticks.fontsize)
  #}
  
  #if(custom.axis.ann==TRUE){
    mtext(side=1,
          text=xaxis.title,
          line = custom.axis.ann.line,
          cex=axis.fontsize)
    
    mtext(side=2,
          text=yaxis.title,
          line = custom.axis.ann.line,
          cex=axis.fontsize)
    
    mtext(side=3,
          text=spectrum.title,
          line = custom.axis.ann.title.line,
          cex=title.fontsize)
  #}
  
  if(legend.yesno==1){
    legend(legend.position,
           legend=c(first.spectrum.label,second.spectrum.label),
           lty=c(first.spectrum.line.type,second.spectrum.line.type),
           col=c(first.spectrum.color,second.spectrum.color),
           cex=legend.size,
           lwd=legend.lwd)
  }
  
  #Return
  return.first.spectrum<-list()
  return.first.spectrum$"First Mass Spectrum" <-first.mass.spectrum  
  return.first.spectrum$"yaxp"<-par("yaxp")
  
  return.second.spectrum<-list()
  return.second.spectrum$"Second Mass Spectrum" <-second.mass.spectrum  
  return.second.spectrum$"yaxp"<-par("yaxp")
  
  return.variable<-list()
  return.variable$'First Spectrum'<-return.first.spectrum
  return.variable$'Second Spectrum'<-return.second.spectrum
  
  return(return.variable)
}

