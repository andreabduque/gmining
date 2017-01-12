#calculating motif frequencies in a book Corpus

#Setting working Directory
dir <- "/home/abd/Documentos/gutenberg-mining"
setwd(dir)
source("R/graphs-utils.R")

#Easy visualization example
#myCorpus <- Corpus(VectorSource("three men wait door say holmes oh indeed 
                                #seem do thing completely must compliment holmes answer"))

#creates book network graph list
graphs <- corpus_to_graphs(myCorpus)
nodes_labels <- get_nodes_labels(myCorpus)
#visualize graph
plot(graphs[[1]], vertex.label=NA, vertex.size=0.5, edge.arrow.size=0.2, edge.width=0.2, edge.arrow.width=0.2)

list_freq_motifs <- lapply(graphs, motifs, size = 3)
#frequencies of ternary motifs
freq_motifs <- motifs(graphs[[1]], size = 3)
