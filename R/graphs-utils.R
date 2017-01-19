
#see http://r-pkgs.had.co.nz/man.html#man-functions for help in documentation
#https://support.rstudio.com/hc/en-us/articles/200486508-Building-Testing-and-Distributing-Packages
#https://cran.r-project.org/doc/manuals/r-patched/R-exts.html

#' \code{get_book_content} returns the content from a book from a VCorpus
#' @param corpus_element An element from a Vcorpus
#' @return A character vector containing the book content
#' @examples
#' myCorpus <- Corpus(VectorSource("three men wait door say holmes oh indeed seem do thing completely must compliment holmes answer"))
#' #get content from first book in VCorpus
#' get_book_content(myCorpus[[1]])

get_book_content <- function(corpus_element){
  book_content <- as.character(corpus_element$content)
  return(book_content)
}

#' \code{create_edge} returns an edge for a pair of words in a book graph.
#'
#' @param pair A character vector of length 2.
#' @param node_labels A character vector of generic length, containing all unique tokens extracted from a text.
#' @return A list of integer vectors of length 2 each, containing the positions of the pair in the token vector.
#' @examples
#' create_edge(c("three", "men"), c("three", "men", "are", "waiting"))
#' create_edge(c("three", "are"), c("three", "men", "are", "waiting"))

#given a pair of words creates an edge
create_edge <- function(pair, node_labels) {
  e <- Map(c, match(pair[1], node_labels), match(pair[2], node_labels))
  return(e)
}

#' \code{create_nodes} returns all nodes for a book graph.
#'
#' @param book_content A character vector containing all words from a text book.
#' @return A character vector containing unique tokens from  book.
#' @examples
#' create_nodes("three men wait door say holmes oh indeed seem do thing completely must compliment holmes answer")

#create nodes labels from a book content
create_nodes <- function(book_content){
  book_tokens <- tokenize_words(book_content)[[1]]
  #computing nodes
  nodes <- unique(book_tokens)

  return (nodes)
}
#' \code{create_edge_list} returns all edges of a book graph.
#'
#' @param book_content A character vector containing all words from a text book.
#' @return A list of edge pairs (integer vector of length 2) of the co-ocurrence graph book text.
#' @examples
#' create_edge_list("three men wait door say holmes oh indeed seem do thing completely must compliment holmes answer")

#creates an edge list for a book given the nodes
create_edge_list <- function(corpus_element) {
  #computing unique words in book
  book_content <- get_book_content(corpus_element)
  book_tokens <- tokenize_words(book_content)[[1]]
  #computing graph nodes
  nodes <- create_nodes(book_content)
  #computing edges
  edge_list <- rollApply(book_tokens, create_edge, node_labels=nodes, window=2)
  #removing non existing edge
  edge_list <- head(edge_list, -1)

  return (edge_list)
}

#' \code{create_graph} creates a graph from an edge list list
#'
#' @param edge_list A list of integer vectors of length 2
#' @return An igraph graph.
#' @examples
#' create_graph(list(c(1,2), c(2,3), c(3,1)))

#creates graph from a edge list
create_graph <- function(edge_list) {
  #convert list to matrix
  mat_edge_list <- do.call(rbind, edge_list)
  #generate graph from connectivity matrix
  graph <- graph_from_edgelist(mat_edge_list, directed = TRUE)

  return (graph)
}
#' \code{corpus_to_graphs} returns a  list of co-ocurrence book graphs from a book Corpus. It's not optimized,
#' so it might take a while for a large Corpus.
#' @param myCorpus a tm VCorpus
#' @return A list of igraph graphs
#' @examples
#' myCorpus <- Corpus(VectorSource("three men wait door say holmes oh indeed
#'                                seem do thing completely must compliment holmes answer"))
#'book_graphs <- corpus_to_graphs(myCorpus)

#returns a list of graphs given a book corpus
corpus_to_graphs <- function(myCorpus) {
  list_network <- lapply(myCorpus, create_edge_list)
  graphs <-  lapply(list_network, create_graph)

  return (graphs)
}

#' \code{get_nodes_labels} returns a  list of nodes labels for each book in a Corpus
#' @param myCorpus a tm VCorpus
#' @return A list of tokens
#' @examples
#' myCorpus <- Corpus(VectorSource("three men wait door say holmes oh indeed
#'                                seem do thing completely must compliment holmes answer"))
#'nodes_labels <- get_nodes_labels(myCorpus)

#get nodes labels for each book graph in a corpus
get_nodes_labels <- function(myCorpus) {
  corpus_text <- lapply(myCorpus, get_book_content)
  nodes_labels <- lapply(corpus_text, create_nodes)
  return(nodes_labels)
}

