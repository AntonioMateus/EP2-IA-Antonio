%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tipo de serie - 1, 2, 3, 4
% lag - 0, 1 , 2, 3, ...
% modelo - arquivo com estrutura fuzzy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Para executar o código  digite -  testa(1,1,modelo)
 
function testa(tipo,lag, modelo)
 
%gera o nome do arquivo de treinamento
arq1=strcat('serie',num2str(tipo),'_test.txt');
arq2=strcat('serie',num2str(tipo),'_trein.txt');
fid1 = fopen(arq1,'r');
if fid1<0
    sprintf('Arquivo %s não foi aberto',arq1)
    if fid2<0
        sprintf('Arquivo %s não foi aberto',arq2)
    end
else
    fid2 = fopen(arq2,'r');
    fid1 = fopen(arq1,'r');
    X1 = fscanf(fid1,'%f',[1 Inf]);
    X2 = fscanf(fid2,'%f',[1 Inf]);
    X1=X1'; % transforma em vetor linha
    X2=X2'; % transforma em vetor linha
    [Nts,m]=size(X2); % tamanho do conjunto de teste
    X=[X1;X2]; % Concantena tudo
    [X, param]=normaliza(X); %normaliza toda a serie
    [x,y] = calc_serie(X, lag); % calcula a saida
    [N,m]=size(x); % tamanho do conjunto de treinamento + teste
    Ntr = N - Nts;
    Xtr = x(1:Ntr,:);
    Ytr = y(1:Ntr,:);
    Xts = x(Ntr+1:end,:);
    Yts = y(Ntr+1:end,:);
    save ('dados.mat','Xtr','Ytr','Xts','Yts')
    Str = evalfis(Xtr,modelo);
    Sts = evalfis(Xts,modelo);
    Str=desnormaliza(Str, param);%desnormaliza a saida de treinamento
    Sts=desnormaliza(Sts, param);%desnormaliza a saida de treinamento
    Ytr=desnormaliza(Ytr, param);%desnormaliza a saida de treinamento
    Yts=desnormaliza(Yts, param);%desnormaliza a saida de treinamento   
    erro_tr = sum((Ytr-Str).^2);
    erro_ts = sum((Yts-Sts).^2);
    sprintf('Erro de treinamento %2.2f e teste %2.2f',erro_tr, erro_ts)
    figure(1)
    clf
    subplot(2,1,1)
    plot(1:Ntr,Ytr,'b')
    hold on 
    plot(1:Ntr,Str,'r--')
    ylabel('Treinamento')
    axis([1 Ntr min([Str;Ytr]) max([Str;Ytr])])
    subplot(2,1,2)
    plot(Ntr+1:Ntr+Nts,Yts,'r--')
    hold on 
    plot(Ntr+1:Ntr+Nts,Sts,'b')
    axis([Ntr+1 Ntr+Nts min([Sts;Yts]) max([Sts;Yts])])
    ylabel('Teste')
    
end
 
 
function s=desnormaliza(s, param)
[N,m] = size(s);
maxX = param.max;
minX = param.min;
s= s.*(ones(N,1)*(maxX(end)-minX(end))) + ones(N,1)*minX(end); % desnormaliza a saida
 
 
function [sn, param]=normaliza(s)
[N,m] = size(s);
maxX = max(s,[],1);
minX = min(s,[],1);
param.min = minX;
param.max = maxX;
sn= (s - ones(N,1)*minX)./(ones(N,1)*(maxX-minX));
 
 
 
function [x,y] = calc_serie(s, lag)
if lag==0
    xOld =[];
else
    xOld = zeros(1, lag);
end
x = [];
for i = 1: length(s)-1,
    x = [x;[s(i,1), xOld]]
    if lag~=0
        xOld(1,2:end) = xOld(1,1:end-1);
        xOld(1,1) = x(i,1);
    end
    y(i,1) = s(i+1,1);    
end
x=x(lag+2:end,:);
y=y(lag+2:end,:);
 
