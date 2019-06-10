function [revenue,risk]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar)
% INPUTS:
%   w: weights, vector(9), including storage
%   budget: =10'000'000 [EUR]
%   production: [KWh/KW] production per KW installed capacity,
%               = cat(2,solar_N_spec,solar_E_spec,solar_W_spec,solar_S_spec,...
%               wind_N_spec,wind_E_spec,wind_W_spec,wind_S_spec);
%   price: [EUR/MWh]
%   capital: capital cost for installation [EUR/KW], vector (9); ref: IRENA 2017.

% OUTPUTS:
%   revenue: average monthly revenue [kEUR]
%   risk: revenue at risk (similar to CVaR) [kEUR]

%% Investment in power plants
n = length (w);                                 % number of assets (PP & storage)
assets = zeros (1,n);                           % [WM],installed capacity
p = zeros (length(production),(n-1));           % realized production

for i = 1: (n-1)
    assets(i) = w(i) * budget/ capital(i); 
    p (:,i) = production(:,i) * assets(i); 
    wind_hourlyproduction = sum(p(:,5:8),2);
    solar_hourlyproduction = sum(p(:,1:4),2);
end

if whether_fit==false
    hourlyproduction = sum(p,2);                    % [KWh],overall production of each hour
    revenue_production = hourlyproduction/1000.*price/1000;   % [KWh]->[MWh]->[EUR]->[kEUR]
else
    wind_revenue_production = wind_hourlyproduction/1000.*(fit_wind)/1000; 
    solar_revenue_production = solar_hourlyproduction/1000.*(fit_solar)/1000; 
    revenue_production = wind_revenue_production+solar_revenue_production;
end
%% With storage
if w(9)==0
    revenue_arbitrage = 0;
else
    storageparam = storagetech(w(9)*budget,capital(end));
    [revenue_arbitrage,~,~,~] = storage_arbitrage (price, storageparam);
end

%% Calculating indicators
revenue_total = revenue_production + revenue_arbitrage; % [kEUR]
monthlyrevenue = sum(reshape(revenue_total(1:26280),730,36),1)';

revenue = mean(monthlyrevenue);                 % [kEUR]

monthlyrevenue_sort = sort(monthlyrevenue, 'descend');

alpha = 0.9;
x = 33;                                         % 95% quantile between the 34th and 35th value
                                                % 90% quantile between the 32th and 33th value
                                                % 80% quantile between the 28th and 29th value
VaR = monthlyrevenue_sort(x);            
phi = x/36;                              
lambda = (phi-alpha)/(1-alpha);
risk = lambda * VaR + (1-lambda) * mean (monthlyrevenue_sort((x+1):end));

%% TEST
% monthlyproduction = sum(reshape(hourlyproduction(1:26280),730,36),1)';
% revenue_total = revenue_production + revenue_arbitrage; % [kEUR]
% monthlyrevenue = sum(reshape(revenue_total(1:26280),730,36),1)';
% 
% test = (monthlyrevenue*1000)./(monthlyproduction/1000); % [kEUR/KWh]->[EUR/MWh]
% 
% % figure
% % histogram(monthlyrevenue,8);
% % xlabel('Monthly revenue [kEUR]')
% % title('100% investment in Solar South')
% revenue = mean(test);                 % [kEUR]
% 
% test_sort = sort(test, 'descend');
% 
% alpha = 0.90;
% x = 33;                                         % 95% quantile between the 34th and 35th value
%                                                 % 90% quantile between the 32th and 33th value
% VaR = test_sort(x);            
% phi = x/36;                              
% lambda = (phi-alpha)/(1-alpha);
% risk = lambda * VaR + (1-lambda) * mean (test_sort((x+1):end));
end