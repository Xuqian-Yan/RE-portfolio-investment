function [revenue_arbitrage,storage,charge,utilization] = storage_arbitrage (price, storageparam)

%% NOTES 
%INPUT: 
%   price: [EUR/MWh]
%   storageparam:
%   .ec: energy capacity (ec) [MWh]
%   .pc: power capacity(pc) [MW], applicable for both charging and discharging,
%   .dod: depth of discharge [-]
%   .ef: storagetech.ef: efficiency [-]

%OUTPUT: 
%   revenue_arbitrage: [kEUR]
%   storage and charging/discharging status

%% INITIALIZE
charge = zeros(length(price),1);        % charge (+） & discharge（-） status
storage = zeros(length(price),1);       % start with an empty battery
revenue_arbitrage = zeros(length(price),1);

%% CALCULATIONS: charge->storage->charge (double check)->newproduction
bw = 0.1;                               % allow 10% variation around average price
future = 24-1;                        % prediction range: 24 hours, including this hour
%future = 24*4-1;                        % for 15min time resolution
charge_hours = 0;
discharge_hours = 0;
idle_hours = 0;
utilization = struct;

ec = storageparam.ec * storageparam.dod;% available energy capacity
pc = storageparam.pc;
%pc = storageparam.pc/4;                 % for 15min time resolution
ef = storageparam.ef;

% starting point
i = 1;
price_ave = mean(price(i:(1+future)));  % to compare current price with average price in the following 7 days
if price(i)<price_ave*(1-bw)            % if the current price is low
   charge(i) = pc*ef;                   % charge, positive
else
   charge(i) = 0;
end
storage(i) = charge(i);

% from the second time point    
for i = 2:length(price)-future          
    price_ave = mean(price(i:(i+future)));
    if price(i)<price_ave*(1-bw) 
        charge(i) = pc*ef;
    elseif price(i)>price_ave*(1+bw)    % if the current price is high
        charge(i) = -pc*ef;             % discharge, negative
    else
        charge(i) = 0;                  % dont use the storage
    end
    
    % stored energy status, limited by ec
    storage(i) = storage(i-1) + charge(i);
    if storage(i) > ec     
        storage(i) = ec;
    elseif storage(i)<0
        storage(i)=0;
    end
    
    % charge/diacharge status, limited by both pc and ec
    charge(i) = storage(i) - storage(i-1);
    revenue_arbitrage(i) = - price(i) * charge(i)/1000;
    
    % storage utility
    if charge(i) > 0
       charge_hours = charge_hours + 1;
    elseif charge (i) < 0
       discharge_hours = discharge_hours + 1;  
    else
       idle_hours = idle_hours + 1 ;
    end
    
end
total_hours = charge_hours + discharge_hours + idle_hours;
utilization.charge = charge_hours/total_hours*100; % [%]
utilization.discharge = discharge_hours/total_hours*100;
utilization.idle = idle_hours/total_hours*100;
end