mass.spectrum.create<-function(rawfile.path,
                               separator=" ",
                               decimal=".",
                               first.data.row=1,
                               column.mz=1,
                               column.int=2,
                               filetype="csv",
                               headerTF=FALSE,
                               PlotYN=TRUE,
                               xaxis.title="m/z",
                               xaxis.title.highlight=0,
                               yaxis.title="Intensity in a.u.",
                               yaxis.title.highlight=0,
                               spectrum.title="Title",
                               spectrum.title.highlight=0,
                               full.range=FALSE,
                               upper.range.limit,
                               lower.range.limit,
                               xaxis.interval,
                               yaxis.interval,
                               y.axis.lower.limit=NULL,
                               y.axis.upper.limit=NULL,
                               axis.fontsize=1,
                               show.x.axis=T,
                               show.y.axis=T,
                               title.fontsize=1,
                               axis.ticks.fontsize=1,
                               spectrum.color="black",
                               spectrum.line.width=1,
                               spectrum.lty=1,
                               border="o",
                               custom.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                               custom.axis.pdj=0, #Distance adjuster for custom x-axis
                               custom.y.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                               custom.y.axis.pdj=0, #Distance adjuster for custom y-axis
                               custom.axis.ann=FALSE, #TRUE/FALSE if distance of annotations should be off, necessary for custom axis distances
                               custom.axis.ann.line=0, #Distance of custom axis labels to axis
                               custom.axis.ann.title.line, #Distance of main title if ann is F
                               normalization.value=NULL, #If normalize.spectrum is true, all intensity values will be divided by this value
                               normalize.spectrum=F, #Normalize Y/N
                               normalize.spectrum.show.as.percent=F, #Whether or not to show the normalization values as percent 
                               axis.line.width=1
)  

