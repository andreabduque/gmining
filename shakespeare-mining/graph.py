import networkx as nx

phrase = ["My", "friend", "I", "miss", "you", "but", "I", float('nan'), "friend", "are", "forever"]
checktuple = lambda x: isinstance(x[0], float) or isinstance(x[1], float)

#Create edges from graph
edges = [(phrase[i],phrase[i+1]) for i in range(len(phrase) - 1)]
#remove nan or weird numbers
edges = [x for x in edges if not checktuple(x)]
nodes = [x for x in phrase if not isinstance(x, float)]
# print(edges)
#Create graph
graph=nx.DiGraph()
graph.add_nodes_from(nodes)
graph.add_edges_from(edges)

print(graph.nodes())
print(graph.edges())
