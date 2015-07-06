function [erro_treinamento,et] = principal (treinamento, teste, lag, normaliza, num_epocas, intervalo)   
% RETIRAR INTERVALO!!!!
[X,Y,c,~,~] = monta_matrizes(treinamento, teste, lag); 
    [X_trein, X_teste, Y_trein, Y_teste] = separa_conjuntos(X, Y, lag, c);
    if (normaliza==1) 
        [X_trein, Y_trein] = normalizacao_dados(X_trein,Y_trein,lag);
        [X_teste, Y_teste] = normalizacao_dados(X_teste,Y_teste,lag);
%         s = 'com';
%     else 
%         s = 'sem';
    end        
    [fuzzy_sugeno, fuzzy_mamdani, erro_treinamento] = constroi_fuzzy(X_trein,Y_trein,X_teste,Y_teste,treinamento(6),num_epocas, lag, intervalo);
    saida_teste_mam = evalfis(X_teste, fuzzy_mamdani);
    saida_teste_sug = evalfis(X_teste, fuzzy_sugeno);
    erro_teste = Y_teste - saida_teste_mam; 
    et = 0; 
    for i = 1:length(erro_teste)
        et = et + (erro_teste(i,1)^2); 
    end
    plot(saida_teste_mam,'--');
    hold();
    plot(saida_teste_sug,':');
    plot(Y_teste);
    %fprintf ('(%s normalizacao) O erro quadratico total eh de: %1.4f (para teste) e %1.4f (para treinamento)\n', s, et,erro_treinamento);
end
