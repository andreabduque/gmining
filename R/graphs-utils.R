library(igraph)
library(rowr)

#given two pair of words creates an edge
create_edge <- function(pair, node_labels) {
  e <- Map(c, match(pair[1], node_labels), match(pair[2], node_labels))
  return(e)
}

#creates a graph for a book given the nodes
create_graph <- function(x) {
  
  #text_vector <- unlist(strsplit(as.character(x), "\\s+"))
  book_content <- tokenize_words(as.character(x$content))[[1]]
  #computing nodes
  nodes <- unique(book_content)
  #computing edges
  edge_list <- rollApply(book_content, create_edge, node_labels=nodes, window=2)
  
  return (edge_list)
}

