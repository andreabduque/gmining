library(dplyr)
library(stringr)
library(gutenbergr)
library(tm)
library(NLP)
library(SnowballC)
library(wordcloud)   

#Setting working Directory
dir <- "/home/abd/Documentos/gutenberg-mining"
setwd(dir)
source("R/preprocessing-utils.R")

#Loading corpus for preprocessing
load("data/corpus.RData")

#Convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))

#remove everything that is not a english letter or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))

#Stemming Words
copyMyCorpus <- myCorpus
myCorpus <- tm_map(myCorpus, stemDocument)
#Return to original
myCorpus <- lapply(myCorpus, stemCompletion2, dictionary=copyMyCorpus)
myCorpus <- Corpus(VectorSource(myCorpus))

tdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
dtm <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))  

#Find frequent terms
freq_terms = findFreqTerms(tdm, lowfreq=50)

#Plot word cloud
set.seed(142)   
freq <- colSums(as.matrix(dtm))
wordcloud(names(freq), freq, max.words=100)   


