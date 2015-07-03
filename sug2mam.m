function out_fismat = sug2mam(fismat)
%SUG2MAM Transforma um sistema Fuzzy do tipo Sugeno em  um de tipo Mamdani.

interval = 0.4;

if nargin < 1,
	error('Need a FIS matrix as an input argument.');
end
if ~strcmp(fismat.type, 'sugeno'),
	error('Given FIS matrix is not a Sugeno system!');
end

in_n = length(fismat.input);
out_n = length(fismat.output);

for i = 1:out_n,
    mf_n = length(fismat.output(i).mf);
    for j = 1:mf_n,
        fismat.output(i).mf(j).type='trimf';
		fismat.output(i).mf(j).params=[(fismat.output(i).mf(j).params(in_n+1)-interval) (fismat.output(i).mf(j).params(in_n+1)) (fismat.output(i).mf(j).params(in_n+1)+interval)];
	end
end
fismat.type='mamdani';
fismat.defuzzMethod='centroid';

out_fismat = fismat;
