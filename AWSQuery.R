# Import libraries
library(rPython)
library(XML)
library(RCurl)
library(xml2)

#Set working directory
setwd("~/Documents/asm/R")

#Set Amazon namespace
namespace<-c(tns="http://webservices.amazon.com/AWSECommerceService/2011-08-01")

#Set keywords: use "+" for space
keywords<-"Car+Litter+Bag"
pageNumber <- 5
write.csv(keywords,file="keywords.csv",row.names=FALSE,col.names=NA)
write.csv(pageNumber,file="page.csv",row.names=FALSE,col.names=NA)

# Load the main Python script
python.load("/Users/user/Documents/asm/R/AWS.py")
myURL<-python.get("myURL")

# Load XML file
query= getURL(myURL)

#read the XML tree into memory
xml<- xmlParse(query)

# Note: the namespace to use is "tns:"

priceQuery<-"//tns:Item//tns:SalesRank"
price<-unlist(xpathApply(xml,priceQuery,namespaces=namespace,xmlValue))
class(price)<-"numeric"
price<-price/100


