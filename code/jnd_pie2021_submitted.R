rm(list=ls())
library(nlme)
library(lme4)
library(lmerTest)
library(bootpredictlme4)
library(olsrr)
library(psych)
library(moments)
library(lmtest)
library(MuMIn)
library(car)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


pie1<- read.csv("../jnd/jnd_pie.csv")
describeBy(pie1)
pie<-pie1[which(pie1$jnd>=0.1),]
pie<-pie[which(pie$jnd<=60),]

print(nrow(pie1)-nrow(pie))

pie$gapAngle=pie$distance
pie$baseAngle=pie$intensity

pie$logjnd<-log(pie$jnd)


pie$facGapAngle<-factor(pie$gapAngle)
pie$facBaseAngle<-factor(pie$baseAngle)
pie$facUserid<-factor(pie$userid)
str(pie)

#by lme
#In this case, since fixed-effect model matrix is rank deficient,
#lme will raise a error for such a model included interaction effect, 
#so we use lmer to fit model and run anova.  
#Howerve, result remains the same, only main effect of baseAngle is significant.
md.pie_full_fac1<-lme(jnd~facBaseAngle+facGapAngle,random=~1|facUserid,data=pie)
anova(md.pie_full_fac1,type='marginal')
# summary(md.pie_full_fac1)


#by lmer
md.pie_full_fac2<-lmer(jnd~facBaseAngle*facGapAngle+(1|facUserid),data=pie)
anova(md.pie_full_fac2,type='marginal')
# summary(md.pie_full_fac2)


md.pie1<-lme(jnd~baseAngle,random=~1|userid,data=pie)
summary(md.pie1)
plot(md.pie1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)
res=residuals(md.pie1)
par(mfrow=c(1,1))
qqPlot(res, main="Q-Q plot (pie)",  col.lines="blue",ylab="residuals  of  linear  model  quantiles",id=FALSE)
ols_test_normality(res)
skewness(res)
kurtosis(res)-3   #Excess kurtosis
bptest(md.pie1)
r.squaredGLMM(md.pie1)




# log transformation because of heteroscedasticity
#by lme
md.pie_log1<-lme(logjnd~baseAngle,random=~1|userid,data=pie)
summary(md.pie_log1)
plot(md.pie_log1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)

res_log1=residuals(md.pie_log1)
par(mfrow=c(1,1))
qqPlot(res_log1, main="Q-Q plot (pie)",  col.lines="blue",ylab="residuals  of  log-linear  model  quantiles",id=FALSE)
ols_test_normality(res_log1)
skewness(res_log1)
kurtosis(res_log1)-3   #Excess kurtosis
bptest(md.pie_log1)
r.squaredGLMM(md.pie_log1)


# by lmer
md.pie_log3<-lmer(logjnd~baseAngle+(1|facUserid),data=pie)
summary(md.pie_log3)
plot(md.pie_log3,col='black')
res_log3=residuals(md.pie_log3)
ols_test_normality(res_log3)
skewness(res_log3)
kurtosis(res_log3)
bptest(md.pie_log3)
r.squaredGLMM(md.pie_log3)


