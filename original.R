#Reading data into R and making necessary manipulation to attain results we presented in Table 1 of the manuscript

Nd<- url("https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/1268/20/nhefs.csv")
nd<-read.csv(Nd)

#data manipulations implemented to make income, marital status and outcome as binary variables
nd$incomeb<-ifelse(nd$income>15,1,0) #income binary
nd$maritalb<-ifelse(nd$marital>2,1,0) #marital status binary
nd$wtb<-ifelse(nd$wt82_71>median(nd$wt82_71,na.rm=TRUE),1,0) #weight binary
nd<-subset(nd,select=c(qsmk,wtb,exercise,sex,age,race,incomeb,maritalb,school,asthma,bronch)) #TYPO missing - in <- (fixed)
factor_names <- c("exercise","incomeb","maritalb","sex","race","asthma","bronch")
nd[,factor_names] <- lapply(nd[,factor_names] , factor)
formulaVars <- paste(names(nd)[-c(2)],collapse = "+")
modelForm <- as.formula(paste0("wtb ~", formulaVars))
modelForm

# THIS DIDN'T RUN
#bin_id <- glm(modelForm,data=nd,family = binomial("log")) 
#bin_id

bin_id <- glm(modelForm,data=nd,family = binomial("log"),start=c(log(846/1629),rep(0,11)))
bin_id

#installing packages
# install.packages("logbin") # already installed 
# install.packages("sandwich") # already installed
library(sandwich)
library(logbin)

#MOVED before logbin as logbin needs cf defined

#Extracting starting values from a Poisson model (we used these in the model)
modelRR <- glm(modelForm,data=nd,family = poisson("log"))
cf<-modelRR$coefficients
cf<-cf[-1]

#logbin regression with adaptive barrier (constrained optimisation) computational method

start.p<-c(log(846/1629),cf)
fit.logbin <- logbin(formula(bin_id), data = nd, 
                     start = start.p, trace = 1,method="ab")


#logbin regression with the Expectation maximization algorithm

start.p<-c(log(846/1629),cf)
fit.logbin <- logbin(formula(bin_id), data = nd, 
                     start = start.p, trace = 1,method="ab")

fit.logbin.em <- update(fit.logbin, method = "em")
# Speed up convergence by using acceleration methods
fit.logbin.em.acc <- update(fit.logbin.em, accelerate = "squarem")
fit.logbin.em.acc


#install.packages("brm") # already done so 
library(brm)
y<-nd$wtb
x<-nd$qsmk
v<-nd[,-c(1,2)]
int<-rep(1,nrow(v))
v<-cbind(int=int,v)
v<-as.matrix(v)
fit.mle=brm(y,x,v,v,'RR','MLE',v,TRUE)
fit.mle

fit.drw = brm(y,x,v,v,'RR','DR',v,TRUE)
fit.dru = brm(y,x,v,v,'RR','DR',v,FALSE)

mean(fit.drw$param.est)
mean(fit.dru$param.est)
sd(fit.drw$param.est)
sd(fit.dru$param.est) 


## make table > summary(bin_id)$coefficients
