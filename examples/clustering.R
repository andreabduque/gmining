library(gmining)
library(cibm.utils)
library(GGally)
library(intergraph)

#Load Corpus from Oxford Files
#load("data/corpus_older_books.RData")
load("data/corpus_mid2.RData")
#Shuffling books
myCorpus <- sample(myCorpus)

#Convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#remove everything that is not a english letter or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))
#Stemming Words
copyMyCorpus <- myCorpus
myCorpus <- tm_map(myCorpus, stemDocument)
#TD-IDF
tdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
dtm <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
freqMatrix <- as.matrix(tdm)
#Jessen-Shannon distance Matrix between books based on word frequencies
distMatrix <- distance(freqMatrix, method = "JS", save.dist = FALSE, col.wise = TRUE, file = NULL)
#Clusters MST-KNN
gmstknn <- mstknn(k=2, distMatrix,min.size = 4, verbose = FALSE)
authors_vec <- get_authors_list(myCorpus)
titles_vec <- get_titles_list(myCorpus)
V(gmstknn)$authors = unlist(authors_vec)
V(gmstknn)$Title = unlist(titles_vec)
ggnet2(gmstknn, color = "authors",  palette = "Set2", label = "Title", label.trim = 20, label.alpha = 0.75, label.size = 3.5, node.size = 8, layout.exp = 0.5)
