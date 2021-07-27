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
                                    mz.label.sigfigs=2,
                                    int.label.sigfigs=1,
                                    sn.label.sigfigs=1,
                                    if.peak.conflict.use.max=T,
                                    mirror=F,
                                    normalization.value=NULL, #If normalize.spectrum is true, all intensity values will be divided by this value
                                    normalize.spectrum=F #Normalize Y/N
                                    ){
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
  
  #check legnths of label position vectors
  reference.lenght<-length(SelectedMasses)
  rep.times.label.position<-reference.lenght/length(label.position)
  rep.times.label.length<-reference.lenght/length(label.length)
  rep.times.label.title<-reference.lenght/length(label.title)
  rep.times.label.second.title<-reference.lenght/length(label.second.title)
  
  if(rep.times.label.position>1){
    label.position<-rep(label.position,times=ceiling(rep.times.label.position))
  }
  
  if(rep.times.label.length>1){
    label.length<-rep(label.length,times=ceiling(rep.times.label.length))
  }
  
  if(rep.times.label.title>1){
    label.title<-rep(label.title,times=ceiling(rep.times.label.title))
  }
  
  if(rep.times.label.second.title>1){
    label.second.title<-rep(label.second.title,times=ceiling(rep.times.label.second.title))
  }
  
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
  
  if(normalize.spectrum==TRUE){
    #(paste("before norm:",mass.list$"Intensity"))
    mass.list$"Intensity"<-mass.list$"Intensity"/normalization.value
    #print(paste("after norm:",mass.list$"Intensity"))
  }
  
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
      mass.list.picked.peaks$label.title[[i]]<-label.title[[i]] 
      mass.list.picked.peaks$label.second.title[[i]]<-label.second.title[[i]] 
    }
    
    mass.list<-list()
    mass.list$SN<- as.numeric(mass.list.picked.peaks$S.N)
    mass.list$m.z<- as.numeric(mass.list.picked.peaks$m.z)
    mass.list$position.label<- as.numeric(mass.list.picked.peaks$position.label)
    mass.list$label.posx.offset<-as.numeric(mass.list.picked.peaks$label.posx.offset)
    mass.list$label.y.offset<-as.numeric(mass.list.picked.peaks$label.y.offset)
    mass.list$label.title<-mass.list.picked.peaks$label.title
    mass.list$label.second.title<-mass.list.picked.peaks$label.second.title
    
    if(mirror==F){
      mass.list$Intensity<-as.numeric(mass.list.picked.peaks$Intensity)
      mass.list$label.y.offset<-as.numeric(mass.list.picked.peaks$label.y.offset)
    } else if(mirror==T){
      mass.list$Intensity<-(-as.numeric(mass.list.picked.peaks$Intensity))
      mass.list$label.y.offset<-(-as.numeric(mass.list.picked.peaks$label.y.offset))
    }
    
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
    
    
    # if(labels.on[1]==1){
    #   text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
    #        y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance),
    #        labels = label.title[!is.na(mass.list$m.z)],
    #        pos=na.exclude(mass.list$position.label),
    #        cex=fontsize,
    #        col=label.line.col)  
    #   label.position.factor<-label.position.factor+1
    # }
    
    if(labels.on[1]==1){
      text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance),
           labels = mass.list$label.title,
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)  
      label.position.factor<-label.position.factor+1
    }
    
    # if(labels.on[2]==1){
    #   text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
    #        y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance),
    #        labels = label.second.title[!is.na(mass.list$m.z)],
    #        pos=na.exclude(mass.list$position.label),
    #        cex=fontsize,
    #        col=label.line.col)
    #   label.position.factor<-label.position.factor+1
    # }
    
    if(labels.on[2]==1){
      text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-label.position.factor*label.spread.distance),
           labels = mass.list$label.second.title,
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)
      label.position.factor<-label.position.factor+1
    }
    if(labels.on[3]==1){
      text(x=(na.exclude(mass.list$m.z))+(na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*label.spread.distance)), 
           labels =  paste("m/z:",round(na.exclude(mass.list$m.z),digits=mz.label.sigfigs)),
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)  
      label.position.factor<-label.position.factor+1
    }
    
    if(labels.on[4]==1 & mirror==F){
      text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*label.spread.distance)), 
           labels = paste("Intensity:",round(na.exclude(mass.list$Intensity),digits=int.label.sigfigs)),
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)  
      label.position.factor<-label.position.factor+1
    }
    
    if(labels.on[4]==1 & mirror==T){
      text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*label.spread.distance)), 
           labels = paste("Intensity:",round(na.exclude(-mass.list$Intensity),digits=int.label.sigfigs)),
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)  
      label.position.factor<-label.position.factor+1
    }
    
    if(labels.on[5]==1){
      text(x=(na.exclude(mass.list$m.z)+na.exclude(mass.list$label.posx.offset)),
           y=(na.exclude(mass.list$label.y.offset)-(label.position.factor*max.y*label.spread)), 
           labels = paste("S/N:",round(na.exclude(mass.list$SN),digits=sn.label.sigfigs)),
           pos=na.exclude(mass.list$position.label),
           cex=fontsize,
           col=label.line.col)  
      label.position.factor<-label.position.factor+1
    }
  }

  mass.list$spectrum<-spectrum.filepath
  
  return(mass.list)
} 




