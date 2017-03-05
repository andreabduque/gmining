get_author_file_list <- function(file){
  splited <- strsplit(file, "/")[[1]]
  return(splited[2])

}

get_title_file_list <- function(file){
  splited <- strsplit(file, "/")[[1]]
  title <- gsub("_", " ", strsplit(splited[3], ".txt")[[1]])
  return(title)
}


folder_corpus <- function (dir, authors, titles){
  #Creating Text Corpus from Directory
  myCorpus <- Corpus(dir)
  it <<- 1
  myCorpus <- tm_map(myCorpus, function(x){
    meta(x, "author") <- authors[it]
    meta(x, "title") <- titles[it]
    it <<- it + 1
    x
  }, lazy=FALSE,  mc.cores = 1)

  print(it)

  return (myCorpus)

}
