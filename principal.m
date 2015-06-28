function [] = principal (treinamento, teste, lag)   
    [X,Y,c,min,max] = monta_matrizes(treinamento, teste, lag); 
    %[Xn, Yn] = normalizacao_dados(X,Y,lag);
    [X_trein, ~, Y_trein, ~] = separa_conjuntos(X, Y, lag, c); 
    constroi_fuzzy(X_trein,Y_trein,lag,treinamento(17),min,max);
%     fismat = readfis('teste_rede.fis');
%     saida = evalfis(X_trein, fismat);
%     erro = Y_trein - saida; 
%     et = 0; 
%     for i = 1:length(erro)
%         et = et + (erro(i,1)^2); 
%     end
%     eqm = et/length(Y_trein);
end
