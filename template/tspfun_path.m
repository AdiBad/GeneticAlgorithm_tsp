function ObjVal = tspfun_path(Phen, Dist);
%     max_index = length(Phen(1,:));
    for i=1:length(Phen(:,1))
        ObjVal1(i,1) = Dist(Phen(i,16),Phen(i,1));
    end
	for t=2:size(Phen,2)
        for i=1:length(Phen(:,1))
            disp(t);
            ObjVal1(i,1) = ObjVal1(i,1) + Dist(Phen(i,t-1),Phen(i,t));
        end
    end
    ObjVal = ObjVal1;