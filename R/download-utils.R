#Removes ID from the book table
dropdown <-function(df) {
  df$gutenberg_id <- NULL
  return(df)
}

