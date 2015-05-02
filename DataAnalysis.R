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

#All as plain text
docs <- tm_map(docs, PlainTextDocument)

##################
# Stage the data

dtm<-DocumentTermMatrix(docs)

# transposing the matrix
tdm<-TermDocumentMatrix(docs)

#######################
# Explore the data

# Organize terms by their frequency
freq<-colSums(as.matrix(dtm))
length(freq)

ord<-order(freq)
########################
# Focus

# remove sparse terms
# this makes a matrix that is 10% empty space, maximum
dtms<-removeSparseTerms(dtm,0.1)

#######################
# Word frequency

freq[head(ord)]

freq[tail(ord)]

#######################
# Check out frequency of frequencies

head(table(freq),20)
tail(table(freq),20)

freq<-colSums(as.matrix(dtms))

findFreqTerms(dtm,lowfreq=50)

wf<-data.frame(word=names(freq),freq=freq)

############################
# Plot word frequencies (words appearing more than 30 times)

p<-ggplot(subset(wf,freq>30),aes(word,freq))
p<-p+geom_bar(stat="identity")
p<-p+theme(axis.text.x=element_text(angle=45, hjust=1))
p

###################################
# Making a word cloud
set.seed(142)
wordcloud(names(freq),freq,min.freq=5)

####################################
# Plot the 100 most frequently used words

set.seed(142)
wordcloud(names(freq),freq,max.words=100)

####################################
# Add some color and plot words occurring at least 20 times

set.seet(142)
wordcloud(names(freq),freq,min.freq=20,scale=c(5,.1), color=brewer.pal(6,"Dark2"))

#######################################
# Plot the 100 most frequently occurring words

set.seed(142)
dark2<-brewer.pal(6,"Dark2")
wordcloud(names(freq),freq,max.words=100,rot.per=0.2, colors=dark2)

##########################################
# Clustering by term similarity

dtmss<-removeSparseTerms(dtm,0.15)

# Hierarchal Clustering
d<-dist(t(dtmss),method="euclidian")
fit<-hclust(d=d, method="ward")
plot(fit,hang=-1)

plot.new()
plot(fit,hang=-1)
groups<-cutree(fit,k=5)  #k= number of clusters
rect.hclust(fit, k=5, border='red')

#########################################
# K-means clustering

d<-dist(t(dtmss), method="euclidian")
kfit<-kmeans(d,2)  #2 clusters
clusplot(as.matrix(d),kfit$cluster, color=T, shade=T, labels=2, lines=0)

