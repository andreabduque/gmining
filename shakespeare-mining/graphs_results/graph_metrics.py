import networkx as nx
import re
from collections import Counter
import pandas as pd
from bokeh.charts import Bar, output_file, show
from bokeh.charts.attributes import CatAttr

def get_authorship_in_graph(g):
    pass

def get_unique_labels(label_string):
    labels = label_string.split("; ")
    labels_without_uncertain = []

    for item in labels:
        if(not "(?)" in item and not "anon." in item and item is not ""):
            labels_without_uncertain.append(item)

    return labels_without_uncertain

def get_unique_tokens(g):
    author = set([])
    genre = set([])
    author_genre = set([])

    node_data = g.nodes(data=True)
    for node, labels in node_data:
        author_label = labels["author"]
        genre_label = labels["genre"]

        author.update(get_unique_labels(author_label))

        if(labels["genre"] is not ""):
            genre.update([genre_label])
            author_genre.update([author + "_" + genre_label for author in get_unique_labels(labels["author"])])

    return author, genre, author_genre

def get_tokens_scores(graph, random=False):
    node_authors = nx.get_node_attributes(graph, 'author')
    # node_genres = nx.get_node_attributes(graph, 'genre')
    # author, genre, author_genre = get_unique_tokens(graph)
    edges = graph.edges()
    author_score_self = Counter()
    author_score_diff = Counter()

    # if(random):


    for edge1, edge2 in edges:
        unique_edge1_labels = get_unique_labels(node_authors[edge1])
        unique_edge2_labels = get_unique_labels(node_authors[edge2])

        # if(len(unique_edge1_labels) == 0):
        #     print(unique_edge1_labels)
        #     print(node_authors[edge1])
        #
        # if(len(unique_edge2_labels) == 0):
        #     print(unique_edge2_labels)
        #     print(node_authors[edge2])


        if(len(unique_edge1_labels) is 1 and  len(unique_edge2_labels) is 1):
            if(unique_edge1_labels[0] == unique_edge2_labels[0]):
                author_score_self[unique_edge1_labels[0]] += 1
            else:
                author_score_diff[unique_edge1_labels[0]] += 1
                author_score_diff[unique_edge2_labels[0]] += 1
        elif(len(unique_edge1_labels) >= 1 and len(unique_edge2_labels) >= 1):
            diff_items = set(unique_edge1_labels).symmetric_difference(set(unique_edge2_labels))
            self_items = set(unique_edge1_labels) & set(unique_edge2_labels)

            #Todos iguais
            if(len(diff_items) == 0):
                self_val = 1
            else:
                self_val = 0.5

            #Todos diferentes
            if(len(self_items) == 0):
                diff_val = 1
            else:
                diff_val = 0.5

            for item in diff_items:
                author_score_diff[item] += diff_val
            for item in self_items:
                author_score_self[item] += self_val
        #
        # print("atualizado")
        # print("self")
        # print(author_score_self)
        # print("diff")
        # print(author_score_diff)


    return author_score_self, author_score_diff

def get_p_value(graph):
    pass


graph = nx.read_gml("output.gml").to_undirected()
author_score_self, author_score_diff = get_tokens_scores(graph)
self_df = pd.DataFrame.from_dict(author_score_self, orient='index')
diff_df = pd.DataFrame.from_dict(author_score_diff, orient='index')

result = pd.concat([self_df, diff_df], axis=1).fillna(0)
result.columns = ["self", "diff"]
result = result.sort_values(by=['self'], ascending=False)
result_to_print = result.stack().rename_axis(['author','connection_type']).reset_index(name='connections')
print(result_to_print)
p=Bar(result_to_print,  values='connections', group='connection_type', label=CatAttr(columns=['author'], sort=False),  title="Teste", legend='top_right')
output_file("bar_connections.html")
# show(p)
