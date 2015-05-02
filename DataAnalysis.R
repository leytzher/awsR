# This gets data from AWSQuery5Pages.R
source('/Users/user/Documents/asm/R/AWSQuery5Pages.R')

###################### TEXT MINING ##########################

#load packages
library('tm')
library('SnowballCC')
library('RColorBrewer')
library('ggplot2')
library('wordcloud')
library('biclust')
library('cluster')
library('igraph')
library('fpc')

#Set working directory
setwd("~/Documents/asm/R")

#Save Product Title and Description
write.csv(data[1:2],file="~/Documents/asm/R/TextMining/texts",row.names=FALSE,col.names=NA)

# Loading files
cname<-file.path("~/Documents/asm/R/TextMining")
docs<-Corpus(DirSource(cname))
summary(docs)

##################
# Pre-processing

#remove punctuation
docs<-tm_map(docs,removePunctuation)

#removing special characters

for(j in seq(docs))
{
        docs[[j]]<-gsub("/"," ", docs[[j]])
        docs[[j]]<-gsub("@"," ", docs[[j]])
        docs[[j]]<-gsub("\\|"," ", docs[[j]])
        docs[[j]]<-gsub("#"," ", docs[[j]])        
}

#removing numbers
docs<-tm_map(docs,removeNumbers)

#convert to lowercase
docs<-tm_map(docs,tolower)

# remove stopwords (a, and, also, the, etc)
docs<-tm_map(docs,removeWords,stopwords("english"))

# remove words that add little value
docs<-tm_map(docs,removeWords,c("product", "around", "br","x","b","pb","bp"))

# combine words that should stay together

for (j in seq(docs)){
        docs[[j]]<-gsub("large compartment","large_compartments", docs[[j]])
}

# "stemming" remove common word endings ("ing","es","s")
docs<-tm_map(docs,stemDocument)

#strip whitespace
docs<-tm_map(docs,stripWhitespace)


##################
# Pre-processing





