#V0 Separated 'Mass spectrum functions V50' into a calculation and a mass spectrum visualization part
#190723 V1(old) to V1: Overlay Peak List: Changed how grabbed m/zs are handled so it allows for peaks which are not found without crashing the script. Additionally, changed the way the labels are drawn (no longer in for loop) 
#190821 V1 to V1: Overlay peak list: Changed max.y calculation to use difference of max-min instead of max
#210528 V2 to V2: Fixed error in peak overlay which caused crash. Lines 600-610 which handles hand-over of peak paramters was changed to inlcude 'as.numeric'

#Create mass spectrum with overlaid mass spectra------
##Overlays two mass spectra 
mass.spectrum.overlaid.create<-function(first.spectrum.rawfile.path, #Filepath of the first of two mass spectra to be overlaid, character
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
                                        legend.lwd=1 #Linewidth of lines in legend
                                        ){
  
  
  #get mass spectrum from file
  print(first.spectrum.rawfile.path)
  full.first.mass.spectrum <- read.csv(first.spectrum.rawfile.path,sep=separator, header=headerTF)
  names(full.first.mass.spectrum)<-c("m/z","Intensity")
  
  print(second.spectrum.rawfile.path)
  full.second.mass.spectrum <- read.csv(second.spectrum.rawfile.path,sep=separator, header=headerTF)
  names(full.second.mass.spectrum)<-c("m/z","Intensity")
  
  #Pull specified mass ranges 
  first.spectrum.mass.range <- c(first.spectrum.lower.range.limit,first.spectrum.upper.range.limit)
  second.spectrum.mass.range <- c(second.spectrum.lower.range.limit,second.spectrum.upper.range.limit)
  
  first.mass.spectrum<-subset(full.first.mass.spectrum,full.first.mass.spectrum$`m/z`<first.spectrum.mass.range[2] & full.first.mass.spectrum$`m/z`>first.spectrum.mass.range[1])
  second.mass.spectrum<-subset(full.second.mass.spectrum,full.second.mass.spectrum$`m/z`<second.spectrum.mass.range[2] & full.second.mass.spectrum$`m/z`>second.spectrum.mass.range[1])
  
  #Check if y-axis limits have been set  
  if(is.null(spectrum.y.axis.lower.limit)==TRUE){
    spectrum.y.axis.lower.limit<-min(first.mass.spectrum[[2]])
  }
  
  if(is.null(spectrum.y.axis.upper.limit)==TRUE){
    spectrum.y.axis.upper.limit<-max(first.mass.spectrum[[2]])
  }
  
  #check if custom x-axis has been selected
  if(custom.y.axis==TRUE){
    yaxis.yesno="n"
  } else {
    yaxis.yesno="s"
  }
  
  if(custom.axis==TRUE){
    xaxis.yesno="n"
  } else {
    xaxis.yesno="s"
  }
  
  if(custom.axis.ann==TRUE){
    ann.yesno=F
  } else {
    ann.yesno=T
  }
  
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
       ylim=c(spectrum.y.axis.lower.limit,spectrum.y.axis.upper.limit),
       cex.lab=axis.fontsize,
       cex.main=title.fontsize,
       cex.axis=axis.ticks.fontsize,
       lwd=first.spectrum.lwd)
  
  #create second mass spectrum
  points(second.mass.spectrum$Intensity~second.mass.spectrum$`m/z`,
         type="l",
         lty=second.spectrum.line.type,
         col=second.spectrum.color,
         lwd=second.spectrum.lwd
  )
  
  if(custom.axis==TRUE){
    axis(1,
         at=axisTicks(c(first.spectrum.lower.range.limit,first.spectrum.upper.range.limit),log=FALSE,nint = ((first.spectrum.upper.range.limit-first.spectrum.lower.range.limit)/xaxis.interval)),
         padj = custom.axis.pdj,
         cex.axis=axis.ticks.fontsize)
  }
  
  if(custom.y.axis==TRUE){
    axis(2,
         at=axisTicks(c(spectrum.y.axis.lower.limit,spectrum.y.axis.upper.limit),log=FALSE,nint = ((spectrum.y.axis.upper.limit-spectrum.y.axis.lower.limit)/yaxis.interval)),
         padj = custom.y.axis.pdj,
         cex.axis = axis.ticks.fontsize)
  }
  
  if(custom.axis.ann==TRUE){
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
  }
  
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

