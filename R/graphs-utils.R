library(igraph)
library(rowr)
library(tm)
library(dplyr)
library(stringr)
library(NLP)
library(tokenizers)

#given a pair of words creates an edge
create_edge <- function(pair, node_labels) {
  e <- Map(c, match(pair[1], node_labels), match(pair[2], node_labels))
  return(e)
}

#create nodes from a book content
create_nodes <- function(book_content){
  book_tokens <- tokenize_words(as.character(book_content))[[1]]
  #computing nodes
  nodes <- unique(book_tokens)
  
  return (nodes)
}

#creates a edge list for a book given the nodes
create_edge_list <- function(book_content) {
  #computing unique words in book
  book_tokens <- tokenize_words(as.character(book_content))[[1]]
  #computing graph nodes
  nodes <- create_nodes(book_content)
  #computing edges
  edge_list <- rollApply(book_tokens, create_edge, node_labels=nodes, window=2)
  #removing non existing edge
  edge_list <- head(edge_list, -1)
  
  return (edge_list)
}
#creates graph from a edge list
create_graph <- function(edge_list) {
  #convert list to matrix
  mat_edge_list <- do.call(rbind, edge_list)
  #generate graph from connectivity matrix
  graph <- graph_from_edgelist(mat_edge_list, directed = TRUE)
  
  return (graph)
}
#returns a list of graphs given a book corpus
corpus_to_graphs <- function(myCorpus) {
  list_network <- lapply(myCorpus$content, create_edge_list)
  graphs <-  lapply(list_network, create_graph)
  
  return (graphs)
}
#get nodes labels for each book graph in a corpus
get_nodes_labels <- function(myCorpus) {
  nodes_labels <- lapply(myCorpus$content, create_nodes)
  
  return(nodes_labels)
}
