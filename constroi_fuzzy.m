function [fuzzy_sugeno_otimo, fuzzy_mamdani_otimo, erro_otimo] = constroi_fuzzy(X_trein, Y_trein, X_teste, Y_teste, indice, num_epocas, lag, intervalo)
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
    tipos_omf = 'constant';
    treinamento = [X_trein Y_trein];
    teste = [X_teste Y_teste];
    limiar_erro = sqrt(0.05); 

    pos = 1; 
    matriz = zeros(length(tipos_imf),2);
    for i = 1:length(tipos_imf)
        f = genfis1(treinamento,3,tipos_imf{i},tipos_omf); 
        [~,~,~,estruturas_fuzzy(pos),~] = anfis(treinamento, f, [num_epocas limiar_erro 0.01 0.9 1.1],[0 0 0 0],teste); 
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
    matriz_ordenada = sortrows(matriz); 
    fuzzy_sugeno_otimo = estruturas_fuzzy(matriz_ordenada(1,2));
        
    fuzzy_mamdani_otimo = sug2mam(fuzzy_sugeno_otimo,X_trein,Y_trein, intervalo);
    saida = evalfis(X_trein,fuzzy_mamdani_otimo);
    erro = Y_trein - saida; 
    erro_otimo = 0; 
    for ind = 1:length(erro)
        erro_otimo = erro_otimo+(erro(ind,1)^2); 
    end
    fuzzy_mamdani_otimo.name = strcat('fuzzy',indice);
    writefis(fuzzy_mamdani_otimo,strcat('fuzzy',indice,'_mamdami.fis'));
    writefis(fuzzy_sugeno_otimo,strcat('fuzzy',indice,'_sugeno.fis'));
end 