#Create mass spectrum with inset mass spectrum (e.g. main spectrum is zoomed-in peaks, inset spectrum is zoomed out spectrum)------
mass.spectrum.inset.create<-function(rawfile.path,
                                     separator=" ",
                                     headerTF=FALSE,
                                     xaxis.title="m/z",
                                     yaxis.title="Intensity in a.u.",
                                     spectrum.title,
                                     main.spectrum.upper.range.limit,
                                     main.spectrum.lower.range.limit,
                                     custom.axis=FALSE,
                                     xaxis.interval,
                                     main.spectrum.y.axis.lower.limit=NULL,
                                     main.spectrum.y.axis.upper.limit=NULL,
                                     axis.fontsize=1,
                                     title.fontsize=1,
                                     spectrum.color="black",
                                     inset.spectrum.position=c(0.07,0.5, 0.5, 1),
                                     inset.spectrum.axis.size=0.25,
                                     inset.spectrum.upper.range.limit,
                                     inset.spectrum.lower.range.limit){
  
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
  #inset.spectrum.position= value of par(fig) value, vector of c(x1,x2,y1,y2)
  #inset.spectrum.axis.size=cex value for inset spectrum. numeric
  #inset.spectrum.upper.range.limit= zoomed in mass range upper limit as integer
  #inset.spectrum.lower.range.limit= zoomed in mass range lower limit as integer
  
  #get mass spectrum from file
  print(rawfile.path)
  full.mass.spectrum <- read.csv(rawfile.path,sep=separator, header=headerTF)
  names(full.mass.spectrum)<-c("m/z","Intensity")
  
  #Pull specified mass ranges 
  main.spectrum.mass.range <- c(main.spectrum.lower.range.limit,main.spectrum.upper.range.limit)
  inset.spectrum.mass.range <- c(inset.spectrum.lower.range.limit,inset.spectrum.upper.range.limit)
  
  main.mass.spectrum<-subset(full.mass.spectrum,full.mass.spectrum$`m/z`<main.spectrum.mass.range[2] & full.mass.spectrum$`m/z`>main.spectrum.mass.range[1])
  inset.mass.spectrum<-subset(full.mass.spectrum,full.mass.spectrum$`m/z`<inset.spectrum.mass.range[2] & full.mass.spectrum$`m/z`>inset.spectrum.mass.range[1])
  
  #Check if y-axis limits have been set  
  if(is.null(main.spectrum.y.axis.lower.limit)==TRUE){
    main.spectrum.y.axis.lower.limit<-min(main.mass.spectrum[[2]])
  }
  
  if(is.null(main.spectrum.y.axis.upper.limit)==TRUE){
    main.spectrum.y.axis.upper.limit<-max(main.mass.spectrum[[2]])
  }
  
  #check if custom x-axis has been selected
  if(custom.axis==TRUE){
    xaxis.yesno="n"
  } else {
    xaxis.yesno="s"
  }
  
  #create inset mass spectrum
  par(fig = inset.spectrum.position,ann=FALSE)  
  plot(inset.mass.spectrum$Intensity~inset.mass.spectrum$`m/z`,
       typ="l",
       col=spectrum.color,
       cex.axis=inset.spectrum.axis.size
  )
  
  #create main mass spectrum
  par(fig=c(0,1,0,1),ann=TRUE,new=TRUE)
  plot(main.mass.spectrum$Intensity~main.mass.spectrum$`m/z`,
       typ="l", 
       xaxt=xaxis.yesno,
       xlab=xaxis.title,
       ylab=yaxis.title, 
       main=spectrum.title,
       col=spectrum.color,
       ylim=c(main.spectrum.y.axis.lower.limit,main.spectrum.y.axis.upper.limit),
       cex.lab=axis.fontsize,
       cex.main=title.fontsize)
  
  if(custom.axis==TRUE){
    axis(1,at=axisTicks(c(mass.range[1],mass.range[2]),log=FALSE,nint = ((mass.range[2]-mass.range[1])/xaxis.interval)))
  }
  
  #Return
  return.variable<-list()
  return.variable$"Mass Spectrum" <-main.mass.spectrum  
  return.variable$"yaxp"<-par("yaxp")
  
  return(return.variable)
}

