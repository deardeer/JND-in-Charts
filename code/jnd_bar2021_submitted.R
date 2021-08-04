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

bar1<- read.csv("../jnd/jnd_bar.csv")
bar<-bar1[which(bar1$jnd>=0.1),]
bar<-bar[which(bar$jnd<=50),]

print(nrow(bar1)-nrow(bar))


bar$logjnd<-log(bar$jnd)

bar$gapNum=bar$distance
bar$baseHeight=bar$intensity


bar$facGapNum<-factor(bar$gapNum)
bar$facBaseHeight<-factor(bar$baseHeight)
bar$facUserid<-factor(bar$userid)
str(bar)


#ANOVA by lme
md.bar_full_fac1<-lme(jnd~facGapNum*facBaseHeight,random=~1|facUserid,data=bar)
anova(md.bar_full_fac1,type='marginal')

#ANOVA by lmer
md.bar_full_fac2<-lmer(jnd~facGapNum*facBaseHeight+(1|facUserid),data=bar)
anova(md.bar_full_fac2,type='marginal')


#only main effect of gapNum is signifancet




md.bar1<-lme(jnd~gapNum,random=~1|userid,data=bar)
summary(md.bar1)
plot(md.bar1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)


res=residuals(md.bar1)
par(mfrow=c(1,1))
qqPlot(res, main="Q-Q plot (bar)",  col.lines="blue",ylab="residuals  of  linear  model  quantiles",id=FALSE)
ols_test_normality(res)
skewness(res)
kurtosis(res)-3
bptest(md.bar1)
r.squaredGLMM(md.bar1)



# log transformation because of heteroscedasticity
#by lme
md.bar_log1<-lme(logjnd~gapNum,random=~1|userid,data=bar)
summary(md.bar_log1)
plot(md.bar_log1,col=rgb(0, 0, 0, 80, maxColorValue=255),pch=20)

res_log1=residuals(md.bar_log1)
par(mfrow=c(1,1))
qqPlot(res_log1, main="Q-Q plot (bar)",  col.lines="blue",ylab="residuals  of  log-linear  model  quantiles",id=FALSE)
ols_test_normality(res_log1)
skewness(res_log1)
kurtosis(res_log1)-3
bptest(md.bar_log1)
r.squaredGLMM(md.bar_log1)


#by lmer
md.bar_log3<-lmer(logjnd~gapNum+(1|facUserid),data=bar)
summary(md.bar_log3)

res_log3=residuals(md.bar_log3)
ols_test_normality(res_log3)
skewness(res_log3)
kurtosis(res_log3)
bptest(md.bar_log3)
r.squaredGLMM(md.bar_log3)




