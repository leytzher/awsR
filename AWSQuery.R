# Import libraries
library(rPython)
library(XML)
library(RCurl)


#Set working directory
setwd("~/Documents/asm/R")

#Set keywords: use "+" for space
keywords<-"Bali"
write.csv(keywords,file="keywords.csv",row.names=FALSE,col.names=NA)

# Load the main Python script
python.load("/Users/user/Documents/asm/R/AWS.py")
myURL<-python.get("myURL")

# Load XML file
query= getURL(myURL)

# Parse XML file
xmlfile<-xmlTreeParse(query)

# use xmlRoot to access the top node
xmltop = xmlRoot(xmlfile)


