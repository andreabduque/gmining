#Example of getting a list of motif frequencies in a book Corpus
library(gmining)

#Load small book Corpus containing 2 books
data(corpus_small,package="gmining")
inspect(myCorpus)

#creates book network graph list
graphs <- corpus_to_graphs(myCorpus)
#create list of ternary motif frequencies for each book
list_freq_motifs <- lapply(graphs, motifs, size = 3)
