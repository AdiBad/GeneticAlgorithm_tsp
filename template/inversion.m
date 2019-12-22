% low level function for TSP mutation
% reciprocal exchange : two random cities in a tour are swapped
% Representation is an integer specifying which encoding is used
%	1 : adjacency representation
%	2 : path representation
%

function NewChrom = inversion(OldChrom,Representation,cas);

NewChrom=OldChrom;

if Representation==1 
	NewChrom=adj2path(NewChrom);
end

% select two positions in the tour

rndi=zeros(1,2);

while rndi(1)==rndi(2)
	rndi=rand_int(1,2,[1 size(NewChrom,2)]);
end
rndi = sort(rndi);
cas=1;
%Can choose between following mutation options:
if(cas==1)
    %1. Inverse entire subset between given points
    NewChrom(rndi(1):rndi(2)) = NewChrom(rndi(2):-1:rndi(1));
    
elseif (cas==2)
    %2. Swap 2 random points together
    buffer=NewChrom(rndi(1));
    NewChrom(rndi(1))=NewChrom(rndi(2));
    NewChrom(rndi(2))=buffer;

elseif cas==3
    %3. Insert a random point ahead of original position
    NewChrom = [NewChrom(1:rndi(1)) NewChrom(rndi(2)) NewChrom(rndi(1)+1:rndi(2)-1) NewChrom(rndi(2)+1:end)];

elseif cas==4
    %4. Scramble values in subset
    inde = rndi(1):rndi(2);
    valz = NewChrom(inde);
    NewChrom(inde) = valz(randperm(length(inde)));

end

if Representation==1
	NewChrom=path2adj(NewChrom);
end


% End of function
