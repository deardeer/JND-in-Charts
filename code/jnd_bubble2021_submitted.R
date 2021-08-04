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

bubble1<- read.csv("../jnd/jnd_bubble.csv")
describeBy(bubble1)
bubble<-bubble1[which(bubble1$jnd>=0.1),] 
bubble<-bubble[which(bubble$jnd<=25),]  

print(nrow(bubble1)-nrow(bubble))


bubble$baseR=bubble$intensity

bubble$logjnd<-log(bubble$jnd)



bubble$facDistance<-factor(bubble$distance)
bubble$facBaseR<-factor(bubble$baseR)
bubble$facUserid<-factor(bubble$userid)
str(bubble)

#type should be 'marginal' in our case£¬default is'sequential'
#ANOVA by lme
md.bubble_full_fac1<-lme(jnd~facBaseR*facDistance,random=~1|facUserid,data=bubble)
anova(md.bubble_full_fac1,type='marginal')
#summary(md.bubble_full_fac1)




#ANOVA by lmer
md.bubble_full_fac2<-lmer(jnd~facBaseR*facDistance+(1|facUserid),data=bubble)
anova(md.bubble_full_fac2,type='marginal')
#summary(md.bubble_full_fac2)

#anova shows both main effects are significant, while interaction is not significant



md.bubble1<-lme(jnd~baseR+distance,random=~1|userid,data=bubble)
summary(md.bubble1)
plot(md.bubble1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)
res=residuals(md.bubble1)
par(mfrow=c(1,1))
qqPlot(res, main="Q-Q plot (bubble)",  col.lines="blue",ylab="residuals  of  linear  model  quantiles",id=FALSE)
ols_test_normality(res)
skewness(res)
kurtosis(res)-3
bptest(md.bubble1)
r.squaredGLMM(md.bubble1)

# log transformation because of heteroscedasticity
md.bubble_log1<-lme(logjnd~baseR+distance,random=~1|userid,data=bubble)
summary(md.bubble_log1)
plot(md.bubble_log1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)
res_log1=residuals(md.bubble_log1)
qqPlot(res_log1, main="Q-Q plot (bubble)",  col.lines="blue",ylab="residuals  of  log-linear  model  quantiles",id=FALSE)
ols_test_normality(res_log1)
skewness(res_log1)
kurtosis(res_log1)-3
bptest(md.bubble_log1)
r.squaredGLMM(md.bubble_log1)

#by lmer
md.bubble_log3<-lmer(logjnd~baseR+distance+(1|facUserid),data=bubble)
summary(md.bubble_log3)
res_log3=residuals(md.bubble_log3)
ols_test_normality(res_log3)
skewness(res_log3)
kurtosis(res_log3)
r.squaredGLMM(md.bubble_log3)

