function [] = constroi_fuzzy(X, Y, lag, indice, minimo, maximo) 
    nome_fuzzy = strcat('fuzzy',indice); 
    nome_fis = strcat('fuzzy',indice,'.fis');
    a = newfis(nome_fuzzy);
    a.andMethod = 'min';
    a.orMethod = 'max'; 
    a.defuzzMethod = 'centroid';
    a.impMethod = 'min'; 
    a.aggMethod = 'max'; 
    for i=1:(1+lag) 
        conjunto = X(:,i);
        clusters = kmeans(conjunto,3);
        centros = devolve_centro(conjunto,clusters); 
        a.input(i).name=strcat('termo',int2str(i));
        a.input(i).range=[minimo maximo]; 
        a.input(i).mf(1).name = 'fp1';
        a.input(i).mf(1).type = 'trimf';
        cluster1_ubound = ((centros(2)+centros(1))/2); 
        cluster1_lbound = centros(1) - (cluster1_ubound - centros(1));
        a.input(i).mf(1).params = [cluster1_lbound centros(1) cluster1_ubound]; 
        a.input(i).mf(2).name = 'fp2'; 
        a.input(i).mf(2).type = 'trimf';
        cluster2_ubound = (centros(2)+centros(3))/2; 
        cluster2_lbound = cluster1_ubound; 
        a.input(i).mf(2).params = [cluster2_lbound centros(2) cluster2_ubound];
        a.input(i).mf(3).name = 'fp3'; 
        a.input(i).mf(3).type = 'trimf';
        cluster3_lbound = cluster2_ubound; 
        cluster3_ubound = centros(3) + (centros(3)-cluster3_lbound);
        a.input(i).mf(3).params = [cluster3_lbound centros(3) cluster3_ubound];
    end
    clusters = kmeans(Y,3); 
    centros = devolve_centro(Y, clusters);
    a.output(1).name = 'proximoTermo';
    a.output(1).range = [minimo maximo];
    a.output(1).mf(1).name = 'fp1';
    a.output(1).mf(1).type = 'trimf';
    cluster1_ubound = ((centros(2)+centros(1))/2); 
    cluster1_lbound = centros(1) - (cluster1_ubound - centros(1));
    a.output(1).mf(1).params = [cluster1_lbound centros(1) cluster1_ubound]; 
    a.output(1).mf(2).name = 'fp2'; 
    a.output(1).mf(2).type = 'trimf';
    cluster2_ubound = (centros(2)+centros(3))/2; 
    cluster2_lbound = cluster1_ubound; 
    a.output(1).mf(2).params = [cluster2_lbound centros(2) cluster2_ubound];
    a.output(1).mf(3).name = 'fp3'; 
    a.output(1).mf(3).type = 'trimf';
    cluster3_lbound = cluster2_ubound; 
    cluster3_ubound = centros(3) + (centros(3)-cluster3_lbound);
    a.output(1).mf(3).params = [cluster3_lbound centros(3) cluster3_ubound];
    gera_regras(a,indice,lag); 
    if strcmp(indice,'1')
        clusters_possiveis = [1 2 3]; 
        for inicio=1:3 
            antecedentes = zeros(1,(1+lag));
            i = inicio;
            for j=1:(1+lag)
                antecedentes(1,j)=clusters_possiveis(1,mod_adj(i,3)); 
                i = i+1; 
            end
            a.rule(inicio).antecedent = antecedentes; 
            a.rule(inicio).consequent = clusters_possiveis(1,mod_adj(i,3)); 
            a.rule(inicio).weight = 2;
            a.rule(inicio).connection = 1;
        end
        clusters_possiveis = [3 2 2 1 2];
        for regra=1:(length(clusters_possiveis)-lag-1)
            antecedentes = zeros(1,(1+lag));
            i = regra;
            for j=1:(1+lag)
                antecedentes(1,j)=clusters_possiveis(1,i); 
                i = i+1; 
            end
            a.rule(regra+3).antecedent = antecedentes; 
            a.rule(regra+3).consequent = clusters_possiveis(1,i); 
            a.rule(regra+3).weight = 1;
            a.rule(regra+3).connection = 1;
        end    
    end
    %writefis (a, nome_fis); 
    saida = evalfis(X, a);
    erro = Y - saida; 
    et = 0; 
    for i = 1:length(erro)
       et = et + (erro(i,1)^2); 
    end
    fprintf('O EQT eh %1.4f\n',et);
end
