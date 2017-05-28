library(gmining)
library(cibm.utils)
library(GGally)
library(intergraph)

load("data/corpus/corpus_gutenberg.RData")

#Convert to lower case
myCorpus <- tm_map(myCorpus, content_transformer(tolower))
#remove everything that is not a english letter or space
removeNumPunct <- function(x) gsub("[^[:alpha:][:space:]]*", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeNumPunct))


#Remove chapters stuff
removeChap <- function(x) gsub("(chapter i)|(chapter)|(ii)|(ii)|(iii)|(v)|(iv)|(vi)|(vii)|(viii)|(ix)|(x)|(xi)|(xii)|(xiii)", "", x)
myCorpus <- tm_map(myCorpus, content_transformer(removeChap))


#Stemming Words
copyMyCorpus <- myCorpus
myCorpus <- tm_map(myCorpus, stemDocument)

tdm <- DocumentTermMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))
all <- rownames(tdm)
freqMatrix <<- as.matrix(tdm)

#creates book network graph list
graphs <- corpus_to_graphs(myCorpus)
graph <- graphs[[1]]
#For a book


get_labelled_motif <- function(term, graph){
  subGraph = graph.neighborhood(graph, order = 1, V(graph)[term], mode = 'all')[[1]]
  allMotifs = triad.census(subGraph)
  removeNode = delete.vertices(subGraph, term)
  node1Motifs = allMotifs - triad.census(removeNode)
  labelled <- node1Motifs/allMotifs
  labelled[is.nan(labelled)] <- 0

  return(sum(labelled))
}

global_terms <- colnames(tdm)
modify_freqM <- function(term, graph ){
  if(term %in% global_terms){
    freqMatrix[doc, term] <<- get_labelled_motif(term, graph)
  }else{
    freqMatrix[doc, term] <<- 0
  }
}

doc <<- 1
for(graph in graphs){
  content <- get_book_content(myCorpus[[doc]])
  book_tokens <- tokenize_words(content)[[1]]
  most_frequent <- sort(table(book_tokens), decreasing=TRUE)
  if(length(most_frequent) > 1000){
    most_frequent <- most_frequent[1:1000]
  }
  lapply(names(most_frequent), modify_freqM, graph)
  doc <<- doc + 1
}

#distMatrix <- distance(freqMatrix, method = "JS", save.dist = FALSE, col.wise = TRUE, file = NULL)
#Nao usar col.wise = FALSE
distMatrix <- distance(t(freqMatrix2), method = "JS", save.dist = FALSE, col.wise = TRUE, file = NULL)
gmstknn <- mstknn(k=2, distMatrix,min.size = 3, verbose = FALSE)
authors_vec <- get_authors_list(myCorpus)
titles_vec <- get_titles_list(myCorpus)
V(gmstknn)$authors = unlist(authors_vec)
V(gmstknn)$Title = unlist(titles_vec)
ggnet2(gmstknn, color = "authors",  palette = "Set2", label="Title", label.trim = 20, label.alpha = 0.75, label.size = 3.5, node.size = 8, layout.exp = 0.5)

