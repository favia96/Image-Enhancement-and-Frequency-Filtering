function y=mid_tread_quan(x,quan)
    y=zeros(size(x));
    step=quan(1,2)-quan(1,1);
    for i=1:size(x,1)
        for j=1:size(x,2)
            quan_ind=find(quan-step/2<=x(i,j),1,'last');
            y(i,j)=quan(quan_ind);
        end
    end
end