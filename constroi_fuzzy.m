function [fuzzy_sugeno_otimo, erro_otimo] = constroi_fuzzy(X, Y, indice, num_epocas)
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
    entrada = [X Y];
    pos = 1; 
    matriz = zeros((length(tipos_imf)*length(tipos_omf)),2);
    for i = 1:length(tipos_imf)
        for j = 1:length(tipos_omf)
            f = genfis1(entrada,4,tipos_imf{i},tipos_omf{j}); 
            estruturas_fuzzy(pos) = anfis(entrada, f, [num_epocas 0.05 0.01 0.9 1.1],[0 0 0 0]); 
            matriz(pos,2) = pos;
            saida = evalfis(X,estruturas_fuzzy(pos));
            erro = Y - saida; 
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
    erro_otimo = matriz_ordenada(1,1); 
    writefis(fuzzy_sugeno_otimo,strcat('fuzzy',indice,'.fis')); 
end 
