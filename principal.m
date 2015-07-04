function [] = principal (treinamento, teste, lag, normaliza, num_epocas, modo)   
    [X,Y,c,~,~] = monta_matrizes(treinamento, teste, lag); 
    [X_trein, X_teste, Y_trein, Y_teste] = separa_conjuntos(X, Y, lag, c);
    if (normaliza==1) 
        [X_trein, Y_trein] = normalizacao_dados(X_trein,Y_trein,lag);
        [X_teste, Y_teste] = normalizacao_dados(X_teste,Y_teste,lag);
        s = 'com';
    else 
        s = 'sem';
    end        
    [fuzzy_mandami, erro_treinamento] = constroi_fuzzy(X_trein,Y_trein,X_teste,Y_teste,treinamento(17),num_epocas, lag, modo);
    saida = evalfis(X_teste, fuzzy_mandami);
    erro_teste = Y_teste - saida; 
    et = 0; 
    for i = 1:length(erro_teste)
        et = et + (erro_teste(i,1)^2); 
    end
    fprintf ('(%s normalizacao) O erro quadratico total eh de: %1.4f (para teste) e %1.4f (para treinamento)\n', s, et,erro_treinamento);
end
