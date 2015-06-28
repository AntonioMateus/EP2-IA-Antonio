function [X,Y,corte, minimo, maximo] = monta_matrizes (treinamento, teste, lag) 
%Após ler as séries de treinamento e teste e concatená-las em um único
%vetor de entrada, este método cria duas matrizes: uma de entrada e outra 
%de saida esperada. Em cada linha correspondente de entrada e saida
%esperada, temos que para cada conjunto de (1+lag) valores de entrada 
%existe uma única saída esperada. Em outras palavras, para cada conjunto de
%(1+lag) termos da sequência, a saída esperada é o próximo termo da
%sequencia. A matriz X de entrada é construída dentro do loop for. Além
%disso, o método retorna também um valor de "corte", isto é, o indice da
%linha cujo primeiro elemento na matriz de entrada é o ultimo termo da
%série temporal de treinamento. Tal índice é empregado na posterior divisão
%dos conjuntos. 
    tr = le_arquivo_entrada (treinamento);
    minimo = min(tr); 
    maximo = max(tr); 
    test = le_arquivo_entrada (teste); 
    S = concatena_entrada(tr, test);
    n = 1+lag; 
    X = zeros((length(S)-1),n); 
    aux = zeros(1,n);
    Y = zeros((length(S)-1),1); 
    for i=1:(length(S)-1) 
       aux(1,2:n) = aux(1,1:(n-1)); 
       aux(1,1) = S(i,1); 
       X(i,1:(lag+1)) = aux(1,1:(lag+1)); 
       Y(i,1) = S((i+1),1); 
    end 
    corte = 1; 
    while corte < length(X) 
        if X(corte,1)==tr(length(tr),1)
            break; 
        end
        corte = corte + 1; 
    end
end
