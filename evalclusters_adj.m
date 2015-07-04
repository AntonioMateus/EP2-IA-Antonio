function [num_clusters_medio] = evalclusters_adj (X, metodo, intervalo) 
    num_clusters = zeros(4,1); 
    objeto = evalclusters(X,metodo,'Silhouette','kList',intervalo);
    num_clusters(1,1) = objeto.OptimalK;
    objeto = evalclusters(X,metodo,'CalinskiHarabasz','kList',intervalo);
    num_clusters(2,1) = objeto.OptimalK;
    objeto = evalclusters(X,metodo,'GAP','kList',intervalo);
    num_clusters(3,1) = objeto.OptimalK;
    objeto = evalclusters(X,metodo,'DaviesBouldin','kList',intervalo);
    num_clusters(4,1) = objeto.OptimalK;
    num_clusters_medio = round(mean(num_clusters));
end
