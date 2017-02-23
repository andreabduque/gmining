#Downloads metadata from project Gutenberg given an author and a title string,
#Saving in a table which contents id, title and author for that book
download_book_metadata <- function (aut, tit) {

  #Download metadata
  metadata <- gutenberg_metadata %>%
    filter(str_detect(author, aut),
           str_detect(title, tit),
           language == "en",
           has_text) %>%
    distinct( gutenberg_id, title, author)

  #if it founds more than one book, picks only first
  return(as.list(head(metadata,1)))
}


#Removes ID from the book table
dropdown <-function(df) {
  df$gutenberg_id <- NULL
  return(df)
}

#returns a list of books containig only the text
download_books <- function (gutenberg_id_list) {
  #Download books
  receive <- lapply(gutenberg_id_list, gutenberg_download)
  #Keeping only the book content
  receive <- lapply(receive, dropdown)

  return (receive)
}

#Creates a Corpus with books content, gutenberg id, title and author
gutenberg_corpus <- function (content, metadata) {
  #Creating text Corpus
  myCorpus <- Corpus(VectorSource(content))
  #Adding metadata to Corpus
  #myCorpus <- lapply(myCorpus, adding_meta, metadata)
  it <<- 1
  myCorpus <- tm_map(myCorpus, function(x){
    meta(x, "author") <- metadata[3, it]
    meta(x, "title") <- metadata[2, it]
    meta(x, "gutenberg_id") <- metadata[1,it]
    it <<- it + 1
    x
  }, lazy=FALSE,  mc.cores = 1)

  print(it)

  return (myCorpus)
}

