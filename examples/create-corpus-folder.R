library(gmining)

#Script which creates a corpus from a folder of txt documents

#Reading list of books to be read from disk
books <- read.table("data/book_dataset2.csv", stringsAsFactors=F, row.names=NULL, sep = ',', header = TRUE)

#Each folder inside books_txt folder has an authors name. The books are grouped by authors inside each folder.
authors <- unique(books$Author)

#Get Folders paths names from author list
path_list <- paste0("books_txt/", authors)
dir <- DirSource(path_list)
#Getting Metadata from texts
meta_authors <- unlist(lapply(dir$filelist, get_author_file_list))
meta_titles <- unlist(lapply(dir$filelist, get_title_file_list))
#Creating Corpus
myCorpus <- folder_corpus(dir, meta_authors, meta_titles)
save(myCorpus, file = "data/corpus_older_books.RData")
