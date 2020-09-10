rm(list=ls())
getwd()
setwd("D:/Coursera")
reviews_df<-read.csv("WhiskeyReviews.csv")
library(tidytext)
library(dplyr)
library(corpus)
library(tm)
##############################################################
reviews.corpus= Corpus(VectorSource(reviews_df$Reviews))
reviews.corpus=tm_map(reviews.corpus,tolower)
reviews.corpus=tm_map(reviews.corpus,removePunctuation)
reviews.corpus=tm_map(reviews.corpus,removeNumbers)
stopwords=c(stopwords('english'),'best')
reviews.corpus=tm_map(reviews.corpus,removeWords,stopwords)
df<-data.frame(text = sapply(reviews.corpus, as.character), stringsAsFactors = FALSE)
write.csv(df,"D:/Coursera/mydf.csv")
mydf<-read.csv("D:/Coursera/mydf.csv")
joined_df <- merge(reviews_df, mydf, by.ID = "ID")
df <- subset(joined_df, select = c(Name, Rating,Price,text))
colnames(df)[4] <- "Reviews"
########################################################################

review_df<-reviews_df%>%
  unnest_tokens(word,Reviews)%>%
  anti_join(stop_words)

newdataset<-review_df%>%
  inner_join(get_sentiments("bing"))%>%
  group_by(Name)%>%
  summarise(sentiment=sum(value))%>%
  arrange(desc(sentiment))
str(reviews_df)
testing<-review_df%>%
  inner_join(get_sentiments("bing"))%>%
  group_by(Name)%>%
  count(sentiment)


Afinn<-review_df%>%
  inner_join(get_sentiments("afinn"))%>%
  arrange(desc(value))
newdf<-read.csv("D:/Coursera/Afinn.csv")


write.csv(Afinn,"D:/Coursera/Afinn.csv")
ggplot(Afinn,aes(y=Price,x=value))+geom_point()+geom_line()

library(data.table)
newdata<-setDT(newdf)[,mean(value),by=Name]
finaldf<-merge(newdf,newdata,by="Name")
library(plotly)
plot_ly(x=finaldf$Name,y=finaldf$Price,z=finaldf$V1,type="scatter3d",mode="markers",color=finaldf$Name)