{
  
  #rawfile.path = filepath as character string
  #separator= separatpr in data as character
  #headerTF= headers in raw data yes/no as logical
  #PlotYN= produce plot yes/no as logical
  #xaxis.title= title of x axis as character string
  #yaxis.title= title of y axis as character string
  #spectrum.title= title of spectrum as character string 
  #full.range= full m/z range yes/no as logical
  #upper.range.limit= zoomed in mass range upper limit as integer
  #lower.range.limit= zoomed in mass range lower limit as integer
  #custom.axis= use standard axis (FALSE) or custom axis (TRUE) as logical
  #xaxis.interval= interval of custom x axis as integer
  #spectrum.color= color of mass spectrum
  
  print(rawfile.path)
  print(filetype)

  if(filetype=="csv"){
    mass.spectrum<-read.csv(rawfile.path,sep=separator, dec = decimal,skip=(first.data.row-1), colClasses = "numeric",header = headerTF)
    #mass.spectrum<-read.csv(rawfile.path,sep=separator, dec = decimal,skip=(first.data.row-1), header = headerTF) #Note: UFT-8 csv may cause issues when header is FALSE and colClasses are defined
    mass.spectrum<-data.frame(as.numeric(mass.spectrum[,1]),
                              as.numeric(mass.spectrum[,2]))

    #mass.spectrum<-mass.spectrum[-c(1:(first.data.row-1)),]
    names(mass.spectrum)[c(column.mz,column.int)]<-c("m/z","Intensity")
  }
    
  if(filetype=="MzXML"){
    library("readMzXmlData")
    spectrum.mzxml<-readMzXmlFile(mzXmlFile = rawfile.path)
    mass.spectrum<-data.frame("m/z"=as.numeric(spectrum.mzxml$spectrum[[1]]),
                              "Intensity"=as.numeric(spectrum.mzxml$spectrum[[2]]))

    names(mass.spectrum)<-c("m/z","Intensity")
  }
  
  if(normalize.spectrum==TRUE && normalize.spectrum.show.as.percent==F){
    mass.spectrum[[2]]<-mass.spectrum[[2]]/normalization.value
  }
  
  if(normalize.spectrum==TRUE && normalize.spectrum.show.as.percent==T){
    mass.spectrum[[2]]<-mass.spectrum[[2]]/normalization.value*100
  }
  
  if(full.range==FALSE){
    mass.range <- c(lower.range.limit,upper.range.limit)
    mass.spectrum<-subset(mass.spectrum,mass.spectrum$`m/z`<mass.range[2] & mass.spectrum$`m/z`>mass.range[1])
    
    # if(is.null(y.axis.lower.limit)==TRUE){
    #   y.axis.lower.limit<-min(mass.spectrum[[2]])
    # }
    # 
    # if(is.null(y.axis.upper.limit)==TRUE){
    #   y.axis.upper.limit<-max(mass.spectrum[[2]])
    # }
    # 
    #head(mass.spectrum)
  } else{
    mass.range<-c(min(mass.spectrum$`m/z`),max(mass.spectrum$`m/z`))
  }
  
  if(is.null(y.axis.lower.limit)==TRUE){
    y.axis.lower.limit<-min(mass.spectrum[[2]])
  }
  
  if(is.null(y.axis.upper.limit)==TRUE){
    y.axis.upper.limit<-max(mass.spectrum[[2]])
  }
  
  #check if custom x-axis has been selected
  if(custom.y.axis==TRUE || show.y.axis==F){
    yaxis.yesno="n"
  } else {
    yaxis.yesno="s"
  }
  
  if(custom.axis==TRUE || show.x.axis==F){
    xaxis.yesno="n"
  } else {
    xaxis.yesno="s"
  }
  
  if(custom.axis.ann==TRUE){
    ann.yesno=F
  } else {
    ann.yesno=T
  }
  
  #Set bold/italic status of axis titles
  if(xaxis.title.highlight==1){
    xaxis.title<-bquote(bold(.(xaxis.title)))
  } else if(xaxis.title.highlight==2){
    xaxis.title<-bquote(italic(.(xaxis.title)))
  } else if(xaxis.title.highlight==3){
    xaxis.title<-bquote(underline(.(xaxis.title)))
  }

  if(yaxis.title.highlight==1){
    yaxis.title<-bquote(bold(.(yaxis.title)))
  } else if(yaxis.title.highlight==2){
    yaxis.title<-bquote(italic(.(yaxis.title)))
  } else if(yaxis.title.highlight==3){
    yaxis.title<-bquote(underline(.(yaxis.title)))
  }
  
  if(spectrum.title.highlight==2){
    spectrum.title<-bquote(italic(.(spectrum.title)))
  } else if(spectrum.title.highlight==3){
    spectrum.title<-bquote(underline(.(spectrum.title)))
  }
  
  
  if(PlotYN==TRUE){
    # if(custom.axis==TRUE){
    #   xaxis.yesno="n"
    # } else {
    #   xaxis.yesno="s"
    # }

  if(full.range==TRUE) {
      
      plot(mass.spectrum$Intensity~mass.spectrum$`m/z`,
           type="l", 
           lty=spectrum.lty,
           #xaxt=xaxis.yesno,
           #yaxt=yaxis.yesno,
           xaxt="n",
           yaxt="n",
           ann=ann.yesno,
           xlab=as.expression(xaxis.title),
           ylab=as.expression(yaxis.title), 
           main=as.expression(spectrum.title),
           col=spectrum.color,
           cex.lab=axis.fontsize,
           cex.main=title.fontsize,
           cex.axis=axis.ticks.fontsize,
           lwd=spectrum.line.width,
           bty="n")
    
      box(lwd=axis.line.width,
          bty=border)
      
    } else if(full.range==FALSE){
      plot(mass.spectrum$Intensity~mass.spectrum$`m/z`,
           type="l", 
           lty=spectrum.lty,
           #xaxt=xaxis.yesno,
           #yaxt=yaxis.yesno,
           xaxt="n",
           yaxt="n",
           ann=ann.yesno,
           xlab=as.expression(xaxis.title),
           ylab=as.expression(yaxis.title), 
           main=as.expression(spectrum.title),
           col=spectrum.color,
           ylim=c(y.axis.lower.limit,y.axis.upper.limit),
           cex.lab=axis.fontsize,
           cex.main=title.fontsize,
           cex.axis=axis.ticks.fontsize,
           lwd=spectrum.line.width,
           bty="n")
      
      box(lwd=axis.line.width,
          bty=border)
    }
    
    if(custom.axis==TRUE & show.x.axis==T){
      axis(1,
           at=axisTicks(c(lower.range.limit,upper.range.limit),log=FALSE,nint = ((upper.range.limit-lower.range.limit)/xaxis.interval)),
           padj = custom.axis.pdj,
           cex.axis=axis.ticks.fontsize,
           lwd=axis.line.width)
    } else if(custom.axis==F & show.x.axis==T){
      axis(1,
           cex.axis=axis.ticks.fontsize,
           lwd = axis.line.width)
    }
    
    if(custom.y.axis==TRUE & show.y.axis==T){
      axis(2,
           at=axisTicks(c(y.axis.lower.limit,y.axis.upper.limit),log=FALSE,nint = ((y.axis.upper.limit-y.axis.lower.limit)/yaxis.interval)),
           padj = custom.y.axis.pdj,
           cex.axis = axis.ticks.fontsize,
           lwd=axis.line.width)
    } else if(custom.y.axis==F & show.y.axis==T){
      axis(2,
           cex.axis = axis.ticks.fontsize,
           lwd = axis.line.width)
    }
    
    if(custom.axis.ann==TRUE){
      if(show.x.axis==T){
        mtext(side=1,
              text=as.expression(xaxis.title),
              line = custom.axis.ann.line,
              cex=axis.fontsize)
      }
      
      if(show.y.axis==T){
        mtext(side=2,
              text=as.expression(yaxis.title),
              line = custom.axis.ann.line,
              cex=axis.fontsize)
      }
      
      mtext(side=3,
            text=as.expression(spectrum.title),
            line = custom.axis.ann.title.line,
            cex=title.fontsize)
    }    
  }
  
  return.variable<-list()
  return.variable$"Mass Spectrum" <-mass.spectrum  
  return.variable$"yaxp"<-par("yaxp")
  
  return(return.variable)
}

