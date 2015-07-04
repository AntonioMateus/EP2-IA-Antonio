function out_fismat = sug2mam(fismat, X_trein, Y_trein)
%SUG2MAM Transforma um sistema Fuzzy do tipo Sugeno em  um de tipo Mamdani.    
    f = fismat;  
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
    
    interval = 0.4;
  
    if nargin < 1,
        error('Numero incorreto de argumentos.');
    end
    if ~strcmp(f.type, 'sugeno'),
    	error('A estrutura fis fornecida nao eh do tipo sugeno!');
    end
    
    f.type='mamdani';
    pos = 1;
    
    for i = 1:length(tipos_and)
        for j = 1:length(tipos_or)
            for k = 1:length(tipos_imp)
                for l = 1:length(tipos_agr)  
                    for m = 1:length(tipos_dfz)
                                
                        f.andMethod = tipos_and{i};

                        f.orMethod = tipos_or{j};

                        f.impMethod = tipos_imp{k};

                        f.aggMethod = tipos_agr{l};

                        f.defuzzMethod = tipos_dfz{m};
                        
                        in_n = length(f.input);
                        out_n = length(f.output);
                        
                        for n = 1:out_n,
                            mf_n = length(f.output(n).mf);
                            for o = 1:mf_n,
                                func = f.output(n).mf(o).type;
                                
                                if strcmp('linear', func)
                                    f.output(n).mf(o).type = 'trimf';    
                                    f.output(n).mf(o).params = [(f.output(n).mf(o).params(in_n+1)-interval) (f.output(n).mf(o).params(in_n+1)) (f.output(n).mf(o).params(in_n+1)+interval)];
                                end
                                
                                if strcmp('constant', func)
                                    f.output(n).mf(o).type = 'trimf';    
                                    f.output(n).mf(o).params = [(f.output(n).mf(o).params(1)-interval) (f.output(n).mf(o).params(1)) (f.output(n).mf(o).params(1)+interval)];
                                end
                                
                            end
                        end

                        estruturas_fuzzy(pos)=f;
                        
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
            end
        end
    end
    
    matriz_ordenada = sortrows(matriz); 
    fuzzy_mamdani_otimo = estruturas_fuzzy(matriz_ordenada(1,2));
    
    out_fismat = fuzzy_mamdani_otimo;
end
