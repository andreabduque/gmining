library(igraph)

path <- "/home/abd/Documentos/gutenberg-mining/data/"
#types of 3-motifs 
for (class in seq(0, 15)) {
  png(filename=paste(path, "motifs", class, sep=''))
  #plot(graph_from_isomorphism_class(3,class, directed = TRUE), vertex.size=6, vertex.label=NA, layout=layout_in_circle)
  plot(graph_from_isomorphism_class(3,class, directed = TRUE), vertex.size=50, vertex.label=NA, layout=layout_in_circle, vertex.color='blue', 
       edge.color='black', edge.arrow.size=2, edge.width=5, edge.arrow.width=2)
  dev.off()
}

