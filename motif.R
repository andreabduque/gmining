#calculating motif frequencies in book Corpus

#Setting working Directory
dir <- "/home/abd/Documentos/gutenberg-mining"
setwd(dir)
source("R/graphs-utils.R")



myCorpus <- Corpus(VectorSource("three men wait door say holmes oh indeed 
                                seem do thing completely must compliment holmes answer"))

#unique(tokenize_words(song)[[1]])



#extract terms from text
#tdm <- TermDocumentMatrix(myCorpus, control=list(wordLengths=c(1,Inf)))

#creates edge list
list_network <- lapply(myCorpus, create_graph)
list_network <- head(list_network[[1]], -1)

#convert list to matrix
mat_list_network <- do.call(rbind, list_network)

#generate graph from connectivity matrix
graph <- graph_from_edgelist(mat_list_network, directed = TRUE)

#visualize graph
plot(graph, vertex.label=nodes)

#frequencies of ternary motifs
freq_motifs <- motifs(graph, size = 3)