#Single mass spectrum---------
mass.spectrum.create<-function(rawfile.path,
                               separator=" ",
                               headerTF=FALSE,
                               PlotYN=TRUE,
                               xaxis.title="m/z",
                               yaxis.title="Intensity in a.u.",
                               spectrum.title,
                               full.range=FALSE,
                               upper.range.limit,
                               lower.range.limit,
                               xaxis.interval,
                               yaxis.interval,
                               y.axis.lower.limit=NULL,
                               y.axis.upper.limit=NULL,
                               axis.fontsize=1,
                               title.fontsize=1,
                               axis.ticks.fontsize=1,
                               spectrum.color="black",
                               spectrum.line.width=1,
                               spectrum.lty=1,
                               custom.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                               custom.axis.pdj=0, #Distance adjuster for custom x-axis
                               custom.y.axis=FALSE, #TRUE/FAlSE if the steps of the x-axis have custom intervals, boolean
                               custom.y.axis.pdj=0, #Distance adjuster for custom y-axis
                               custom.axis.ann=FALSE, #TRUE/FALSE if distance of annotations should be off, necessary for custom axis distances
                               custom.axis.ann.line=0, #Distance of custom axis labels to axis
                               custom.axis.ann.title.line) #Distance of main title if ann is F
                               
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
  mass.spectrum <- read.csv(rawfile.path,sep=separator, header=headerTF)
  names(mass.spectrum)<-c("m/z","Intensity")
  
  if(full.range==FALSE){
    mass.range <- c(lower.range.limit,upper.range.limit)
    mass.spectrum<-subset(mass.spectrum,mass.spectrum$`m/z`<mass.range[2] & mass.spectrum$`m/z`>mass.range[1])
    
    if(is.null(y.axis.lower.limit)==TRUE){
      y.axis.lower.limit<-min(mass.spectrum[[2]])
    }
    
    if(is.null(y.axis.upper.limit)==TRUE){
      y.axis.upper.limit<-max(mass.spectrum[[2]])
    }
    
    #head(mass.spectrum)
  } else{
    mass.range<-c(min(mass.spectrum$`m/z`),max(mass.spectrum$`m/z`))
  }
  
  #check if custom x-axis has been selected
  if(custom.y.axis==TRUE){
    yaxis.yesno="n"
  } else {
    yaxis.yesno="s"
  }
  
  if(custom.axis==TRUE){
    xaxis.yesno="n"
  } else {
    xaxis.yesno="s"
  }
  
  if(custom.axis.ann==TRUE){
    ann.yesno=F
  } else {
    ann.yesno=T
  }
  
  if(PlotYN==TRUE){
    if(custom.axis==TRUE){
      xaxis.yesno="n"
    } else {
      xaxis.yesno="s"
    }
    
    if(full.range==TRUE) {
      
      plot(mass.spectrum$Intensity~mass.spectrum$`m/z`,
           type="l", 
           lty=spectrum.lty,
           xaxt=xaxis.yesno,
           yaxt=xaxis.yesno,
           ann=ann.yesno,
           xlab=xaxis.title,
           ylab=yaxis.title, 
           main=spectrum.title,
           col=spectrum.color,
           cex.lab=axis.fontsize,
           cex.main=title.fontsize,
           cex.axis=axis.ticks.fontsize,
           lwd=spectrum.line.width)
     
    } else if(full.range==FALSE){
      
      plot(mass.spectrum$Intensity~mass.spectrum$`m/z`,
           type="l", 
           lty=spectrum.lty,
           xaxt=xaxis.yesno,
           yaxt=xaxis.yesno,
           ann=ann.yesno,
           xlab=xaxis.title,
           ylab=yaxis.title, 
           main=spectrum.title,
           col=spectrum.color,
           ylim=c(y.axis.lower.limit,y.axis.upper.limit),
           cex.lab=axis.fontsize,
           cex.main=title.fontsize,
           cex.axis=axis.ticks.fontsize,
           lwd=spectrum.line.width)
      }

    if(custom.axis==TRUE){
      axis(1,
           at=axisTicks(c(lower.range.limit,upper.range.limit),log=FALSE,nint = ((upper.range.limit-lower.range.limit)/xaxis.interval)),
           padj = custom.axis.pdj,
           cex.axis=axis.ticks.fontsize)
    }
    
    if(custom.y.axis==TRUE){
      axis(2,
           at=axisTicks(c(y.axis.lower.limit,y.axis.upper.limit),log=FALSE,nint = ((y.axis.upper.limit-y.axis.lower.limit)/yaxis.interval)),
           padj = custom.y.axis.pdj,
           cex.axis = axis.ticks.fontsize)
    }
    
    if(custom.axis.ann==TRUE){
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
    }    
  }
  
  return.variable<-list()
  return.variable$"Mass Spectrum" <-mass.spectrum  
  return.variable$"yaxp"<-par("yaxp")
  
  return(return.variable)
}

