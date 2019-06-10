function t = some_points (n,record,budget, production,price,capital,whether_fit,fit_wind,fit_solar)
%% NOTES
% INPUTS
%   n: how many points in TOTAL (including the left & the right), must >= 2

% OUTPUTS
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
left = RaR_detail (corrweights_left, budget, production,price,capital,whether_fit,fit_wind,fit_solar);

%% min risk (max RaR, lower right point)
[~, ind] = max (record (:,12)) ;
corrweights_right = record (ind,2:10);
right = RaR_detail (corrweights_right, budget, production,price,capital,whether_fit,fit_wind,fit_solar);

%% mid return
funct = frontier(record,'k','-',false);

if n == 2
    t_left = cell2table({left.revenue,left.risk,left.weight},'RowNames',{'left'});
    t_right = cell2table({right.revenue,right.risk,right.weight},'RowNames',{'right'});
    units = {'kEUR', 'kEUR', '%' };
    units = cell2table(units,'RowNames',{'units'});
    names = {'Revenue','RaR','weights'};
    units.Properties.VariableNames = names;
    t_left.Properties.VariableNames = names;
    t_right.Properties.VariableNames = names;
    t = [units; t_left;t_right];

else
    t_left = cell2table({left.revenue,left.risk,left.weight},'RowNames',{'left'});
    t_right = cell2table({right.revenue,right.risk,right.weight},'RowNames',{'right'});
    units = {'kEUR', 'kEUR', '%' };
    units = cell2table(units,'RowNames',{'units'});
    names = {'Revenue','RaR','weights'};
    units.Properties.VariableNames = names;
    t_left.Properties.VariableNames = names;
    t_right.Properties.VariableNames = names;
    t = [units; t_left];
    
    mid_revenue = linspace(left.revenue,right.revenue,n);
    mid_RaR = ppval(funct,mid_revenue);

for j = 2:(n-1)
    
    y = mid_revenue (j);
    x = mid_RaR(j);
    
    distance = zeros(size(record,1),1);

    for i = 1:size(record,1)
        distance(i) = ((record(i,11)-y)/y)^2 + ((record(i,12)-x)/x)^2;
    end

% find the index of the min distance
    [~, ind] = min(distance);
    corrweights_mid = record (ind,2:10);
    mid = RaR_detail (corrweights_mid, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    t_mid = cell2table({mid.revenue,mid.risk,mid.weight});
    t_mid.Properties.VariableNames = names;
    t = [t; t_mid];
end
    t = [t; t_right];
end

%% tabulate


    

    
end