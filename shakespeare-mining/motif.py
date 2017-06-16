import igraph
import networkx as nx
import math

#Global funtion
checktuple = lambda x: isinstance(x[0], float) or isinstance(x[1], float)

def makeBookGraph(tokens):
    nodes = list(set([x for x in tokens if not isinstance(x, float)]))
    edges = [(tokens[i],tokens[i+1]) for i in range(len(tokens) - 1)]
    #Removes nan for weird numbers
    edges = [x for x in edges if not checktuple(x)]
    g = igraph.Graph(directed=True)
    g.add_vertices(nodes)
    g.add_edges(edges)

    return g

def getBookMotifFrequency(tokens):
    g = makeBookGraph(tokens)
    profile = g.motifs_randesu(3)

    return [n for n in profile if not math.isnan(n)]

#4 times slower
# def makeBookGraph_nx(tokens):
#     nodes = list(set([x for x in tokens if not isinstance(x, float)]))
#     edges = [(tokens[i],tokens[i+1]) for i in range(len(tokens) - 1)]
#     #Removes nan for weird numbers
#     edges = [x for x in edges if not checktuple(x)]
#     g = nx.DiGraph(directed=True)
#     g.add_nodes_from(nodes)
#     g.add_edges_from(edges)
#
#     return g
#
# def getBookMotifFrequency_nx(tokens):
#     g = makeBookGraph_nx(tokens)
#     now = time.time()
#     profile = nx.triadic_census(g)
#     print(time.time() - now)
#     #Delete graphs which are not motifs
#     del profile['003'], profile['012'], profile['102']
#
#     return profile.values()
    # #Show graph
    # g.vs["label"] = g.vs["name"]
    # igraph.plot(g, margin = 50)
