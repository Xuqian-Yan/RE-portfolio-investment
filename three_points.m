function [t,left,mid,right] = three_points (record,budget, production,price,capital)
%% OUTPUTS
%   t: table

%   left/mid/right: structs
%       .price = price;
%       .weight=w * 100; % '%'
%       .revenue = revenue;
%       .risk = risk;
%       if w(9)~=0
%     	.storageparam=storageparam;
%       .storage=storage;
%       .charge=charge;
%       .utilization = utilization;
%       end

%% max return (upper left point)
[~, ind] = max (record (:,11)) ;
corrweights_left = record (ind,2:10);
left = RaR_detail (corrweights_left, budget, production,price,capital);

%% min risk (max RaR, lower right point)
[~, ind] = max (record (:,12)) ;
corrweights_right = record (ind,2:10);
right = RaR_detail (corrweights_right, budget, production,price,capital);

%% mid return
funct = frontier(record,'k','-',false);
mid_return = 0.5 * (left.revenue + right.revenue);
mid_RaR = ppval(funct,mid_return);

distance = zeros(size(record,1),1);

for i = 1:size(record,1)
distance(i) = ((record(i,11)-mid_return)/mid_return)^2 + ((record(i,12)-mid_RaR)/mid_RaR)^2;
end

% find the index of the min distance
[~, ind] = min(distance);
corrweights_mid = record (ind,2:10);
mid = RaR_detail (corrweights_mid, budget, production,price,capital);

%% tabulate
t_left = cell2table({left.revenue,left.risk,left.weight},'RowNames',{'left'});
t_mid = cell2table({mid.revenue,mid.risk,mid.weight},'RowNames',{'middle'});
t_right = cell2table({right.revenue,right.risk,right.weight},'RowNames',{'right'});
units = {'kEUR', 'kEUR', '%' };
units = cell2table(units,'RowNames',{'units'});
names = {'Revenue','RaR','weights'};
units.Properties.VariableNames = names;
t_mid.Properties.VariableNames = names;
t_left.Properties.VariableNames = names;
t_right.Properties.VariableNames = names;
t = [units; t_left;t_mid;t_right];
end