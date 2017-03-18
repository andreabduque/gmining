library(gmining)
library(cibm.utils)
library(GGally)
library(intergraph)

#Load Corpus from Oxford Files
load("/data/corpus/corpus_gutenberg.RData")
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

#creates book network graph list
graphs <- corpus_to_graphs(myCorpus)
save(graphs, file = "data/corpus graphs/gutenberg.RData")

#Computes motifs frequencies
list_freq_motifs <- lapply(graphs, motifs, size = 3)
save(list_freq_motifs, file = "data/frequency motifs/freq_motifs_gutenberg.RData")
#Create motif frequency document matrix


#Remove subgraphs which are not connected
list_freq <- lapply(list_freq_motifs , function(x){
  return(x[-c(1,2,4)])
})
#Motif document matrix
mdm <- matrix(unlist(list_freq), ncol = 40)
motifs_book <-  colSums(mdm);

for (i in 1:ncol(mdm)){
  mdm[,i] = mdm[,i]/motifs_book[i];
}

distMatrix <- distance(mdm, method = "JS", save.dist = FALSE, col.wise = TRUE, file = NULL)
#distMatrix <- dist(t(mdm), method = "euclidean", diag = FALSE, upper = FALSE, p = 2);
#Clusters MST-KNN
gmstknn <- mstknn(k=2, distMatrix,min.size = 3, verbose = FALSE)
authors_vec <- get_authors_list(myCorpus)
titles_vec <- get_titles_list(myCorpus)
V(gmstknn)$authors = unlist(authors_vec)
V(gmstknn)$Title = unlist(titles_vec)
ggnet2(gmstknn, color = "authors",  palette = "Set2", label = "Title", label.trim = 20, label.alpha = 0.75, label.size = 3.5, node.size = 8, layout.exp = 0.5)

