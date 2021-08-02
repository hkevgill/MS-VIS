# test.search<-peak.finder(mass.list.filepath = "PTEN+p110a mix vs seq LP.xlsx",
#                          sheet.start=1,
#                          sheet.end=3,
#                          selected.masses=c(1397,1507),
#                          first.data.row=4,
#                          column.mz=1,
#                          column.int=3,
#                          column.sn=4,
#                          tolerance=2,
#                          save.file.name<-"Peak Finder Results",
#                          save.file = F)

peak.finder<-function(mass.list.filepath,
                      sheet.start=1,
                      sheet.end="last",
                      first.data.row=4,
                      column.mz=1,
                      column.int=3,
                      column.sn=4,
                      selected.masses,
                      tolerance,
                      if.peak.conflict.use.max=T,
                      save.file.name="Peak Finder Results",
                      save.file=F){
  
  
  library(readxl)
  library(openxlsx)
  
  # mass.list.filepath<-"PTEN+p110a mix vs seq LP.xlsx"
  # sheet.start<-1
  # sheet.end<-"last"
  # selected.masses<-c(1397,1507)
  # tolerance<-2
  # save.file.name<-"Peak Finder Results"
  # first.data.row<-4
  # column.mz<-1
  # column.int<-3
  # column.sn<-4
  
  print(mass.list.filepath)

  sheets<-readxl::excel_sheets(mass.list.filepath)

  if(sheet.end=="last"){
    sheet.end<-length(sheets)
  } else{
    sheet.end<-as.numeric(sheet.end)
  }
    
  mass.list.results<-list()
  
  for(a in sheet.start:sheet.end){
  #Read in mass list
  print(sheets[a])
  mass.list <- (readxl::read_excel(mass.list.filepath,sheet = sheets[a],col_types="text",col_names=TRUE,trim_ws = TRUE))
  mass.list[is.na(mass.list)]<-"0"

  #reduce mass list to only inlcude the data for m/z, intensity, and SN
  mass.list<-mass.list[-c(1:(first.data.row-1)),]
  mass.list<-as.data.frame(sapply(mass.list,as.numeric))
  colnames(mass.list)[c(column.mz,column.int,column.sn)]<-c("m.z","Intensity","SN")
  
  #From the mass list, extract peak information
  for(i in 1:length(selected.masses)) {
    grabbed.Int<-vector()
    grabbed.m.z<-vector()
    grabbed.SN<-vector()
    grabbed.detected<-vector()
    
    grabbed.Int<- mass.list$Intensity[which((floor(mass.list$m.z)<(selected.masses[i]+tolerance))&(floor(mass.list$m.z)>(selected.masses[i]-tolerance)))]
    grabbed.m.z<- mass.list$m.z[which((floor(mass.list$m.z)<(selected.masses[i]+tolerance))&(floor(mass.list$m.z)>(selected.masses[i]-tolerance)))]
    grabbed.SN<- mass.list$SN[which((floor(mass.list$m.z)<(selected.masses[i]+tolerance))&(floor(mass.list$m.z)>(selected.masses[i]-tolerance)))]
    
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
    
    mass.list.results[[paste("Peak ",selected.masses[i])]]$Sheet[[a]]<-sheets[[a]]

    if(is.na(grabbed.m.z)==T){
      grabbed.detected<-"NO"
    } else if(is.na(grabbed.m.z)==F){
      grabbed.detected<-"YES"
    }
    
    mass.list.results[[paste("Peak ",selected.masses[i])]]$detected[a]<-grabbed.detected
    mass.list.results[[paste("Peak ",selected.masses[i])]]$m.z[a]<-grabbed.m.z
    mass.list.results[[paste("Peak ",selected.masses[i])]]$S.N[a]<-grabbed.SN
    mass.list.results[[paste("Peak ",selected.masses[i])]]$Intensity[a]<-grabbed.Int

    }
    
  }

  #convert lists into data frames
  for(i in 1:length(mass.list.results)){
    mass.list.results[[i]]<-as.data.frame(mass.list.results[[i]])
  }
  
  if(save.file==T){
  #writes excel file
  wb<-createWorkbook()
  
  ##creates as many workbooks as there are selected masses for peak search
  for(i in 1:length(selected.masses)){
    addWorksheet(wb,
                 sheetName = paste("Search Results Peak ",selected.masses[i]))
    writeData(wb,
              sheet = paste("Search Results Peak ",selected.masses[i]),
              x=mass.list.results[[i]])
  }
  
  saveWorkbook(wb,
               file=paste0(save.file.name,".xlsx"),
               overwrite = T)
  }
  
  return(mass.list.results)
}
