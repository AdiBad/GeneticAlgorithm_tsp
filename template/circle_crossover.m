function [c1,c2] = circle_crossover(p1,p2,bounds,Ops)
% Cyclic crossover takes two parents P1,P2 and performs cyclic
% crossover by Davis on permutation strings.  
%
% function [c1,c2] = cyclicXover(p1,p2,bounds,Ops)
% p1      - the first parent ( [solution string function value] )
% p2      - the second parent ( [solution string function value] )
% bounds  - the bounds matrix for the solution space
% Ops     - Options matrix for simple crossover [gen #SimpXovers].

sz = size(p1,2);
c1=zeros(1,sz);
c2=zeros(1,sz);
pt=find(p1==1);
while (c1(pt)==0)
  c1(pt)=p1(pt);
  pt=find(p1==p2(pt));
end
left=find(c1==0);
c1(left)=p2(left);

pt=find(p2==1);
while (c2(pt)==0)
  c2(pt)=p2(pt);
  pt=find(p2==p1(pt));
end
left=find(c2==0);
c2(left)=p1(left);