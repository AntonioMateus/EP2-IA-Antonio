unction [out_fismat] = sug2mam(fismat, X_trein, Y_trein, intervalo)
%SUG2MAM Transforma um sistema Fuzzy do tipo Sugeno em  um de tipo Mamdani.    
    tipos_and = cell(2);
    tipos_and{1} = 'min';
    tipos_and{2} = 'prod';
    
    tipos_or = cell(2);
    tipos_or{1} = 'max';
    tipos_or{2} = 'probor';
    
    tipos_imp = cell(2);
    tipos_imp{1} = 'min';
    tipos_imp{2} = 'prod';
    
    tipos_agr = cell(3);
    tipos_agr{1} = 'max';
    tipos_agr{2} = 'sum';
    tipos_agr{3} = 'probor';
       
    tipos_dfz = cell(5);
    tipos_dfz{1} = 'centroid';
    tipos_dfz{2} = 'bisector';
    tipos_dfz{3} = 'mom';
    tipos_dfz{4} = 'lom';
    tipos_dfz{5} = 'som';
    
    interval = intervalo;
    if nargin < 1,
        error('Numero incorreto de argumentos.');
    end
    if ~strcmp(fismat.type, 'sugeno'),
    	error('A estrutura fis fornecida nao eh do tipo sugeno!');
    end
    f = newfis(fismat.name,'mandami',fismat.andMethod,fismat.orMethod,fismat.impMethod,fismat.aggMethod,fismat.defuzzMethod);
    f.input = fismat.input; 
    in_n = length(f.input);
    mf_n = length(fismat.output(1).mf);
    valores_crisp = zeros(mf_n,1); 
    for o = 1:mf_n 
        func = fismat.output(1).mf(o).type; 
        if strcmp('linear',func)
            valores_crisp(o,1) = fismat.output(1).mf(o).params(in_n+1); 
        elseif strcmp ('constant',func) 
            valores_crisp(o,1) = fismat.output(1).mf(o).params(1);
        end    
    end  
    num_clusters_otimo = length(fismat.input(1).mf);
    clusters = kmeans(valores_crisp,num_clusters_otimo);
    centros = devolve_centro(valores_crisp,clusters,num_clusters_otimo); 
    num_regras = length(fismat.rule);
    distancias = zeros(num_regras,1); 
    for o=1:num_regras
        consequente = fismat.rule(o).consequent; 
        distancias(consequente,1) = abs(valores_crisp(consequente,1)-centros(clusters(consequente,1),1)); 
    end   
    f.output(1).name = fismat.output(1).name; 
    f.output(1).range = fismat.output(1).range;
    %%%%% Aqui começa a eliminação de regras %%%%%%%%%
    for o=1:num_clusters_otimo
        pos = 1; 
        for p=1:length(clusters)
            if clusters(p)==o
               matriz_X(pos,1) = distancias(p,1);
               matriz_X(pos,2) = p; 
            end
            pos = pos+1; 
        end
        matriz_X_ordenada = sortrows(matriz_X);
        consequente_regra_a_ser_mantida = matriz_X_ordenada(1,2); 
        f.output(1).mf(o).name = strcat('out1mf',num2str(o)); 
        f.output(1).mf(o).type = 'trimf'; 
        f.output(1).mf(o).paramams = [centros(o,1)-interval centros(o,1) centros(o,1)+interval]; 
        for p=1:num_regras
            if fismat.rule(p).consequent == consequente_regra_a_ser_mantida
               f.rule(o).antecedent = fismat.rule(p).antecedent; 
               f.rule(o).weight = fismat.rule(p).weight; 
               f.rule(o).connection = fismat.rule(p).connection; 
               f.rule(o).consequent = o;
            end    
        end                             
    end
    pos2 = 1; 
    for i = 1:length(tipos_and)
        for j = 1:length(tipos_or)
            for k = 1:length(tipos_imp)
                for l = 1:length(tipos_agr)  
                    for m = 1:length(tipos_dfz)
                        f.andMethod = tipos_and{i};
                        f.orMethod = tipos_or{j}; 
                        f.defuzzMethod = tipos_dfz{m};
                        f.impMethod = tipos_imp{k}; 
                        f.aggMethod = tipos_agr{l}; 
                        estruturas_fuzzy(pos2)=f;
                        matriz(pos2,2) = pos2;
                        saida = evalfis(X_trein,estruturas_fuzzy(pos2));
                        erro = Y_trein - saida; 
                        et = 0; 
                        for ind = 1:length(erro)
                            et = et+(erro(ind,1)^2); 
                        end
                        matriz(pos2,1) = et;
                        pos2 = pos2 + 1; 
                    end 
                end
            end
        end
    end
    
    matriz_ordenada = sortrows(matriz); 
    fuzzy_mamdani_otimo = estruturas_fuzzy(matriz_ordenada(1,2));
    
    out_fismat = fuzzy_mamdani_otimo;
end
