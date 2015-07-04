function [fuzzy_mandami_otimo, erro_otimo] = constroi_fuzzy(X_trein, Y_trein, X_teste, Y_teste, indice, num_epocas, lag, modo)
    %nesse EP, sera utilizado o metodo grid partition para a criação de
    %estruturas sugeno 
    tipos_imf = cell(8);
    tipos_imf{1} = 'trimf';
    tipos_imf{2} = 'trapmf';
    tipos_imf{3} = 'gbellmf';
    tipos_imf{4} = 'gaussmf';
    tipos_imf{5} = 'gauss2mf';
    tipos_imf{6} = 'pimf';
    tipos_imf{7} = 'dsigmf';
    tipos_imf{8} = 'psigmf';
    tipos_omf = cell(2); 
    tipos_omf{1} = 'linear'; 
    tipos_omf{2} = 'constant'; 
    treinamento = [X_trein Y_trein];
    teste = [X_teste Y_teste];
    limiar_erro = sqrt(0.05); 
    m = 1; %default
    if strcmp(modo,'back-propagation')
        m = 0; 
    else 
        m = 1; 
    end
    if lag <= 2
        pos = 1; 
        matriz = zeros((length(tipos_imf)*length(tipos_omf)),2);
        for i = 1:length(tipos_imf)
            for j = 1:length(tipos_omf)
                f = genfis1(treinamento,3,tipos_imf{i},tipos_omf{j}); 
                [~,~,~,estruturas_fuzzy(pos),~] = anfis(treinamento, f, [num_epocas limiar_erro 0.01 0.9 1.1],[0 0 0 0],teste,m); 
                matriz(pos,2) = pos;
                saida = evalfis(X_trein,estruturas_fuzzy(pos));
                erro = Y_trein - saida; 
                et = 0; 
                for ind = 1:length(erro)
                    et = et+(erro(ind,1)^2); 
                end
                matriz(pos,1) = et; 
                pos = pos + 1; 
            end 
        end
        matriz_ordenada = sortrows(matriz); 
        fuzzy_sugeno_otimo = estruturas_fuzzy(matriz_ordenada(1,2));
    else
        radii = zeros(1,2+lag); 
        for i=1:(1+lag)
            num_clusters_ideal = evalclusters_adj (X_trein(:,i), 'kmeans', 1:10);
            clusters = kmeans(X_trein(:,i),num_clusters_ideal);
            radii(1,i) = devolve_vizinhanca(X_trein(:,i),clusters,num_clusters_ideal);
        end    
        num_clusters_ideal = evalclusters_adj (Y_trein, 'kmeans', 1:10); 
        clusters = kmeans(Y_trein,num_clusters_ideal);
        radii(1,(2+lag)) = devolve_vizinhanca(Y_trein,clusters,num_clusters_ideal);
        fismat = genfis2(X_trein,Y_trein,radii); 
        [~,~,~,fuzzy_sugeno_otimo,~] = anfis(treinamento, fismat, [num_epocas limiar_erro 0.01 0.9 1.1],[0 0 0 0],teste,m);    
    end
    fuzzy_mandami_otimo = sug2mam(fuzzy_sugeno_otimo,X_trein,Y_trein);
    saida = evalfis(X_trein,fuzzy_mandami_otimo);
    erro = Y_trein - saida; 
    erro_otimo = 0; 
    for ind = 1:length(erro)
        erro_otimo = erro_otimo+(erro(ind,1)^2); 
    end
    fuzzy_mandami_otimo.name = strcat('fuzzy',indice);
    writefis(fuzzy_mandami_otimo,strcat('fuzzy',indice,'_mandami.fis'));
    writefis(fuzzy_sugeno_otimo,strcat('fuzzy',indice,'_sugeno.fis'));
end 
