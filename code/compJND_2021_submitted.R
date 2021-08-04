rm(list=ls())
library(MixedPsy)
# library(tidyverse)
# library(broom)
library('ggplot2')
type="bar"
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
cwd<-paste("../stat/",type,sep="")
dest_wd=paste("../stat_dest/dest_",type,sep="")
fileList<-list.files(path=cwd,pattern="*.csv")
for (i in 1:length(fileList)) 
{
  tryCatch({
    print(i)
    file=paste(cwd,fileList[i],sep="/")
    data<-read.csv(file)
    data$YesProp=data$Yes/data$Total
    print(fileList[i])
    #Ref£ºhttp://rstudio-pubs-static.s3.amazonaws.com/446272_5aa2c51c9e2d4e71b2cf8229e205ce64.html#
    fit.glm=glm(cbind(Yes, Total - Yes) ~ X,family = binomial(logit),data=data)
    #Ref:http://rstudio-pubs-static.s3.amazonaws.com/446272_5aa2c51c9e2d4e71b2cf8229e205ce64.html
    jnd=log(3)/coef(fit.glm)[[2]]
    filename=c(fileList[i])
    jnd_value=c(jnd)
    pse_value=-coef(fit.glm)[[1]]/coef(fit.glm)[[2]]
    
    
    #Ref:http://www.dlinares.org/psychopract.html#fitting-using-generalized-linear-models
    xseq <- seq(data$X[1],  data$X[nrow(data)], .01)
    yseq <- predict(fit.glm, data.frame(X = xseq), type = 'response')
    curve <- data.frame(xseq, yseq)
    
    p <- ggplot() +theme_set(theme_bw())+theme(axis.text.x = element_text(size = 13),axis.text.y = element_text(size = 13))+
      geom_point(data = data, aes(x = X, y = YesProp)) +
      geom_line(data = curve,aes(x = xseq, y = yseq))
    
    p

    
    
    df <- data.frame( filename, jnd_value, stringsAsFactors=FALSE )},error=function(e)
    {
      write.table(paste(fileList[i],"have an error"),paste(paste("jnd_error",type,sep="_"),".txt",sep=""),append=T)},
    finally = 
    {
      write.table(df, paste(dest_wd,paste(fileList[i],".txt",sep=""),sep="/"),row.names=FALSE)
    })
}