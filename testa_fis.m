function [] = testa_fis(arquivo_fis,entrada,s_esperada)
    f = readfis(arquivo_fis); 
    saida = evalfis(entrada,f); 
    erro = s_esperada - saida; 
    et = 0; 
    for i = 1:length(erro)
        et = et+(erro(i,1)^2); 
    end
    eqm = et/length(erro); 
    fprintf('O erro total eh %1.4f, ao passo que o erro eqm eh %1.4f\n',et,eqm);
end
