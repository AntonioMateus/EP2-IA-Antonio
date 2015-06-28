function [centros] = devolve_centro (conjunto, clusters) 
    lista1 = java.util.LinkedList; 
    lista2 = java.util.LinkedList; 
    lista3 = java.util.LinkedList; 
    l1 = lista1.listIterator; 
    l2 = lista2.listIterator; 
    l3 = lista3.listIterator; 
    for i=1:length(clusters) 
        if clusters(i)==1 
            l1.add(conjunto(i)); 
        elseif clusters(i)==2
            l2.add(conjunto(i)); 
        else 
            l3.add(conjunto(i)); 
        end
    end
    c1 = zeros(lista1.size(),1); 
    c2 = zeros(lista2.size(),1);
    c3 = zeros(lista3.size(),1); 
    for i=0:(lista1.size()-1)
        c1((i+1),1) = lista1.get(i); 
    end
    for i=0:(lista2.size()-1)
        c2((i+1),1) = lista2.get(i); 
    end
    for i=0:(lista3.size()-1)
        c3((i+1),1) = lista3.get(i); 
    end
    center1 = mean(c1); 
    center2 = mean(c2); 
    center3 = mean(c3); 
    todos_centros = [center1 center2 center3]; 
    centros = sort(todos_centros);    
end 
