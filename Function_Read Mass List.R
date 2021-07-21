#NOTE: MAKE IT SO THAT FULLLIST=T RETURNS THE SAME OBJECT AS F  

read.mass.list<-function(mass.list.filepath,
                         Sheet.name,
                         SelectedMasses,
                         tolerance=1,
                         if.peak.conflict.use.max=T,
                         FullListYN=F,
                         mirror=F){
  #mass.list.filepath= file path of mass lsit as character  
  #Sheet.name=Name of excel sheet as string
  #mass.spectrum= mass spectrum as dataframe as returned by mass.spectrum.create function  
  #PlotYN= PlottingYN of mass labes as logicalS
  #FullListYN= Should full mass list be averaged or only specific peaks as logical
  #SelectedMasses= vector of selected masses
  #tolerance= mass tolerance of selected masses as numerical
  #mirror= whether or not the a mirror plot should be labeled
 
  print(mass.list.filepath)
  print(Sheet.name)
  mass.list <- (readxl::read_excel(mass.list.filepath,sheet = Sheet.name,col_types="text",col_names=TRUE,trim_ws = TRUE))
  mass.list[is.na(mass.list)]<-"0"
  
  mass.list$spectrum<-""
  mass.list$spectrum[3]<-colnames(mass.list[1])
  colnames(mass.list)[-ncol(mass.list)]<-mass.list[2,(-ncol(mass.list))]
  
  mass.list<-mass.list[-c(1:2),]
  mass.list[,-ncol(mass.list)]<-as.data.frame(sapply(mass.list[,-ncol(mass.list)],as.numeric))
  
  colnames(mass.list)[which(names(mass.list) == "Intens.")] <- "Intensity"
  colnames(mass.list)[which(names(mass.list) == "m/z")] <- "m.z"
  
  mass.list.picked.peaks<-list()
  
  if(FullListYN==TRUE){
    mass.list.reduced<-list()
    mass.list.reduced$Intensity<-as.numeric(unlist(mass.list[,"Intensity"]))
    mass.list.reduced$m.z<-as.numeric(unlist(mass.list[,"m.z"]))
    mass.list.reduced$SN<-as.numeric(unlist(mass.list[,"SN"]))
    #print(head(mass.list.reduced))
    return(mass.list.reduced)
  }
  
  if(FullListYN==FALSE){
    for(i in 1:length(SelectedMasses)) {
      grabbed.Int<-vector()
      grabbed.m.z<-vector()
      grabbed.SN<-vector()
      
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
      

      mass.list.picked.peaks$Intensity[[i]]<-grabbed.Int
      mass.list.picked.peaks$m.z[[i]]<-grabbed.m.z
      mass.list.picked.peaks$S.N[[i]]<-grabbed.SN

    }
    
    mass.list<-list()
    mass.list$SN<- as.numeric(mass.list.picked.peaks$S.N)
    mass.list$m.z<- as.numeric(mass.list.picked.peaks$m.z)
    mass.list$Intensity<-as.numeric(mass.list.picked.peaks$Intensity)
    
  } 

  return(mass.list)
}