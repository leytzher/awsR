# Import libraries
library(rPython)
library(XML)


#Set working directory
setwd("~/Documents/asm/R")

#Set keywords: use "+" for space
keywords<-"Horse"
write.csv(keywords,file="keywords.csv",row.names=FALSE,col.names=NA)

# Load the main Python script
python.load("/Users/user/Documents/asm/R/AWS.py")
myURL<-python.get("myURL")

# Load XML file


