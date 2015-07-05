function [] = testa_logica() 
    valores_interval = zeros(99); 
    inicio = 0.01; 
    for i=1:99 
        valores_interval(i) = inicio;
        inicio = inicio + 0.01; 
    end
    erros_treinamento = zeros(99); 
    erros_teste = zeros(99); 
    for i=1:99
        [erros_treinamento(i),erros_teste(i)] = principal('.\Entradas\serie1_trein.txt','.\Entradas\serie1_test.txt',1,1,500,'hybrid',valores_interval(i));
    end
    plot(valores_interval,erros_treinamento); 
    hold on; 
    plot(valores_interval,erros_teste); 
end
