library(gmining)
#Script which creates a corpus from gutenberg using gmining

#Reading list of books to be downloaded
books <- read.table("data/small_dataset.csv", stringsAsFactors=F, row.names=NULL, sep = ',', header = TRUE)
#Get books metadata
metadata_books <- mapply(download_book_metadata, books$Author, books$Title)
#Get books content
content_books <- download_books(metadata_books[1,])

#Make the corpus
myCorpus <- gutenberg_corpus(content_books, metadata_books)

save(myCorpus, file = "data/corpus_small2.RData")
