function [vizinhanca_media] = devolve_vizinhanca (conjunto, clusters, num_clusters) 
    listas_elementos = javaArray('java.util.List',num_clusters);
    iteradores = javaArray('java.util.ListIterator',num_clusters);
    for i=1:num_clusters
        listas_elementos(i) = java.util.LinkedList; 
        iteradores(i) = listas_elementos(i).listIterator(); 
    end    
    for i=1:length(clusters)
        for j=1:num_clusters
            if clusters(i) == j
                iteradores(j).add(conjunto(i));
                break; 
            end    
        end 
        continue; 
    end    
    centros = zeros(num_clusters,1);
    for i = 1:num_clusters 
        elementos = zeros(listas_elementos(i).size(),1);
        for j = 1:length(elementos)
            elementos(j) = listas_elementos(i).get(j-1); 
        end
        centros(i) = mean(elementos);
    end    
    distancias_maximas = zeros(num_clusters,1); 
    for i = 1:num_clusters 
        distancia = zeros(listas_elementos(i).size(),1); 
        for j = 1:length(distancia)
            distancia(j) = abs(centros(i)-listas_elementos(i).get(j-1)); 
        end   
        distancias_maximas(i) = max(distancia); 
    end    
    vizinhanca_media = mean(distancias_maximas); 
end