#Overlay peak list------------
mass.spectrum.label.peaks<-function(mass.list.filepath,
                                    Sheet.name,
                                    mass.spectrum,
                                    PlotYN=T,
                                    FullListYN=F,
                                    SelectedMasses,
                                    tolerance=1,
                                    label.line.width=1,
                                    label.line.lty=1,
                                    label.line.col="blue",
                                    label.length=0.1,
                                    label.spread=0.1,
                                    label.title="title",
                                    label.second.title="",
                                    labels.on=c(1,0,1,1,1),
                                    label.position="r",
                                    fontsize=1.25,
                                    if.peak.conflict.use.max=T){
  #mass.list.filepath= file path of mass lsit as character  
  #Sheet.name=Name of excel sheet as string
  #mass.spectrum= mass spectrum as dataframe as returned by mass.spectrum.create function  
  #PlotYN= PlottingYN of mass labes as logicalS
  #FullListYN= Should full mass list be averaged or only specific peaks as logical
  #SelectedMasses= vector of selected masses
  #tolerance= mass tolerance of selected masses as numerical
  #label.length= length of the line connecting the peak to the label as a fraction of the mass range, integer  
  #label.spread= spread of text on y-axis as a fraction of y-axis, integer  
  #label.title= peak label as vector
  #label.second.title= label below peak label
  #labels.on= which information to display as vector (e.g. c(1,1,1,1,1), pos 1=title, pos 2=second label, pos 3=m/z, pos 4=intensity, pos 4=S/N)
  #label.position= label position left/toplef or right of peak as string.l=topleft of peak, L=left-middle of peak, r=topright of peak,R=middle-right of peak. Alternatively, a numerical value corresponding to the desired y-position can be given. If value is positive, label will be on the right, if it is negative, label is on the left.
  
  print(mass.list.filepath)
  print(Sheet.name)
  mass.list <- (readxl::read_excel(mass.list.filepath,sheet = Sheet.name,col_types="text",col_names=TRUE,trim_ws = TRUE))
  mass.list[is.na(mass.list)]<-"0"
  
  mass.list$spectrum<-""
  mass.list$spectrum[3]<-colnames(mass.list[1])
  colnames(mass.list)[-ncol(mass.list)]<-mass.list[2,(-ncol(mass.list))]
  
  mass.list<-mass.list[-c(1:2),]
  mass.list[,-ncol(mass.list)]<-as.data.frame(sapply(mass.list[,-ncol(mass.list)],as.numeric))
  
  spectrum.filepath<-mass.list$spectrum[1]
  colnames(mass.list)[which(names(mass.list) == "Intens.")] <- "Intensity"
  colnames(mass.list)[which(names(mass.list) == "m/z")] <- "m.z"
  
  mass.list.picked.peaks<-list()
  
  max.y<-(mass.spectrum[[2]][2]-mass.spectrum[[2]][1])
  
  mass.range <- (max(mass.spectrum[[1]]$`m/z`)-min(mass.spectrum[[1]]$`m/z`))
  
  label.length.distance<-(mass.range*label.length)
  label.spread.distance<-((max.y*label.spread))
  
  if(FullListYN==FALSE){
    for(i in 1:length(SelectedMasses)) {
      grabbed.Int<-vector()
      grabbed.m.z<-vector()
      grabbed.SN<-vector()

      position.label<-vector()
      label.posx.offset<-vector()
      label.y.offset<-vector()
      connect.line.x1<-vector()
      connect.line.y1<-vector()
      
      grabbed.Int<- mass.list$Intensity[which((floor(mass.list$m.z)<(SelectedMasses[i]+tolerance))&(floor(mass.list$m.z)>(SelectedMasses[i]-tolerance)))]
      grabbed.m.z<- mass.list$m.z[which((floor(mass.list$m.z)<(SelectedMasses[i]+tolerance))&(floor(mass.list$m.z)>(SelectedMasses[i]-tolerance)))]
      grabbed.SN<- mass.list$SN[which((floor(mass.list$m.z)<(SelectedMasses[i]+tolerance))&(floor(mass.list$m.z)>(SelectedMasses[i]-tolerance)))]
      
      if(length(grabbed.m.z)==0){
        grabbed.Int<-NA
        grabbed.m.z<-NA
        grabbed.SN<-NA
      }
        
      if(length(grabbed.m.z)>1){
        if(if.peak.conflict.use.max==T){
          grabbed.Int<-grabbed.Int[which.max(grabbed.SN)]
          grabbed.m.z<-grabbed.m.z[which.max(grabbed.SN)]
          grabbed.SN<-grabbed.SN[which.max(grabbed.SN)]
        }
        
        if(if.peak.conflict.use.max==F){
          grabbed.Int<-grabbed.Int[which.min(grabbed.SN)]
          grabbed.m.z<-grabbed.m.z[which.min(grabbed.SN)]
          grabbed.SN<-grabbed.SN[which.min(grabbed.SN)]
        }
      }
 
      if(is.na(grabbed.m.z)==F){
        if(label.position[i]=="r"){
          position.label<-4
          label.posx.offset<-label.length.distance[i]
          label.y.offset<-grabbed.Int
        }
        
        if(label.position[i]=="l"){
          position.label<-2
          label.posx.offset<-(-label.length.distance[i])
          label.y.offset<-grabbed.Int
        }
        
        if(label.position[i]=="L"){
          position.label<-2
          label.posx.offset<-(-label.length.distance[i])
          label.y.offset<-(mass.spectrum[[2]][2]/2)
        }
        
        if(label.position[i]=="R"){
          position.label<-4
          label.posx.offset<-label.length.distance[i]
          label.y.offset<-(mass.spectrum[[2]][2]/2)

        }
        
        if(label.position[i]!="r"&label.position[i]!="R"&label.position[i]!="l"&label.position[i]!="L"&&as.numeric(label.position[i])>0){
          position.label<-4
          label.posx.offset<-label.length.distance[i]
          label.y.offset<-abs(as.numeric(label.position[i]))
        }
        
        if(label.position[i]!="r"&label.position[i]!="R"&label.position[i]!="l"&label.position[i]!="L"&&as.numeric(label.position[i])<0){
          position.label<-2
          label.posx.offset<-(-label.length.distance[i])
          label.y.offset<-abs(as.numeric(label.position[i]))
        }

      } else {
        position.label<-NA
        label.posx.offset<-NA
        label.y.offset<-NA
      }

      mass.list.picked.peaks$Intensity[[i]]<-grabbed.Int
      mass.list.picked.peaks$m.z[[i]]<-grabbed.m.z
      mass.list.picked.peaks$S.N[[i]]<-grabbed.SN
      mass.list.picked.peaks$position.label[[i]]<-position.label
      mass.list.picked.peaks$label.posx.offset[[i]]<-label.posx.offset
      mass.list.picked.peaks$label.y.offset[[i]]<-label.y.offset
     
      #print(mass.list.picked.peaks)
     }
    
    #print(mass.list$label.posx.offset)
    
    # mass.list<-list()
    # mass.list$Intensity<-mass.list.picked.peaks$Intensity
    # mass.list$SN<- mass.list.picked.peaks$S.N
    # mass.list$m.z<- mass.list.picked.peaks$m.z
    # mass.list$position.label<- mass.list.picked.peaks$position.label
    # mass.list$label.posx.offset<-mass.list.picked.peaks$label.posx.offset
    # mass.list$label.y.offset<-mass.list.picked.peaks$label.y.offset
    # 
    
    mass.list<-list()
    mass.list$Intensity<-as.numeric(mass.list.picked.peaks$Intensity)
    mass.list$SN<- as.numeric(mass.list.picked.peaks$S.N)
    mass.list$m.z<- as.numeric(mass.list.picked.peaks$m.z)
    mass.list$position.label<- as.numeric(mass.list.picked.peaks$position.label)
    mass.list$label.posx.offset<-as.numeric(mass.list.picked.peaks$label.posx.offset)
    mass.list$label.y.offset<-as.numeric(mass.list.picked.peaks$label.y.offset)
    
  } 

  if(PlotYN==TRUE && length(na.exclude(mass.list$m.z))!=0 ){
     segments(x0=na.exclude(mass.list$m.z),
             y0=na.exclude(mass.list$Intensity),
             (x1=na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
             y1=na.exclude(mass.list$label.y.offset),
             col=label.line.col,
             lwd=label.line.width,
             lty=label.line.lty)

      label.position.factor<-0
      # print("x")
      # print((na.exclude(unlist(mass.list$m.z))+na.exclude(unlist(mass.list$label.posx.offset))))
      # print("y")    
      # print((na.exclude(unlist(mass.list$label.y.offset))-label.position.factor*label.spread.distance))
      # print("label 1")
      # print(label.title[!is.na(mass.list$m.z)])
      # print("label 2")
      # print(label.second.title[!is.na(mass.list$m.z)])
      # print("label 3")
      # print(paste("m/z:",round(na.exclude(unlist(mass.list$m.z)),2)))
      # print("label 4")
      # print(paste("Intensity:",round(na.exclude(unlist(mass.list$Intensity,0)))))
      # print("label 5")
      # print(paste("S/N:",round(na.exclude(unlist(mass.list$SN,0)))))
      
      if(labels.on[1]==1){
        text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
             y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance),
             labels = label.title[!is.na(mass.list$m.z)],
             pos=na.exclude(mass.list$position.label),
             cex=fontsize)  
        label.position.factor<-label.position.factor+1
      }
      if(labels.on[2]==1){
        text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
             y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance), 
            labels = label.second.title[!is.na(mass.list$m.z)],
             pos=na.exclude(mass.list$position.label),
             cex=fontsize)  
        label.position.factor<-label.position.factor+1
      }
      
      if(labels.on[3]==1){
        text(x=(na.exclude(mass.list$m.z))+(na.exclude(mass.list$label.posx.offset)),
             y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*label.spread.distance)), 
             labels =  paste("m/z:",round(na.exclude(mass.list$m.z),2)),
             pos=na.exclude(mass.list$position.label),
             cex=fontsize)  
        label.position.factor<-label.position.factor+1
      }
      
      if(labels.on[4]==1){
        text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
             y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*label.spread.distance)), 
             labels = paste("Intensity:",round(na.exclude(mass.list$Intensity,0))),
             pos=na.exclude(mass.list$position.label),
             cex=fontsize)  
        label.position.factor<-label.position.factor+1
      }
      
      if(labels.on[5]==1){
        text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
             y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*max.y*label.spread)), 
             labels = paste("S/N:",round(na.exclude(mass.list$SN,0))),
             pos=na.exclude(mass.list$position.label),
             cex=fontsize)  
        label.position.factor<-label.position.factor+1
      }
     }

  mass.list$spectrum<-spectrum.filepath
  
  return(mass.list)
} 





