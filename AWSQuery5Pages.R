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
write.csv(keywords,file="keywords.csv",row.names=FALSE,col.names=NA)


SalesRankVector<-c()
BindingVector<-c()
BrandVector<-c()
ColorVector<-c()
ItemHeightVector<-c()
ItemLengthVector<-c()
ItemWeightVector<-c()
ItemWidthVector<-c()
PriceVector<-c()
PackageHeightVector<-c()
PackageLengthVector<-c()
PackageWeightVector<-c()
PackageWidthVector<-c()
TitleVector<-c()


# Loop over 5 pages to extract results
for(i in 1:5){
pageNumber <- i

write.csv(pageNumber,file="page.csv",row.names=FALSE,col.names=NA)

# Load the main Python script
python.load("/Users/user/Documents/asm/R/AWS.py")
myURL<-python.get("myURL")

# Load XML file
query= getURL(myURL)

#read the XML tree into memory
xml<- xmlParse(query)

# Note: the namespace to use is "tns:"
# XPath queries
SalesRank<-"//tns:Item//tns:SalesRank"
Binding<-"//tns:Item//tns:Binding"
Brand<-"//tns:Item//tns:Brand"
Color<-"//tns:Item//tns:Color"
ItemHeight<-"//tns:Item//tns:ItemDimensions//tns:Height"
ItemLength<-"//tns:Item//tns:ItemDimensions//tns:Length"
ItemWeight<-"//tns:Item//tns:ItemDimensions//tns:Weight"
ItemWidth<-"//tns:Item//tns:ItemDimensions//tns:Width"
Price<-"//tns:Item//tns:Amount"
PackageHeight<-"//tns:Item//tns:PackageDimensions//tns:Height"
PackageLength<-"//tns:Item//tns:PackageDimensions//tns:Length"
PackageWeight<-"//tns:Item//tns:PackageDimensions//tns:Weight"
PackageWidth<-"//tns:Item//tns:PackageDimensions//tns:Width"
Title<-"//tns:Item//tns:Title"

#Get the information
salesRank<-unlist(xpathApply(xml,SalesRank,namespaces=namespace,xmlValue))
class(salesRank)<-"numeric"

productBinding<-unlist(xpathApply(xml,Binding,namespaces=namespace,xmlValue))
productBrand<-unlist(xpathApply(xml,Brand,namespaces=namespace,xmlValue))
productColor<-unlist(xpathApply(xml,Color,namespaces=namespace,xmlValue))
productTitle<-unlist(xpathApply(xml,Title,namespaces=namespace,xmlValue))

itemHeight<-unlist(xpathApply(xml,ItemHeight,namespaces=namespace,xmlValue))
class(itemHeight)<-"numeric"

itemLength<-unlist(xpathApply(xml,ItemLength,namespaces=namespace,xmlValue))
class(itemLength)<-"numeric"

itemWeight<-unlist(xpathApply(xml,ItemWeight,namespaces=namespace,xmlValue))
class(itemWeight)<-"numeric"

itemWidth<-unlist(xpathApply(xml,ItemWidth,namespaces=namespace,xmlValue))
class(itemWidth)<-"numeric"

itemPrice<-unlist(xpathApply(xml,Price,namespaces=namespace,xmlValue))
class(itemPrice)<-"numeric"

packageHeight<-unlist(xpathApply(xml,PackageHeight,namespaces=namespace,xmlValue))
class(packageHeight)<-"numeric"

packageLength<-unlist(xpathApply(xml,PackageLength,namespaces=namespace,xmlValue))
class(packageLength)<-"numeric"

packageWeight<-unlist(xpathApply(xml,PackageWeight,namespaces=namespace,xmlValue))
class(packageWeight)<-"numeric"

packageWidth<-unlist(xpathApply(xml,PackageWidth,namespaces=namespace,xmlValue))
class(packageWidth)<-"numeric"


for(product in 1:10){
SalesRankVector<-append(SalesRankVector,salesRank[product])
BindingVector<-append(BindingVector,productBinding[product])
BrandVector<-append(BrandVector,productBrand[product])
ColorVector<-append(ColorVector,productColor[product])
ItemHeightVector<-append(ItemHeightVector,itemHeight[product])
ItemLengthVector<-append(ItemLengthVector,itemLength[product])
ItemWeightVector<-append(ItemWeightVector,itemWeight[product])
ItemWidthVector<-append(ItemWidthVector,itemWidth[product])
PriceVector<-append(PriceVector,itemPrice[product])
PackageHeightVector<-append(PackageHeightVector,packageHeight[product])
PackageLengthVector<-append(PackageLengthVector,packageLength[product])
PackageWeightVector<-append(PackageWeightVector,packageWeight[product])
PackageWidthVector<-append(PackageWidthVector,packageWidth[product])
TitleVector<-append(TitleVector,productTitle[product])



}
}


# Combine results in a dataframe

QueryData<-cbind(TitleVector,BindingVector,BrandVector,ColorVector,PriceVector,SalesRankVector,ItemHeightVector,ItemLengthVector,ItemWidthVector,ItemWeightVector,PackageHeightVector,PackageLengthVector,PackageWidthVector,PackageWeightVector)



