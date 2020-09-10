rm(list=ls())
library(dplyr)
library(rvest)

link="https://www.whiskyadvocate.com/ratings-reviews/?search=&submit=&brand_id=0&rating=0&price=0&category=0&styles_id=4&issue_id=0"
page= read_html(link)
reviews<-page%>%html_nodes(".entry-meta+ .review-text p")%>%html_text
newreviews<-data.frame(reviews)
write.csv(newreviews,"D:/Coursera/reviewsdata.csv")
library(rvest)
library(dplyr)
install.packages("data.table")
library(data.table)

link = "https://www.whiskyadvocate.com/ratings-reviews/?search=&submit=&brand_id=0&rating=0&price=0&category=0&styles_id=4&issue_id=0"
page = read_html(link)

Name = page %>% html_nodes("h1") %>% html_text()
Rating = page %>% html_nodes("#post-25 h2") %>% html_text()
Price = page %>% html_nodes("span~ span+ span") %>% html_text()
Reviewer = page %>% html_nodes (".review-text+ .review-text span") %>% html_text()
Review_date = page %>% html_nodes("span+ a") %>% html_text()
ID = 1:268
Whiskey_database = data.frame(ID, Name, Rating, Price, Reviewer, Review_date, stringsAsFactors = FALSE)

write.csv(Whiskey_database,"C:/Users/Hp/Documents/Whiskey.csv")
getwd()

reviews<- read.csv("reviewsdata.csv")
joined_df <- merge(Whiskey_database, reviews, by.ID = "ID")
head (joined_df)

write.csv(joined_df, "C:/Users/Hp/Documents/Whiskeyreviews.csv")